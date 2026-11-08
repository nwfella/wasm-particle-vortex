/**
 * vortex.ts — the entire physics core of the toroidal-vortex particle demo.
 *
 * 500,000 particles live in three interleaved f32 buffers that JS reads
 * directly as typed-array views over the module's linear memory (zero copy).
 * Every per-frame calculation happens here, in WebAssembly: the vortex flow
 * field, tube confinement, curl-noise turbulence, mouse repulsion, a uniform
 * grid counting sort (spatial hash) with a per-cell force field, and the
 * integration. JS only uploads the position buffer to WebGL and draws it.
 *
 * Buffer layout (stride 4 everywhere, so one array = one GPU attribute):
 *   pos  x, y, z, speed²      the .w lane is speed²/MAX², written by step()
 *   vel  vx, vy, vz, _
 *   prp  ph, _, _, _          speed jitter (0.78..1.22)
 *   dbg  density             one f32 per particle, for the grid-debug view
 *
 * Performance shape — the reason this runs at all with 500k particles:
 *   - the per-particle loop is ONE pass containing exactly 1 sqrt and 2 div,
 *     all of which the confinement term reuses;
 *   - anything that depends only on POSITION and is expensive (density
 *     pressure, curl noise) is evaluated once per GRID CELL into a force field,
 *     so a particle pays one 4-float load for it;
 *   - no trig at all in the loop: the poloidal frame rotation is one sin/cos
 *     pair per step;
 *   - cell indices are cached from the physics pass, so the next frame's grid
 *     build is a pure integer pass over an Int32Array.
 */
const MAXP: i32 = 500000;

/* uniform grid: 32^3 cells over [-WORLD, WORLD]^3 — 128 KB of cell records,
   which is the size that keeps the random per-particle lookup in L2 */
const GRID_N: i32 = 32;
const GRID_CELLS: i32 = GRID_N * GRID_N * GRID_N;
const WORLD: f32 = 1.8;
const INV_CELL: f32 = <f32>GRID_N / (2.0 * WORLD);

/* torus geometry */
const TORUS_R: f32 = 1.0;
const TUBE_A: f32 = 0.44;
const TUBE_A2: f32 = TUBE_A * TUBE_A;
const TAU: f32 = 6.283185307179586;
const MAX_SPEED: f32 = 3.4;
const INV_MAX2: f32 = 1.0 / (MAX_SPEED * MAX_SPEED);

/* ── storage ─────────────────────────────────────────────────────────────── */
const bufPos = new Float32Array(MAXP * 4);
const bufVel = new Float32Array(MAXP * 4);
const bufPrp = new Float32Array(MAXP * 4);
const bufDbg = new Float32Array(MAXP);
const bufIdx = new Int32Array(MAXP);            // cached cell index per particle
const bufSrt = new Int32Array(MAXP);            // particle indices, cell-ordered
const bufCel = new Float32Array(GRID_CELLS * 4); // per cell: force.xyz, count
const bufOff = new Int32Array(GRID_CELLS + 1);  // prefix sum of the counts
const bufCur = new Int32Array(GRID_CELLS);      // scatter cursor
const bufOcc = new Int32Array(GRID_CELLS);      // indices of non-empty cells
const bufNoise = new Float32Array(1024);        // precomputed hash-noise values
const bufOut = new Float32Array(4);             // flowSample() result slot

let P: usize = 0, V: usize = 0, R: usize = 0;
let D: usize = 0, IDX: usize = 0, SRT: usize = 0, CEL: usize = 0;
let OFF: usize = 0, CUR: usize = 0, OCC: usize = 0, NOISEP: usize = 0, OUT: usize = 0;

/* ── state ───────────────────────────────────────────────────────────────── */
let NV: i32 = 0;
let SEED: u32 = 1337;
let RNG: u32 = 1337;
let FRAME: i32 = 0;
let NOISE_READY: bool = false;
let ESCAPES: i32 = 0;
let NOCC: i32 = 1;
let TARGET_DEN: f32 = 1.0;
let INV_DEN: f32 = 1.0;
let BRI: f32 = 1.0;       // slow global breathing of the tube radius
let DBG_ON: bool = false;

let SPIN: f32 = 2.8;      // toroidal circulation (around the ring)
let POLO: f32 = 1.5;      // poloidal circulation (around the tube)
let TURB: f32 = 0.30;     // curl-noise force
let CONF: f32 = 8.0;      // soft wall at the tube surface
let STEER: f32 = 10.0;     // how hard velocity is steered onto the flow field
let PRESS: f32 = 0.55;     // neighbour density pressure (grid-driven)

let MX: f32 = 0, MY: f32 = 0, MZ: f32 = 0, MR: f32 = 0.5, MS: f32 = 0;
let GRID_INT: i32 = 3;

/* ── raw-pointer accessors (typed-array indexing is a bounds-checked call) ── */
@inline function fv(b: usize, i: i32): f32 { return load<f32>(b + (<usize>i << 2)); }
@inline function sv(b: usize, i: i32, v: f32): void { store<f32>(b + (<usize>i << 2), v); }
@inline function iv(b: usize, i: i32): i32 { return load<i32>(b + (<usize>i << 2)); }
@inline function siv(b: usize, i: i32, v: i32): void { store<i32>(b + (<usize>i << 2), v); }
/* stride-4 vector lanes */
@inline function g4(b: usize, i: i32, k: i32): f32 { return load<f32>(b + (<usize>i << 4) + (<usize>k << 2)); }
@inline function s4(b: usize, i: i32, k: i32, v: f32): void { store<f32>(b + (<usize>i << 4) + (<usize>k << 2), v); }
@inline function fsqrt(x: f32): f32 { return Mathf.sqrt(x); }

@inline function rnd(): f32 {
  RNG = RNG * 1664525 + 1013904223;
  return <f32>(RNG >> 8) * (1.0 / 16777216.0);
}

/* ── flow field ──────────────────────────────────────────────────────────── */
/* AS cannot return a tuple, so the target velocity lands in globals; step()
   also reads back rho/invr, which the confinement term would recompute. */
let FX: f32 = 0, FY: f32 = 0, FZ: f32 = 0;
let Q_RHO: f32 = 0, Q_INVR: f32 = 0, Q_U2: f32 = 0;

/**
 * Target velocity at (x,y,z) for the toroidal vortex.
 *
 *  toroidal — azimuthal, direction (-z,0,x)/r: particles race around the ring,
 *             fastest on the tube axis and slowing toward the surface, so the
 *             tube shears against itself.
 *  poloidal — circulation about the tube centreline. In the cross-section
 *             (rho, y), with rho = |(x,z)| - R, the velocity is that vector
 *             rotated +90°, scaled by POLO. c2/s2 precess the cross-section
 *             with time so the field never settles into a frozen pattern.
 *
 * Only rho² + y² is used for the radial falloff, so there is no second sqrt
 * and no second divide anywhere in here.
 */
@inline
function computeFlow(x: f32, y: f32, z: f32, ph: f32, c2: f32, s2: f32): void {
  const r = fsqrt(x * x + z * z) + 1e-5;
  const invr: f32 = 1.0 / r;
  const rho = r - TORUS_R;
  const u2 = (rho * rho + y * y) * (1.0 / TUBE_A2);   // (dist from centreline / A)²

  Q_RHO = rho; Q_INVR = invr; Q_U2 = u2;

  // toroidal: 1 on the tube axis, ~1/4 at the surface, ~0 far outside
  const wt = SPIN * ph / (1.0 + u2 * 3.0);

  const rx = x * invr, rz = z * invr;
  // poloidal circulation, precessed by (c2, s2)
  const vr = -POLO * ph * (rho * s2 + y * c2);
  const vy = POLO * ph * (rho * c2 - y * s2);

  FX = -z * invr * wt + vr * rx;
  FY = vy;
  FZ = x * invr * wt + vr * rz;
}

@inline function hashNoise(ix: i32, iy: i32, iz: i32): f32 {
  let k: i32 = (ix * 73856093) ^ (iy * 19349663) ^ (iz * 83492791);
  k = (k ^ (k >> 13)) & 1023;
  return load<f32>(NOISEP + (<usize>k << 2));
}

/* ── grid ────────────────────────────────────────────────────────────────── */
/* clamp in f32 (one compare per axis), convert once — a clamped cell index
   keeps an out-of-range particle inside the array instead of corrupting it */
@inline
function cellOf(x: f32, y: f32, z: f32): i32 {
  const gm: f32 = <f32>(GRID_N - 1);
  let fx = (x + WORLD) * INV_CELL;
  let fy = (y + WORLD) * INV_CELL;
  let fz = (z + WORLD) * INV_CELL;
  if (fx < 0.0) fx = 0.0; else if (fx > gm) fx = gm;
  if (fy < 0.0) fy = 0.0; else if (fy > gm) fy = gm;
  if (fz < 0.0) fz = 0.0; else if (fz > gm) fz = gm;
  return (<i32>fz * GRID_N + <i32>fy) * GRID_N + <i32>fx;
}

function seedNoise(): void {
  for (let k = 0; k < 1024; k++) {
    const s = Mathf.sin(<f32>k * 2.399963) * 43758.5453;
    bufNoise[k] = (s - <f32><i32>s) * 2.0 - 1.0;
  }
  NOISEP = bufNoise.dataStart;
  NOISE_READY = true;
}

/**
 * Uniform-grid counting sort — the spatial hash.
 *
 *   pass 1  histogram: bucket every particle's cached cell index, recording
 *           the occupied cells as they appear
 *   pass 2  prefix sum → bucket start offsets
 *   pass 3  scatter: particle indices in cell-contiguous order, so a cell's
 *           members are one run of bufSrt (what verifyGrid() audits)
 *   pass 4  per-CELL force field: density pressure (−∇count) plus curl noise,
 *           evaluated once per occupied cell instead of once per particle
 *
 * Passes 1 and 3 read bufIdx, the cell indices cached by the physics pass, so
 * the rebuild is integer-only: no float loads, no cellOf per particle.
 */
function buildGrid(t: f32, pressK: f32, turbA: f32): void {
  if (!NOISE_READY) seedNoise();

  // clear the per-cell count lane (CEL.w) and the scatter cursor in one sweep
  for (let c = 0; c < GRID_CELLS; c++) {
    siv(CUR, c, 0);
    store<f32>(CEL + (<usize>c << 4) + 12, 0.0);
  }

  let occ = 0;
  for (let i = 0; i < NV; i++) {
    const c = iv(IDX, i);
    const b = <usize>c << 4;
    const n = load<f32>(CEL + b + 12) + 1.0;
    store<f32>(CEL + b + 12, n);
    if (n == 1.0) { siv(OCC, occ, c); occ++; }
  }
  NOCC = occ > 0 ? occ : 1;
  TARGET_DEN = <f32>NV / <f32>NOCC;
  INV_DEN = 1.0 / TARGET_DEN;

  let acc = 0;
  for (let c = 0; c < GRID_CELLS; c++) {
    siv(OFF, c, acc);
    siv(CUR, c, acc);
    acc += <i32>load<f32>(CEL + (<usize>c << 4) + 12);
  }
  siv(OFF, GRID_CELLS, acc);

  for (let i = 0; i < NV; i++) {
    const c = iv(IDX, i);
    const slot = iv(CUR, c);
    siv(SRT, slot, i);
    siv(CUR, c, slot + 1);
  }
  for (let c = 0; c < GRID_CELLS; c++) siv(CUR, c, 0);

  /* ── per-cell force field ─────────────────────────────────────────────── */
  const nx = GRID_N;
  const invT: f32 = 1.0 / (TARGET_DEN + 1.0);
  const nn = nx * nx;
  for (let k = 0; k < NOCC; k++) {
    const c = iv(OCC, k);
    const b = <usize>c << 4;
    const den = load<f32>(CEL + b + 12);
    const ex = den - TARGET_DEN;
    let fx: f32 = 0, fy: f32 = 0, fz: f32 = 0;

    const ix = c % nx;
    const iy = (c / nx) % nx;
    const iz = c / nn;
    if (ex > 0.0) {
      const x0 = ix > 0 ? ix - 1 : 0, x1 = ix < nx - 1 ? ix + 1 : nx - 1;
      const y0 = iy > 0 ? iy - 1 : 0, y1 = iy < nx - 1 ? iy + 1 : nx - 1;
      const z0 = iz > 0 ? iz - 1 : 0, z1 = iz < nx - 1 ? iz + 1 : nx - 1;
      const row = iy * nx;
      const gx = cntAt(iz * nn + row + x1) - cntAt(iz * nn + row + x0);
      const gy = cntAt(iz * nn + y1 * nx + ix) - cntAt(iz * nn + y0 * nx + ix);
      const gz = cntAt(z1 * nn + row + ix) - cntAt(z0 * nn + row + ix);
      const gl = fsqrt(gx * gx + gy * gy + gz * gz);
      if (gl > 0.001) {
        const f = pressK * ex * invT / gl;    // −∇ρ
        fx = -gx * f; fy = -gy * f; fz = -gz * f;
      }
    }
    if (turbA != 0.0) {
      const sz = <i32>(<f32>iz * 0.7 + t * 1.7);
      fx += hashNoise(ix, iy, sz) * turbA;
      fy += hashNoise(iy, sz, ix + 7) * turbA;
      fz += hashNoise(sz, ix, iy + 13) * turbA;
    }
    store<f32>(CEL + b, fx);
    store<f32>(CEL + b + 4, fy);
    store<f32>(CEL + b + 8, fz);
  }
}

@inline function cntAt(c: i32): f32 { return load<f32>(CEL + (<usize>c << 4) + 12); }

/* ── lifecycle ───────────────────────────────────────────────────────────── */
function spawn(i: i32): void {
  const th = rnd() * TAU;
  const rr = TUBE_A * fsqrt(rnd()) * rnd();
  const ph = rnd() * TAU;
  const rad = TORUS_R + rr * Mathf.cos(ph);
  const x = rad * Mathf.cos(th);
  const y = rr * Mathf.sin(ph);
  const z = rad * Mathf.sin(th);
  s4(P, i, 0, x); s4(P, i, 1, y); s4(P, i, 2, z); s4(P, i, 3, 0);
  s4(V, i, 0, 0); s4(V, i, 1, 0); s4(V, i, 2, 0); s4(V, i, 3, 0);
  s4(R, i, 0, 0.78 + 0.44 * rnd());
  s4(R, i, 1, 0); s4(R, i, 2, 0); s4(R, i, 3, 0);
  sv(D, i, 0);
  siv(IDX, i, cellOf(x, y, z));
}

export function init(n: i32, seed: i32): void {
  P = bufPos.dataStart; V = bufVel.dataStart; R = bufPrp.dataStart;
  D = bufDbg.dataStart; IDX = bufIdx.dataStart; SRT = bufSrt.dataStart;
  CEL = bufCel.dataStart; OFF = bufOff.dataStart; CUR = bufCur.dataStart;
  OCC = bufOcc.dataStart; OUT = bufOut.dataStart;

  NOISE_READY = false;
  SEED = <u32>seed;
  NV = n < 1 ? 1 : (n > MAXP ? MAXP : n);
  reset();
}

export function reset(): void {
  RNG = SEED == 0 ? 1 : SEED;
  FRAME = 0;
  ESCAPES = 0;
  for (let c = 0; c < GRID_CELLS * 4; c++) store<f32>(CEL + (<usize>c << 2), 0.0);
  for (let i = 0; i < NV; i++) spawn(i);
  buildGrid(0.0, 0.0, 0.0);
}

/* ── the step ────────────────────────────────────────────────────────────── */
export function step(dtIn: f32, t: f32): void {
  let dt = dtIn;
  if (dt > 0.05) dt = 0.05;
  else if (dt < 0.0) dt = 0.0;

  const pressK: f32 = PRESS * dt * 9.0;
  const turbA: f32 = TURB * dt * 2.4;
  if (GRID_INT < 1) GRID_INT = 1;
  if (FRAME % GRID_INT == 0) buildGrid(t, pressK, turbA);
  FRAME++;

  BRI = 1.0 + 0.09 * Mathf.sin(t * 0.63);
  // the poloidal cross-section precesses: one sin/cos pair for the whole step
  const pa: f32 = t * 0.19;
  const c2: f32 = Mathf.cos(pa * 2.0);
  const s2: f32 = Mathf.sin(pa * 2.0);

  const steer: f32 = STEER * dt > 1.0 ? 1.0 : STEER * dt;
  const confK: f32 = CONF * dt / TUBE_A2;
  const mr2: f32 = MR * MR;

  for (let i = 0; i < NV; i++) {
    const o = P + (<usize>i << 4);
    const vo = V + (<usize>i << 4);
    let x = load<f32>(o), y = load<f32>(o + 4), z = load<f32>(o + 8);
    let vx = load<f32>(vo), vy = load<f32>(vo + 4), vz = load<f32>(vo + 8);

    const ph = load<f32>(R + (<usize>i << 4));

    computeFlow(x, y, z, ph, c2, s2);

    /* steer velocity onto the flow field (strongly damped => streamlines) */
    vx += (FX - vx) * steer;
    vy += (FY - vy) * steer;
    vz += (FZ - vz) * steer;

    /* confinement: a soft wall where (distance from the tube centreline) = A.
       The force is ∝ (u² − 1), so inside the tube it is exactly zero and the
       density pressure is free to fill it; outside it grows quadratically. */
    const rho = Q_RHO;
    const invr = Q_INVR;
    const u2 = Q_U2;
    if (u2 > 1.0) {
      const kc = -confK * (u2 - 1.0);
      const ur = rho * invr;
      vx += kc * ur * x;
      vy += kc * y;
      vz += kc * ur * z;
    }

    /* grid force field: one 4-float load carries pressure + curl noise.
       The index is the one cached at the END of the previous step (this
       particle's cell then), which is the frame the grid was built from; the
       fresh index is recomputed after integration so the cache always matches
       the position that is actually stored. */
    const c = iv(IDX, i);
    const b = <usize>c << 4;
    vx += load<f32>(CEL + b);
    vy += load<f32>(CEL + b + 4);
    vz += load<f32>(CEL + b + 8);
    if (DBG_ON) sv(D, i, load<f32>(CEL + b + 12) * INV_DEN);

    /* mouse repulsion — a soft sphere at the cursor's world position */
    if (MS != 0.0) {
      const dx = x - MX, dy = y - MY, dz = z - MZ;
      const d2 = dx * dx + dy * dy + dz * dz;
      if (d2 < mr2 && d2 > 1e-8) {
        const d = fsqrt(d2);
        const t: f32 = 1.0 - d / MR;         // 1 at the cursor, 0 at the rim
        const g: f32 = MS * dt * <f32>34.0 * t / d;    // impulse ∝ (1 − d/r), direction = away
        vx += dx * g; vy += dy * g; vz += dz * g;
      }
    }

    /* clamp, integrate, respawn anything that escaped the grid volume */
    let sp2 = vx * vx + vy * vy + vz * vz;
    if (sp2 > MAX_SPEED * MAX_SPEED) {
      const s = MAX_SPEED / fsqrt(sp2);
      vx *= s; vy *= s; vz *= s;
      sp2 = MAX_SPEED * MAX_SPEED;
    }
    x += vx * dt; y += vy * dt; z += vz * dt;

    if (x * x + y * y + z * z > WORLD * WORLD) {
      ESCAPES++;
      spawn(i);
      continue;
    }

    siv(IDX, i, cellOf(x, y, z));
    store<f32>(o, x); store<f32>(o + 4, y); store<f32>(o + 8, z);
    store<f32>(o + 12, sp2 * INV_MAX2);
    store<f32>(vo, vx); store<f32>(vo + 4, vy); store<f32>(vo + 8, vz);
  }
}

/* ── setters ─────────────────────────────────────────────────────────────── */
export function setFlow(spin: f32, polo: f32, turb: f32, conf: f32, steer: f32, press: f32): void {
  SPIN = spin; POLO = polo; TURB = turb; CONF = conf; STEER = steer; PRESS = press;
}
export function setMouse(x: f32, y: f32, z: f32, rad: f32, strength: f32): void {
  MX = x; MY = y; MZ = z; MR = rad > 1e-3 ? rad : 1e-3; MS = strength;
}
export function setDebug(on: i32): void { DBG_ON = on != 0; }
export function setGridInterval(n: i32): void { GRID_INT = n < 1 ? 1 : (n > 8 ? 8 : n); }

/* ── pointers ────────────────────────────────────────────────────────────── */
export function posPtr(): i32 { return P as i32; }
export function velPtr(): i32 { return V as i32; }
export function prpPtr(): i32 { return R as i32; }
export function dbgPtr(): i32 { return D as i32; }
export function sortedPtr(): i32 { return SRT as i32; }
export function cellPtr(): i32 { return CEL as i32; }

/* ── diagnostics (the gate reads these instead of guessing at memory) ─────── */
export function getCount(): i32 { return NV; }
export function getMaxParticles(): i32 { return MAXP; }
export function getGridDim(): i32 { return GRID_N; }
export function getGridCells(): i32 { return GRID_CELLS; }
export function getOccupancy(): i32 { return OCCUPIED_ALIAS(); }
export function getTargetDensity(): f32 { return TARGET_DEN; }
export function getGridInterval(): i32 { return GRID_INT; }
export function getFrame(): i32 { return FRAME; }
export function getEscapes(): i32 { return ESCAPES; }
function OCCUPIED_ALIAS(): i32 { return NOCC; }

export function nanCount(): i32 {
  let n = 0;
  for (let i = 0; i < NV; i++) {
    const o = P + (<usize>i << 4);
    const x = load<f32>(o), y = load<f32>(o + 4), z = load<f32>(o + 8);
    if (!(x == x) || !(y == y) || !(z == z)) n++;
  }
  return n;
}

export function maxAbsCoord(): f32 {
  let m: f32 = 0;
  for (let i = 0; i < NV; i++) {
    const o = P + (<usize>i << 4);
    const x = load<f32>(o), y = load<f32>(o + 4), z = load<f32>(o + 8);
    if (x < 0) { if (-x > m) m = -x; } else if (x > m) m = x;
    if (y < 0) { if (-y > m) m = -y; } else if (y > m) m = y;
    if (z < 0) { if (-z > m) m = -z; } else if (z > m) m = z;
  }
  return m;
}

export function meanSpeed2(): f32 {
  let s: f32 = 0;
  for (let i = 0; i < NV; i++) s += load<f32>(P + (<usize>i << 4) + 12);
  return NV > 0 ? s / <f32>NV : 0;
}

/** mean distance from the tube centreline. */
export function meanTubeRadius(): f32 {
  let s: f32 = 0;
  for (let i = 0; i < NV; i++) {
    const o = P + (<usize>i << 4);
    const x = load<f32>(o), y = load<f32>(o + 4), z = load<f32>(o + 8);
    const rho = fsqrt(x * x + z * z) - TORUS_R;
    s += fsqrt(rho * rho + y * y);
  }
  return NV > 0 ? s / <f32>NV : 0;
}

/** fraction of particles outside the tube (a confinement health number). */
export function escapeFraction(): f32 {
  let n = 0;
  const a2 = (TUBE_A * 1.6) * (TUBE_A * 1.6);
  for (let i = 0; i < NV; i++) {
    const o = P + (<usize>i << 4);
    const x = load<f32>(o), y = load<f32>(o + 4), z = load<f32>(o + 8);
    const rho = fsqrt(x * x + z * z) - TORUS_R;
    if (rho * rho + y * y > a2) n++;
  }
  return NV > 0 ? <f32>n / <f32>NV : 0;
}

/** 0 = the cell buckets and the sorted index list are consistent.
 *  Rebuilds the grid first from the cached cell indices, so the audit always
 *  sees a self-consistent sort rather than whatever the last frame left. */
export function verifyGrid(): i32 {
  buildGrid(0.0, 0.0, 0.0);
  let sum = 0;
  for (let c = 0; c < GRID_CELLS; c++) sum += <i32>cntAt(c);
  if (sum != NV) return 1;                       // histogram lost or double-counted
  if (iv(OFF, 0) != 0) return 2;
  if (iv(OFF, GRID_CELLS) != NV) return 3;       // prefix sum did not close
  for (let c = 0; c < GRID_CELLS; c++) {
    if (iv(OFF, c + 1) - iv(OFF, c) != <i32>cntAt(c)) return 4;
  }
  // every bucket must hold particles that really belong to that cell
  let seen = 0;
  for (let c = 0; c < GRID_CELLS; c++) {
    const a = iv(OFF, c), b = iv(OFF, c + 1);
    seen += b - a;
    for (let k = a; k < b; k++) {
      const i = iv(SRT, k);
      if (i < 0 || i >= NV) return 5;
      const o = P + (<usize>i << 4);
      if (cellOf(load<f32>(o), load<f32>(o + 4), load<f32>(o + 8)) != c) return 6;
    }
  }
  if (seen != NV) return 7;                      // a particle appears twice
  return 0;
}

/** Write the base flow-field velocity at a point into bufOut (test hook).
 *  c2/s2 are held at (1,0) so the sampled field is the un-precessed one. */
export function flowSample(x: f32, y: f32, z: f32): void {
  computeFlow(x, y, z, 1.0, 1.0, 0.0);
  sv(OUT, 0, FX); sv(OUT, 1, FY); sv(OUT, 2, FZ);
  sv(OUT, 3, Q_U2);
}
export function flowOut(): i32 { return OUT as i32; }

/** Teleport a particle (position + velocity) — closed-form tests only. */
export function poke(i: i32, x: f32, y: f32, z: f32, vx: f32, vy: f32, vz: f32): void {
  if (i < 0 || i >= NV) return;
  s4(P, i, 0, x); s4(P, i, 1, y); s4(P, i, 2, z); s4(P, i, 3, 0);
  s4(V, i, 0, vx); s4(V, i, 1, vy); s4(V, i, 2, vz); s4(V, i, 3, 0);
}

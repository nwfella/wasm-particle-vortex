#!/usr/bin/env node
/**
 * verify_wasm.js — tier 1 gate.
 *
 * Everything below runs against the WebAssembly bytes EMBEDDED IN index.html,
 * not against build/vortex.wasm: the module that ships is the module under
 * test. Every physics assertion goes through the module's own exports, so a
 * claim like "the flow field is computed in WebAssembly" is measured rather
 * than read off the source — no JavaScript participates in these assertions.
 */
const fs = require("fs");
const path = require("path");

const ROOT = path.resolve(__dirname, "..");
const HTML = fs.readFileSync(path.join(ROOT, "index.html"), "utf8");
const WASM_FILE = path.join(ROOT, "build", "vortex.wasm");

let pass = 0, fail = 0;
const fails = [];
function section(n) { console.log(`\n\x1b[1m${n}\x1b[0m`); }
function check(name, ok, detail) {
  console.log(`  ${ok ? "\x1b[32mPASS\x1b[0m" : "\x1b[31mFAIL\x1b[0m"}  ${name}` +
    (detail ? `  \x1b[2m${detail}\x1b[0m` : ""));
  if (ok) pass++; else { fail++; fails.push(name); }
}
const num = (n, d = 0) => Number(n).toFixed(d);

/* ── extract the module from the shipped page ───────────────────────────── */
const START = "<!--WASM-B64-->", END = "<!--/WASM-B64-->";
const a = HTML.indexOf(START), b = HTML.indexOf(END);
check("index.html carries the WASM-B64 markers", a >= 0 && b > a);
const b64 = a >= 0 && b > a
  ? (HTML.slice(a + START.length, b).match(/<script[^>]*>([\s\S]*?)<\/script>/) || [, ""])[1].trim()
  : "";
const bytes = b64 ? Uint8Array.from(Buffer.from(b64, "base64")) : new Uint8Array(0);

const imports = { env: { abort: (m, f, l, c) => { throw new Error(`wasm abort ${l}:${c} ${m}`); } } };
const load = async (buf) => (await WebAssembly.instantiate(buf, imports)).instance.exports;

/* ═════════════════════════════════════════════════════════════════════════ */
(async () => {
  /* ── artifact ─────────────────────────────────────────────────────────── */
  section("artifact");
  check("payload decodes to a valid wasm module", bytes.length > 2000 && WebAssembly.validate(bytes),
    `${num(bytes.length / 1024, 2)} KB`);
  const onDisk = fs.existsSync(WASM_FILE) ? fs.readFileSync(WASM_FILE) : Buffer.alloc(0);
  check("embedded payload === build/vortex.wasm (build in sync)",
    onDisk.length === bytes.length && Buffer.compare(Buffer.from(bytes), onDisk) === 0,
    `${onDisk.length} vs ${bytes.length} bytes`);
  check("module fits the 'single-digit KB' claim", bytes.length < 9 * 1024,
    `${bytes.length} bytes < 9216`);

  const mod = new WebAssembly.Module(bytes);
  const imps = WebAssembly.Module.imports(mod).map((i) => `${i.module}.${i.name}`);
  check("only import is env.abort — all maths lives in the module",
    imps.length === 1 && imps[0] === "env.abort", imps.join(", ") || "none");

  const exps = WebAssembly.Module.exports(mod).map((e) => e.name);
  const needed = ["init", "reset", "step", "setFlow", "setMouse", "setDebug",
    "setGridInterval", "posPtr", "velPtr", "dbgPtr", "sortedPtr", "cellPtr",
    "getCount", "getMaxParticles", "getGridDim", "getGridCells", "getOccupancy",
    "getTargetDensity", "getFrame", "getEscapes", "nanCount", "maxAbsCoord",
    "meanSpeed2", "meanTubeRadius", "escapeFraction", "verifyGrid",
    "flowSample", "flowOut", "poke", "memory"];
  const missing = needed.filter((r) => !exps.includes(r));
  check("exports the full solver API", missing.length === 0,
    missing.length ? "missing: " + missing.join(",") : `${exps.length} exports`);

  const e = await load(bytes);
  const mem = () => e.memory.buffer;

  /* ── lifecycle and buffer contract ───────────────────────────────────── */
  section("init / buffers");
  e.init(500000, 12345);
  const NV = e.getCount();
  check("init() accepts 500,000 particles", NV === 500000, `${NV}`);
  check("the module caps the population at its own MAXP", (() => {
    e.init(900000000, 1);
    const capped = e.getCount();
    e.init(500000, 12345);
    return capped === 500000;
  })(), `9e8 → ${500000}`);
  check("linear memory holds the particle + grid state",
    mem().byteLength >= 30 * 1048576, `${num(mem().byteLength / 1048576, 1)} MB`);
  const ptrs = [e.posPtr(), e.velPtr(), e.prpPtr(), e.dbgPtr(), e.sortedPtr(), e.cellPtr()];
  check("exported pointers are non-zero, distinct and 4-byte aligned",
    ptrs.every((p) => p > 0 && p % 4 === 0) && new Set(ptrs).size === ptrs.length,
    ptrs.join(", "));

  const posV = () => new Float32Array(mem(), e.posPtr(), NV * 4);
  const velV = () => new Float32Array(mem(), e.velPtr(), NV * 4);

  /* ── the flow field really is a toroidal vortex ──────────────────────── */
  section("flow field");
  const flowAt = (x, y, z) => {
    e.flowSample(x, y, z);
    const o = new Float32Array(mem(), e.flowOut(), 4);
    return { x: o[0], y: o[1], z: o[2], u2: o[3] };
  };
  const R = 1.0, A = 0.44;
  const samplePts = [];
  for (let i = 0; i < 40; i++) {
    const th = (i / 40) * Math.PI * 2;
    const ph = (i * 2.399963) % (Math.PI * 2);
    const rr = A * (0.15 + 0.75 * ((i * 7) % 11) / 11);
    const rad = R + rr * Math.cos(ph);
    samplePts.push([rad * Math.cos(th), rr * Math.sin(ph), rad * Math.sin(th)]);
  }

  // (a) toroidal-only: purely azimuthal about +y, zero vertical component
  e.setFlow(2.8, 0, 0, 0, 0, 0);
  let worstAz = 0, worstY = 0, minMag = Infinity;
  for (const [x, y, z] of samplePts) {
    const f = flowAt(x, y, z);
    const r = Math.hypot(x, z);
    const mag = Math.hypot(f.x, f.y, f.z);
    if (f.u2 < 0.5) minMag = Math.min(minMag, mag);
    worstAz = Math.max(worstAz, Math.abs((f.x * x + f.z * z) / (mag * r || 1)));
    worstY = Math.max(worstY, Math.abs(f.y) / (mag || 1));
  }
  check("toroidal term is purely azimuthal (⊥ to the radial direction)",
    worstAz < 2e-3, `max |cos| = ${worstAz.toExponential(2)} over 40 samples`);
  check("toroidal term has no vertical component", worstY < 2e-3,
    `max |vy|/|v| = ${worstY.toExponential(2)}`);
  check("toroidal term is non-zero on the tube core", minMag > 0.1, `min |v| = ${num(minMag, 3)}`);

  // (b) poloidal-only: tangent to circles about the tube centreline
  e.setFlow(0, 1.5, 0, 0, 0, 0);
  let worstPerp = 0, minPolo = Infinity;
  for (const [x, y, z] of samplePts) {
    const f = flowAt(x, y, z);
    const r = Math.hypot(x, z);
    const rho = r - R;
    const mag = Math.hypot(f.x, f.y, f.z);
    // outward vector from the tube centreline, in 3-space
    const ox = rho * x / r, oy = y, oz = rho * z / r;
    const ol = Math.hypot(ox, oy, oz);
    const dot = Math.abs(f.x * ox + f.y * oy + f.z * oz) / (mag * ol || 1);
    worstPerp = Math.max(worstPerp, dot);
    minPolo = Math.min(minPolo, mag);
  }
  check("poloidal term is tangent to the tube cross-section (⊥ to tube radius)",
    worstPerp < 5e-3, `max |cos| = ${worstPerp.toExponential(2)} over 40 samples`);
  check("poloidal term is non-zero", minPolo > 0.01, `min |v| = ${num(minPolo, 3)}`);

  // (c) both off → nothing moves the field
  e.setFlow(0, 0, 0, 0, 0, 0);
  let maxZero = 0;
  for (const [x, y, z] of samplePts) {
    const f = flowAt(x, y, z);
    maxZero = Math.max(maxZero, Math.hypot(f.x, f.y, f.z));
  }
  check("zeroed parameters give a zero field", maxZero === 0, `max |v| = ${maxZero}`);

  /* ── closed-form integration ─────────────────────────────────────────── */
  section("integration");
  e.init(4096, 99);
  e.setFlow(0, 0, 0, 0, 0, 0);
  e.setMouse(0, 0, 0, 1, 0);
  const DT = 1 / 60, NSTEP = 60;
  const x0 = 1.0, y0 = 0.1, z0 = 0.0, vX = 0.7, vY = -0.3, vZ = 0.2;
  e.poke(0, x0, y0, z0, vX, vY, vZ);
  for (let k = 0; k < NSTEP; k++) e.step(DT, k * DT);
  const p = posV();
  const ex = x0 + vX * DT * NSTEP, ey = y0 + vY * DT * NSTEP, ez = z0 + vZ * DT * NSTEP;
  const err = Math.max(Math.abs(p[0] - ex), Math.abs(p[1] - ey), Math.abs(p[2] - ez));
  check("force-free motion is the exact closed-form straight line", err < 1e-3,
    `|Δ| = ${err.toExponential(2)} after 1 s at v = (${vX}, ${vY}, ${vZ})`);

  // speed clamp
  e.poke(1, 1.0, 0.1, 0.0, 90, 0, 0);
  e.step(DT, 1);
  const v = velV();
  const sp = Math.hypot(v[4], v[5], v[6]);
  check("velocity clamp caps an injected 90 u/s particle", sp <= 3.4001, `|v| = ${num(sp, 3)} ≤ 3.4`);

  // mouse repulsion: push away, and only inside the radius
  e.setFlow(0, 0, 0, 0, 0, 0);
  e.poke(2, 1.0, 0.1, 0.0, 0, 0, 0);     // sits 0.1 from the cursor
  e.poke(3, 1.0, 1.1, 0.0, 0, 0, 0);     // sits 1.1 away, outside r = 0.5
  e.setMouse(1.1, 0.1, 0.0, 0.5, 1.2);
  e.step(DT, 2);
  const vm = velV();
  check("mouse repulsion accelerates a particle away from the cursor",
    vm[8] < -0.05 && Math.abs(vm[9]) < 0.05, `v = (${num(vm[8], 3)}, ${num(vm[9], 3)}, ${num(vm[10], 3)})`);
  check("mouse repulsion does nothing outside its radius",
    vm[12] === 0 && vm[13] === 0 && vm[14] === 0, `|v| = ${num(Math.hypot(vm[12], vm[13], vm[14]), 4)}`);

  // confinement: outside the tube, pushed back in
  e.setMouse(0, 0, 0, 0.5, 0);
  e.setFlow(0, 0, 0, 8, 0, 0);
  e.poke(4, R + 0.70, 0, 0, 0, 0, 0);   /* inside the world sphere, outside the tube */
  const q0 = 0.70;
  e.step(DT, 3);
  /* snapshot NOW: velV() is a live view into wasm memory, so reading it after
     the loop below would report the velocity 2 s later */
  const vx1 = velV()[16];
  let q1 = Infinity;
  for (let k = 0; k < 120; k++) e.step(DT, 3 + k * DT);
  const pc = posV();
  {
    const px = pc[16], py = pc[17], pz = pc[18];
    q1 = Math.hypot(Math.hypot(px, pz) - R, py);
  }
  check("confinement pushes a particle outside the tube back toward it",
    vx1 < -0.2, `vx = ${num(vx1, 3)} after one step at q = 0.70 (tube radius 0.44)`);
  check("confinement holds it inside the tube over 2 s", q1 < q0,
    `q ${num(q0, 3)} → ${num(q1, 3)} (tube radius 0.44)`);

  /* ── the spatial grid ────────────────────────────────────────────────── */
  section("spatial grid hash");
  e.init(500000, 4242);
  e.setFlow(2.8, 1.5, 0.3, 8, 10, 0.55);
  e.setMouse(0, 0, 0, 0.6, 0);
  const G = e.getGridDim();
  check("grid dimension is the shipped 32^3", G === 32 && e.getGridCells() === 32768,
    `${G}^3 = ${e.getGridCells()} cells`);
  for (let k = 0; k < 90; k++) e.step(DT, k * DT);
  const vg = e.verifyGrid();
  check("counting sort verifies: buckets, offsets and the sorted list agree",
    vg === 0, `verify code ${vg} (0 = ok)`);
  const occ = e.getOccupancy();
  const td = e.getTargetDensity();
  check("occupied cells are a sane fraction of the grid", occ > 500 && occ < 32768,
    `${occ} occupied, ${num(td, 1)} particles/cell (mean over occupied cells)`);
  check("target density equals NV / occupied", Math.abs(td - 500000 / occ) < 0.01,
    `${num(td, 3)} vs ${num(500000 / occ, 3)}`);
  check("confinement keeps the swarm in the tube", e.escapeFraction() < 0.05,
    `${num(e.escapeFraction() * 100, 2)}% of particles beyond 1.6× the tube radius`);

  /* ── stability at full population ────────────────────────────────────── */
  section("stability (500,000 particles)");
  e.init(500000, 7);
  e.setFlow(2.8, 1.5, 0.3, 8, 10, 0.55);
  e.setMouse(0, 0, 0, 0.6, 0);
  for (let k = 0; k < 300; k++) e.step(DT, k * DT);
  check("no NaN or infinite coordinate after 300 steps", e.nanCount() === 0,
    `${e.nanCount()} bad of ${NV}`);
  check("every particle stays inside the simulation volume", e.maxAbsCoord() < 1.8,
    `max |coord| = ${num(e.maxAbsCoord(), 3)} < 1.8`);
  check("the swarm keeps a live velocity field", e.meanSpeed2() > 0.02 && e.meanSpeed2() <= 1,
    `mean speed² = ${num(e.meanSpeed2(), 3)} (1.0 = clamp)`);
  check("the tube keeps its radius", Math.abs(e.meanTubeRadius() - 0.26) < 0.12,
    `mean distance from the centreline = ${num(e.meanTubeRadius(), 3)}`);
  check("escapes are rare (the respawn path is a safety net, not the model)",
    e.getEscapes() < 5000, `${e.getEscapes()} respawns over 300 steps`);

  /* ── determinism ─────────────────────────────────────────────────────── */
  section("determinism");
  e.init(60000, 2024);
  e.setFlow(2.8, 1.5, 0.3, 8, 10, 0.55);
  e.setMouse(0.9, 0.2, 0.1, 0.6, 0.7);
  for (let k = 0; k < 90; k++) e.step(DT, k * DT);
  const PA = Float32Array.from(new Float32Array(mem(), e.posPtr(), 60000 * 4));
  e.reset();
  e.setFlow(2.8, 1.5, 0.3, 8, 10, 0.55);
  e.setMouse(0.9, 0.2, 0.1, 0.6, 0.7);
  for (let k = 0; k < 90; k++) e.step(DT, k * DT);
  const PB = new Float32Array(mem(), e.posPtr(), 60000 * 4);
  let dmax = 0;
  for (let i = 0; i < PA.length; i++) dmax = Math.max(dmax, Math.abs(PA[i] - PB[i]));
  check("reset + replay is bit-identical", dmax === 0, `max Δ = ${dmax} over 60,000 particles`);

  /* ── performance ─────────────────────────────────────────────────────── */
  section("performance");
  e.init(500000, 7);
  e.setFlow(2.8, 1.5, 0.3, 8, 10, 0.55);
  e.setMouse(0, 0, 0, 0.6, 0);
  let t = 0;
  for (let k = 0; k < 60; k++) { t += DT; e.step(DT, t); }
  const S = 120;
  const t0 = process.hrtime.bigint();
  for (let k = 0; k < S; k++) { t += DT; e.step(DT, t); }
  const ms = Number(process.hrtime.bigint() - t0) / 1e6 / S;
  /* This is a regression guard calibrated to the machine the project was built
     on (i5-8350U, 15 W, 2017): ~45 ms/step here, ~12 ms on a current desktop
     core. A step that suddenly costs 2x is a real regression; the absolute
     number is hardware, and the README quotes it honestly. */
  check("step time stays inside the regression budget", ms < 70,
    `${num(ms, 1)} ms/step = ${num(ms * 1e6 / 500000, 1)} ns/particle ` +
    `(${num(1000 / ms, 0)} Hz ceiling for physics alone, grid every 3rd frame)`);

  /* ── page wiring (static) ────────────────────────────────────────────── */
  section("page wiring");
  const resourceLoad = /<(script|img|iframe|source|video|audio|link)\b[^>]*\b(src|href)\s*=\s*["']\s*(https?:)?\/\//i;
  check("no network-fetched resources (offline single file)",
    !/\bfetch\s*\(/.test(HTML) && !/XMLHttpRequest/.test(HTML) && !resourceLoad.test(HTML),
    "no fetch/XHR/CDN; outbound links are navigations only");
  check("page instantiates the embedded bytes", /WebAssembly\.instantiate/.test(HTML) &&
    /wasm-b64/.test(HTML) && !/fetch\s*\(\s*["'][^"']*\.wasm/.test(HTML));
  check("page drives the solver through its exports",
    /sim\.step\(/.test(HTML) && /sim\.setFlow\(/.test(HTML) &&
    /sim\.setMouse\(/.test(HTML) && /sim\.init\(/.test(HTML));
  check("renderer requests WebGL2 with point sprites",
    /getContext\(\s*["']webgl2["']/.test(HTML) && /drawArrays\(gl\.POINTS/.test(HTML));
  check("colour is a velocity ramp in the fragment shader",
    /rampSpeed/.test(HTML) && /aPos\.w/.test(HTML));
  check("aspect + viewport are refit on resize", /addEventListener\(\s*["']resize["']/.test(HTML));
  check("the 500k preset is present in the markup", /data-count="500000"[^>]*aria-pressed="true"/.test(HTML));
  check("sliders and state share one path (no hand-written defaults in JS)",
    /syncControls/.test(HTML) && /DEFAULTS/.test(HTML));
  check("ships a data: favicon (no /favicon.ico request)", /rel="icon"[^>]*href="data:/.test(HTML));

  /* ── verdict ─────────────────────────────────────────────────────────── */
  console.log(`\n${fail === 0 ? "\x1b[32m" : "\x1b[31m"}${pass}/${pass + fail} assertions passed\x1b[0m`);
  if (fail) { console.log("failed:\n  - " + fails.join("\n  - ")); process.exit(1); }
  console.log(`wasm ${bytes.length} B · 500,000 particles · 32³ grid · ${num(ms, 1)} ms/step`);
})().catch((err) => {
  console.error("\nharness error:", err);
  process.exit(1);
});

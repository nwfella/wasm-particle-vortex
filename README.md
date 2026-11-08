# Toroidal Vortex — 500,000 particles in WebAssembly

A real-time particle system where **every per-frame calculation happens inside a
hand-written WebAssembly module**: the vortex flow field, tube confinement,
curl-noise turbulence, mouse repulsion, a uniform-grid counting sort (spatial
hash) with a per-cell force field, and the integration. JavaScript only uploads
one position buffer to WebGL2 and draws it as 500,000 additive point sprites.

**One HTML file, zero dependencies, no build step to view it.**
Open `index.html` over `file://` and it runs. The module travels inside the
document as base64 — `fetch()` of a sibling `.wasm` is blocked on `file://`.

```
wasm module   8,232 bytes      imports: env.abort  (nothing else)
buffers       3 × 8 MB         positions, velocities, per-particle params — read
                               by JS as typed-array views, zero copy
grid          32³ = 32,768     rebuilt every 3rd frame, cell-ordered indices
particles     500,000          (125k / 250k presets for slower machines)
```

## What is actually simulated

**The field.** A torus of major radius `R = 1` and tube radius `A = 0.44`. At a
point, `rho = |(x,z)| − R` is the offset from the tube centreline, so
`(rho, y)` is the tube cross-section. The target velocity is the sum of two
circulations:

- **toroidal** — azimuthal, direction `(−z, 0, x)/r`, magnitude falling off with
  `(rho²+y²)/A²`. Particles race around the ring, fastest on the tube axis.
- **poloidal** — the cross-section vector `(rho, y)` rotated 90°, i.e. flow that
  is everywhere *tangent to circles about the tube centreline*. This is what makes
  the streamlines helical instead of circular.

The poloidal frame precesses with time (`sin/cos` of `2·0.19t`, computed **once
per step**, not per particle) so the field never settles into a frozen pattern.

**The grid.** Every frame (well, every 3rd) the module runs a counting sort:
histogram each particle into its cell → prefix-sum to start offsets → scatter
particle indices so each cell is a contiguous run. Then it evaluates a **force
field once per occupied cell** — density pressure `−∇count` where a cell is
crowded, plus curl noise — so a particle pays one 4-float load instead of three
hashes and seven neighbour reads. `verifyGrid()` audits the whole thing: bucket
counts sum to N, the prefix sum closes, every bucket holds particles that really
belong to that cell, and no particle appears twice.

That grid view is the `g` key. The braided filaments you see there are the
density pressure doing real work on the particle distribution.

**Integration.** Velocity is steered onto the flow field (a damped first-order
follow, unconditionally stable), plus confinement, grid force, mouse impulse and
a speed clamp. `dt` is clamped, and anything that leaves the box respawns.

## Performance, measured honestly

This is the interesting part, and it is not a 60 fps flex on every machine.

| | value |
|---|---|
| module size | 8,232 bytes |
| step time, 500k particles | **43 ms** (≈ 87 ns/particle) |
| frame rate, 500k, this laptop | **~20 fps** |
| frame rate, 500k, modern desktop core | ~60 fps (≈3× single-core speed) |

Measured on an **i5-8350U** (15 W, 2017, 2 cores) with Intel UHD 620. The
physics is the frame: 500k × 60 fps = 30M particle-updates/second, and a
bare-metal JS loop doing the same arithmetic on the same machine measures
**104 ns/particle** — slower than the wasm. So the ceiling here is the CPU, not
the code generation. For reference, a trivial 3-float copy loop over the same
array costs 4.7 ns/particle on this chip, and the flow field alone costs ~61 ns.

Two optimisations did most of the work, and both are worth knowing:

1. **Anything that depends only on position and is expensive gets evaluated once
   per grid cell, not once per particle.** Density pressure + curl noise went
   from 42 ms of the step to ~1 ms by writing a per-cell force field that the
   particle loop reads with one load.
2. **No trig, no divisions that can be avoided, in the particle loop.** The
   toroidal falloff uses `1/(1+3u²)` on the *squared* tube distance (no second
   `sqrt`), and the confinement force is `∝ (u²−1)` so it needs no `q` at all.

Then, measured, in order: caching the cell index in the physics pass so the grid
rebuild is a pure integer pass; packing count+force into one 16-byte cell record;
and moving from a 48³ to a 32³ grid (the random per-particle lookup is what
matters, and 128 KB of cell records stays in L2).

If you want 60 fps on a 15 W laptop, press **250k**. The demo defaults to 500k
because that is the claim being made.

## Controls

| | |
|---|---|
| drag / wheel | orbit / zoom |
| move the pointer | repulsive force at the cursor |
| `space` | pause |
| `g` | colour mode: velocity ramp ↔ cell occupancy |
| `r` | reset (bit-identical replay) |
| `h` | hide the HUD |

Colour is a five-stop ramp over **speed²**, computed in the fragment shader
(blue → cyan → violet → magenta → amber → white).

## Build and gates

```bash
npm install                 # assemblyscript only devDependency
npm run build               # compiles src/vortex.ts, inlines the base64 payload
npm run verify              # tier 1: 43 assertions against the SHIPPED bytes
npm run verify:browser      # tier 2: 41 assertions in real Chrome over CDP
npm run bench               # ms/step at 500k
npm run shot                # screenshots/shot.png at 1500×1000
```

**Tier 1** (`scripts/verify_wasm.js`) extracts the base64 payload *out of
`index.html`*, decodes it, instantiates it in Node with the same import object
the page passes, and asserts the bytes are identical to `build/vortex.wasm`.
Every physics claim then goes through the module's own exports — no JavaScript
arithmetic participates, so a green run is evidence the module does the work:

- imports are `env.abort` alone (a `Math.sin` import would mean the maths is
  still in JS);
- the toroidal term is provably azimuthal — `flow · (x,0,z) ≈ 0` and `vy ≈ 0`
  across 40 sample points;
- the poloidal term is provably tangent to the tube cross-section —
  `flow · (rho·r̂, y) ≈ 0`, which is the defining property of a toroidal vortex;
- force-free motion is the exact closed-form straight line (`|Δ| = 7e-7` after
  one second);
- the mouse pushes away inside its radius and does nothing outside it;
- confinement pulls a particle at `q = 0.70` inward and holds it inside the tube;
- the counting sort verifies; 300 steps at 500k produce no NaN and no escapes;
- reset + replay is bit-identical over 60,000 particles.

**Tier 2** (`scripts/browser_check.js`) drives real Chrome over the DevTools
Protocol with no dependencies. It asserts what rendered, not what was set: ink
fraction from `readPixels`, the colour ramp responding to the field being
switched off (`r/b 0.376 → 0.250`), a measurable hole opening around the cursor
(17,142 → 9,832 particles within r = 0.42) and refilling afterwards, the
readouts and labels moving together with a preset change, zero console errors,
zero network requests, and no layout overflow at 1500 / 768 / 390 / **320** px.

It also proves the **framing**, which is the one thing a layout assertion cannot see:
the ink bounding box (differenced against the same frame drawn without the point
pass, so the gradient background is not mistaken for subject) must keep margins on
both sides with no ink in the 1.2 % edge strip, and on a phone the subject must sit
entirely above the control sheet. That is what caught the ring being cropped off
both edges at 390 px, and then the lens shift that was being divided by `w` and
therefore did nothing at range.

## Layout

```
index.html            the whole app (payload between <!--WASM-B64--> markers)
src/vortex.ts         the module — buffers, flow field, grid, step, diagnostics
build/vortex.wasm     compiled output (checked in; the gate compares against it)
build/vortex.wat      the reviewable text form of the shipped binary
scripts/build.js      asc → base64 → inline → validate exports
scripts/verify_wasm.js    tier 1
scripts/browser_check.js  tier 2
scripts/bench.js          ms/step harness
scripts/shot.js           screenshot harness
```

## Licence

MIT.

#!/usr/bin/env node
/* bench.js — measure the module the way the frame loop will use it. */
const fs = require("fs");
const path = require("path");
const bytes = fs.readFileSync(path.join(__dirname, "..", "build", "vortex.wasm"));

const imports = { env: { abort: (m, f, l, c) => { throw new Error(`wasm abort ${l}:${c} ${m}`); } } };

(async () => {
  const { instance } = await WebAssembly.instantiate(bytes, imports);
  const e = instance.exports;
  const imps = WebAssembly.Module.imports(new WebAssembly.Module(bytes)).map((i) => i.module + "." + i.name);
  console.log("imports:", imps.join(", "));

  const N = Number(process.argv[2] || 500000);
  const GI = Number(process.argv[3] || 1);
  const t0 = process.hrtime.bigint();
  e.init(N, 12345);
  console.log(`init(${N}) ${(Number(process.hrtime.bigint() - t0) / 1e6).toFixed(1)} ms, mem ${(e.memory.buffer.byteLength / 1048576).toFixed(1)} MB`);
  e.setFlow(2.6, 1.35, 0.55, 7.0, 8.0, 1.1);
  e.setMouse(1.2, 0.3, 0.5, 0.5, 3.0);
  e.setGridInterval(GI);

  let t = 0;
  for (let k = 0; k < 30; k++) { t += 1 / 60; e.step(1 / 60, t); }   // warm up
  const S = 200;
  const t1 = process.hrtime.bigint();
  for (let k = 0; k < S; k++) { t += 1 / 60; e.step(1 / 60, t); }
  const ms = Number(process.hrtime.bigint() - t1) / 1e6 / S;

  console.log(`step: ${ms.toFixed(2)} ms  (grid interval ${GI}, ${N} particles)`);
  console.log(`nan=${e.nanCount()} maxAbs=${e.maxAbsCoord().toFixed(3)} mean01=${e.meanSpeed01().toFixed(3)}`);
  console.log(`grid verify=${e.verifyGrid()} occupancy=${e.getOccupancy()} targetDen=${e.getTargetDensity().toFixed(2)} escapes=${e.getEscapes()}`);
  console.log(`meanTubeR=${e.meanTubeRadius()}.toFixed(3)}`);
})();

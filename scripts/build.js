#!/usr/bin/env node
/**
 * build.js — compile src/vortex.ts to WebAssembly and inline the module into
 * index.html as base64.
 *
 * Inlining is not cosmetic: a page opened over file:// has origin "null", and
 * fetch() of a sibling .wasm is blocked. Bytes embedded in the document are the
 * only way a single file stays portable.
 *
 * Idempotent: rebuilding replaces the payload between the WASM-B64 markers and
 * leaves the rest of index.html untouched.
 */
const fs = require("fs");
const path = require("path");
const { execFileSync } = require("child_process");

const ROOT = path.resolve(__dirname, "..");
const SRC = path.join(ROOT, "src", "vortex.ts");
const OUT_WASM = path.join(ROOT, "build", "vortex.wasm");
const OUT_WAT = path.join(ROOT, "build", "vortex.wat");
const HTML = path.join(ROOT, "index.html");
const ASC = path.join(ROOT, "node_modules", "assemblyscript", "bin", "asc.js");

const START = "<!--WASM-B64-->";
const END = "<!--/WASM-B64-->";

const REQUIRED = ["init", "reset", "step", "setFlow", "setMouse", "setDebug",
  "setGridInterval", "posPtr", "dbgPtr", "sortedPtr", "cellPtr", "getCount",
  "getMaxParticles", "getGridDim", "getGridCells", "getOccupancy", "getFrame",
  "nanCount", "meanSpeed2", "meanTubeRadius", "escapeFraction", "verifyGrid",
  "flowSample", "flowOut", "poke", "memory"];

function build() {
  if (!fs.existsSync(ASC)) {
    console.error("assemblyscript not installed — run: npm install");
    process.exit(1);
  }
  fs.mkdirSync(path.dirname(OUT_WASM), { recursive: true });

  execFileSync(process.execPath, [
    ASC, SRC, "-O3", "--runtime", "stub", "--noAssert",
    "-o", OUT_WASM, "--textFile", OUT_WAT,
  ], { stdio: "inherit", cwd: ROOT });

  const bytes = fs.readFileSync(OUT_WASM);
  const b64 = bytes.toString("base64");

  const html = fs.readFileSync(HTML, "utf8");
  const a = html.indexOf(START);
  const b = html.indexOf(END);
  if (a < 0 || b < 0) throw new Error("index.html is missing the WASM-B64 markers");
  const next = html.slice(0, a + START.length) +
    `<script id="wasm-b64" type="text/plain">${b64}</script>` +
    html.slice(b);
  // keep line endings stable so the shipped bytes hash-match the committed blob
  fs.writeFileSync(HTML, next.replace(/\r\n/g, "\n"), "utf8");

  /* fail the BUILD, not the browser */
  if (!WebAssembly.validate(bytes)) throw new Error("emitted bytes are not a valid wasm module");
  const mod = new WebAssembly.Module(bytes);
  const have = WebAssembly.Module.exports(mod).map((e) => e.name);
  const missing = REQUIRED.filter((r) => !have.includes(r));
  if (missing.length) throw new Error("wasm module is missing exports: " + missing.join(", "));
  const imports = WebAssembly.Module.imports(mod).map((i) => i.module + "." + i.name);

  console.log(`\n  build/vortex.wasm   ${bytes.length} bytes (${(bytes.length / 1024).toFixed(2)} KB)`);
  console.log(`  index.html          inlined ${b64.length} base64 chars`);
  console.log(`  exports             ${have.length} (all ${REQUIRED.length} required present)`);
  console.log(`  imports             ${imports.join(", ") || "none"}`);
}

build();

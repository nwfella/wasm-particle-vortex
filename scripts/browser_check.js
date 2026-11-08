#!/usr/bin/env node
/**
 * browser_check.js — tier 2 gate: real Chrome over the DevTools Protocol.
 *
 * No dependencies. Node's global fetch + WebSocket are all CDP needs.
 *
 *   node scripts/browser_check.js                 (local file://, headless)
 *   node scripts/browser_check.js --url=https://… (the deployed page)
 *   node scripts/browser_check.js --headed        (watch it run)
 */
const fs = require("fs");
const path = require("path");
const os = require("os");
const { spawn } = require("child_process");

const ROOT = path.resolve(__dirname, "..");
const SHOTS = path.join(ROOT, "screenshots");
const args = process.argv.slice(2);
const arg = (k, d) => {
  const hit = args.find((a) => a.startsWith("--" + k + "="));
  return hit ? hit.slice(k.length + 3) : d;
};
const headed = args.includes("--headed");
const URL_ARG = arg("url", null);
const PAGE = URL_ARG || "file:///" + path.join(ROOT, "index.html").replace(/\\/g, "/");

const CHROME = [
  "C:/Program Files/Google/Chrome/Application/chrome.exe",
  "C:/Program Files (x86)/Google/Chrome/Application/chrome.exe",
  "C:/Program Files/Microsoft/Edge/Application/msedge.exe",
  "C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe",
].find((p) => fs.existsSync(p));

let pass = 0, fail = 0;
const fails = [];
function section(n) { console.log(`\n\x1b[1m${n}\x1b[0m`); }
function check(name, ok, detail) {
  console.log(`  ${ok ? "\x1b[32mPASS\x1b[0m" : "\x1b[31mFAIL\x1b[0m"}  ${name}` +
    (detail ? `  \x1b[2m${detail}\x1b[0m` : ""));
  if (ok) pass++; else { fail++; fails.push(name); }
}
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

/* ── CDP client ─────────────────────────────────────────────────────────── */
async function connect(port, deadlineMs = 25000) {
  const t0 = Date.now();
  let page = null;
  while (Date.now() - t0 < deadlineMs) {
    try {
      const list = await fetch(`http://127.0.0.1:${port}/json/list`).then((r) => r.json());
      page = list.find((t) => t.type === "page" && t.webSocketDebuggerUrl);
      if (page) break;
    } catch (e) { /* not up yet */ }
    await sleep(200);
  }
  if (!page) throw new Error("Chrome never exposed a page target on port " + port);

  const ws = new WebSocket(page.webSocketDebuggerUrl);
  await new Promise((res, rej) => {
    ws.addEventListener("open", res, { once: true });
    ws.addEventListener("error", () => rej(new Error("CDP socket error")), { once: true });
    setTimeout(() => rej(new Error("CDP socket timeout")), 8000);
  });

  let id = 0;
  const pending = new Map();
  const listeners = [];
  const errors = [];
  ws.addEventListener("message", (ev) => {
    const m = JSON.parse(ev.data);
    if (m.id && pending.has(m.id)) {
      const { resolve, reject } = pending.get(m.id);
      pending.delete(m.id);
      m.error ? reject(new Error(m.error.message)) : resolve(m.result);
    } else if (m.method) {
      for (const l of listeners) l(m);
      if (m.method === "Runtime.exceptionThrown") {
        const d = m.params.exceptionDetails;
        errors.push("exception: " + (d.exception && d.exception.description || d.text));
      }
      if (m.method === "Log.entryAdded" && m.params.entry.level === "error") {
        errors.push("console: " + m.params.entry.text);
      }
    }
  });

  const send = (method, params = {}) => new Promise((resolve, reject) => {
    const mid = ++id;
    pending.set(mid, { resolve, reject });
    ws.send(JSON.stringify({ id: mid, method, params }));
    setTimeout(() => {
      if (pending.has(mid)) { pending.delete(mid); reject(new Error("timeout: " + method)); }
    }, 30000);
  });

  const evalJs = async (expr, awaitPromise = false) => {
    const r = await send("Runtime.evaluate", {
      expression: `(() => { ${expr} })()`,
      returnByValue: true, awaitPromise, userGesture: true,
    });
    if (r.exceptionDetails) {
      throw new Error("eval threw: " + (r.exceptionDetails.exception && r.exceptionDetails.exception.description || r.exceptionDetails.text));
    }
    return r.result.value;
  };
  const json = async (expr, awaitPromise = false) => {
    const v = await evalJs(`const __v = (${expr}); return JSON.stringify(__v);`, awaitPromise);
    return JSON.parse(v);
  };
  const shot = async (file) => {
    const r = await send("Page.captureScreenshot", { format: "png", captureBeyondViewport: true });
    fs.mkdirSync(path.dirname(file), { recursive: true });
    fs.writeFileSync(file, Buffer.from(r.data, "base64"));
    return file;
  };
  const waitFor = async (expr, ms, what) => {
    const t = Date.now();
    while (Date.now() - t < ms) {
      if (await evalJs(`return (${expr});`)) return true;
      await sleep(120);
    }
    throw new Error("timed out waiting for " + what);
  };
  return { send, evalJs, json, shot, waitFor, errors, ws, listeners };
}

/* ═════════════════════════════════════════════════════════════════════════ */
(async () => {
  if (!CHROME) { console.error("no Chrome/Edge found"); process.exit(1); }
  const port = 9300 + (process.pid % 400);
  const profile = path.join(os.tmpdir(), "vortex-gate-" + process.pid);

  const child = spawn(CHROME, [
    headed ? "--new-window" : "--headless=new",
    "--no-first-run", "--no-default-browser-check", "--disable-extensions",
    "--disable-background-networking", "--hide-scrollbars", "--mute-audio",
    "--force-device-scale-factor=1",
    "--window-size=1500,1000",
    "--user-data-dir=" + profile,
    "--remote-debugging-port=" + port,
    "--remote-allow-origins=*",
    "about:blank",
  ].filter(Boolean), { stdio: "ignore" });

  let cdp;
  try {
    cdp = await connect(port);
    await cdp.send("Runtime.enable");
    await cdp.send("Log.enable");
    await cdp.send("Page.enable");
    await cdp.send("Emulation.setDeviceMetricsOverride", {
      width: 1500, height: 1000, deviceScaleFactor: 1, mobile: false,
    });

    console.log("\n  page  " + PAGE);
    await cdp.send("Page.navigate", { url: PAGE });
    await cdp.waitFor("document.readyState === 'complete'", 25000, "load");
    await cdp.waitFor("typeof window.Vortex === 'object'", 40000, "app boot");
    await sleep(1200);   // let a few frames run

    /* ── boot ─────────────────────────────────────────────────────────── */
    section("boot");
    const env = await cdp.json(`({
      innerW: window.innerWidth, innerH: window.innerHeight,
      wasm: typeof WebAssembly, gl2: !!document.getElementById('gl').getContext('webgl2'),
      vendor: (function(){ const g = document.getElementById('gl').getContext('webgl2');
        const d = g.getExtension('WEBGL_debug_renderer_info');
        return d ? g.getParameter(d.UNMASKED_RENDERER_WEBGL) : g.getParameter(g.RENDERER); })(),
      title: document.title,
    })`);
    check("page boots with the test hook installed", true, env.title);
    check("WebGL2 context is live", env.gl2 === true, env.vendor);
    check("viewport is the requested 1500x1000", env.innerW === 1500 && env.innerH === 1000,
      `${env.innerW}x${env.innerH}`);
    check("no uncaught exceptions or console errors during boot",
      cdp.errors.length === 0, cdp.errors.slice(0, 3).join(" | ") || "clean");

    const s0 = await cdp.json("window.Vortex.stats()");
    check("simulation reports 500,000 particles", s0.count === 500000, `${s0.count}`);
    check("grid is 32^3 with a live occupancy count", s0.grid === 32 && s0.occupancy > 1000,
      `${s0.grid}^3, ${s0.occupancy} cells occupied, target ${s0.targetDensity.toFixed(1)}/cell`);
    check("spatial hash verifies (buckets == sorted list)", s0.verifyGrid === 0, `code ${s0.verifyGrid}`);
    check("no NaN after boot", s0.nan === 0, `${s0.nan} bad`);
    check("particles stay inside the sim volume", s0.maxCoord < 1.8, `max |coord| ${s0.maxCoord.toFixed(3)}`);

    /* ── the loop is really running ───────────────────────────────────── */
    section("frame loop");
    const f0 = await cdp.json("({ frame: window.Vortex.sim.getFrame(), t: performance.now() })");
    await sleep(1500);
    const f1 = await cdp.json("({ frame: window.Vortex.sim.getFrame(), t: performance.now() })");
    const df = f1.frame - f0.frame;
    check("the RAF loop advances the solver", df > 5, `${df} steps in ${Math.round(f1.t - f0.t)} ms`);
    const s1 = await cdp.json("window.Vortex.stats()");
    check("frames are actually being drawn", s1.fps > 3, `${s1.fps.toFixed(1)} fps`);
    console.log(`  \x1b[2m      physics ${s1.stepMs.toFixed(1)} ms · draw ${s1.drawMs.toFixed(1)} ms · ` +
      `${(1000 / Math.max(s1.stepMs, 0.01)).toFixed(0)} Hz ceiling\x1b[0m`);

    /* ── ink ──────────────────────────────────────────────────────────── */
    section("rendered output");
    let px = await cdp.json("window.Vortex.pixels()", false);
    check("the scene is not black (ink fraction)", px.litFrac > 0.02 && px.litFrac < 0.92,
      `${(px.litFrac * 100).toFixed(1)}% of pixels lit, mean ${px.mean.toFixed(1)}, peak ${px.max}`);
    check("the frame is not blown out", px.mean < 120, `mean ${px.mean.toFixed(1)}`);

    /* colour must be driven by velocity: kill the swirl and the palette cools */
    const before = await cdp.json("window.Vortex.pixels()");
    await cdp.evalJs("window.Vortex.setState({ spin: 0, polo: 0, turb: 0 }); return true;");
    await sleep(1600);
    const after = await cdp.json("window.Vortex.pixels()");
    const warmBefore = before.r / Math.max(1, before.b);
    const warmAfter = after.r / Math.max(1, after.b);
    check("colour is velocity-driven (still field is cooler than the vortex)",
      warmAfter < warmBefore * 0.75, `r/b ${warmBefore.toFixed(3)} → ${warmAfter.toFixed(3)}`);
    const slow = await cdp.json("window.Vortex.stats()");
    check("velocity actually falls when the field is switched off",
      slow.meanSpeed2 < s1.meanSpeed2 * 0.5,
      `mean speed² ${s1.meanSpeed2.toFixed(3)} → ${slow.meanSpeed2.toFixed(3)}`);
    await cdp.evalJs("window.Vortex.restoreDefaults(); return true;");

    /* ── mouse repulsion ──────────────────────────────────────────────── */
    section("mouse repulsion");
    await cdp.evalJs("window.Vortex.reset(); window.Vortex.pause(true); window.Vortex.setState({mouseForce: 0}); return true;");
    const count = () => cdp.json(`(() => {
      const V = window.Vortex, m = V.pointer(0.52, 0.06);
      V.step(1/60); V.step(1/60);
      const n = V.sim.getCount();
      const p = new Float32Array(V.sim.memory.buffer, V.sim.posPtr(), n * 4);
      const cx = m[0], cy = m[1], cz = m[2];
      let near = 0, tot = 0;
      for (let i = 0; i < n; i++) {
        const dx = p[i*4] - cx, dy = p[i*4+1] - cy, dz = p[i*4+2] - cz;
        if (dx*dx + dy*dy + dz*dz < 0.18) near++;
        tot++;
      }
      return { near, tot, frac: near / tot, mx: cx, my: cy, mz: cz };
    })()`);
    // the cursor sits at the centre of the ring: fire the repulsion, then release it
    const c0 = await count();
    await cdp.evalJs("window.Vortex.setState({mouseForce: 1.2}); return true;");
    for (let i = 0; i < 8; i++) await cdp.evalJs("window.Vortex.step(1/60); return true;");
    const c1 = await count();
    check("repulsion clears a hole around the cursor",
      c1.near < c0.near, `${c0.near} → ${c1.near} particles within r=0.42 of the cursor`);
    await cdp.evalJs("window.Vortex.setState({mouseForce: 0}); return true;");
    for (let i = 0; i < 90; i++) await cdp.evalJs("window.Vortex.step(1/60); return true;");
    const c2 = await count();
    check("the hole refills once the cursor force is gone",
      c2.near > c1.near, `${c1.near} → ${c2.near} particles`);

    /* ── pause / reset / counts ───────────────────────────────────────── */
    section("controls");
    await cdp.evalJs("window.Vortex.pause(true); window.Vortex.setState({mouseForce: 0.6}); return true;");
    const p0 = await cdp.json("window.Vortex.sim.getFrame()");
    await sleep(500);
    const p1 = await cdp.json("window.Vortex.sim.getFrame()");
    check("pause freezes the solver", p0 === p1, `${p0} == ${p1}`);
    check("paused state is shown to the user", (await cdp.json("window.Vortex.dom()")).paused === true);
    await cdp.evalJs("window.Vortex.pause(false); return true;");

    await cdp.evalJs("window.Vortex.setState({count: 125000}); return true;");
    await sleep(700);
    const small = await cdp.json("({ stats: window.Vortex.stats(), dom: window.Vortex.dom() })");
    check("the 125k preset re-inits the module", small.stats.count === 125000, `${small.stats.count}`);
    check("the readout and the label follow the preset together",
      small.dom.count === "125,000" && small.dom.tagline === "125,000 particles",
      `${small.dom.count} / ${small.dom.tagline}`);
    await cdp.evalJs("window.Vortex.setState({count: 500000}); return true;");
    await sleep(900);
    check("back to 500,000", (await cdp.json("window.Vortex.stats()")).count === 500000);

    /* determinism: reset rewinds to the same state */
    const det = await cdp.json(`(() => {
      const V = window.Vortex;
      V.pause(true); V.reset(); V.sim.setFlow(2.6,1.4,0.55,5,8,1.4); V.sim.setMouse(0,0,0,0.6,0);
      for (let i=0;i<24;i++) V.sim.step(1/60, i/60);
      const n = V.sim.getCount();
      const a = Float32Array.from(new Float32Array(V.sim.memory.buffer, V.sim.posPtr(), n*4));
      V.sim.reset(); V.sim.setFlow(2.6,1.4,0.55,5,8,1.4); V.sim.setMouse(0,0,0,0.6,0);
      for (let i=0;i<24;i++) V.sim.step(1/60, i/60);
      const b = new Float32Array(V.sim.memory.buffer, V.sim.posPtr(), n*4);
      let d = 0;
      for (let i=0;i<a.length;i++) d = Math.max(d, Math.abs(a[i]-b[i]));
      return { d, n };
    })()`);
    check("identical inputs produce bit-identical output", det.d === 0, `max Δ ${det.d} over ${det.n} particles`);

    /* grid debug view must change the picture */
    await cdp.evalJs("window.Vortex.pause(false); window.Vortex.setState({mode: 0}); return true;");
    await sleep(700);
    const mSpeed = await cdp.json("window.Vortex.pixels()");
    await cdp.evalJs("window.Vortex.setState({mode: 1}); return true;");
    await sleep(700);
    const mDens = await cdp.json("window.Vortex.pixels()");
    check("the grid-density view renders something different",
      Math.abs(mDens.mean - mSpeed.mean) > 1.5 && mDens.litFrac > 0.01,
      `mean ${mSpeed.mean.toFixed(2)} → ${mDens.mean.toFixed(2)}, ` +
      `legend "${(await cdp.json("window.Vortex.dom()")).legend}"`);
    await cdp.evalJs("window.Vortex.setState({mode: 0}); return true;");

    /* ── screenshots ──────────────────────────────────────────────────── */
    section("screenshots");
    await cdp.evalJs("window.Vortex.setState({count: 500000}); window.Vortex.pause(false); return true;");
    await sleep(1600);
    await cdp.evalJs("window.Vortex.setCamera(0.62, 0.40, 4.35); return true;");
    await sleep(300);
    const sh1 = await cdp.shot(path.join(SHOTS, "desktop.png"));
    check("desktop screenshot", fs.existsSync(sh1), path.relative(ROOT, sh1));
    await cdp.evalJs("window.Vortex.setState({mode: 1}); return true;");
    await sleep(900);
    await cdp.shot(path.join(SHOTS, "grid-view.png"));
    await cdp.evalJs("window.Vortex.setState({mode: 0}); return true;");

    /* ── responsive ───────────────────────────────────────────────────── */
    section("responsive");
    for (const [w, h, label] of [[1500, 1000, "desktop"], [768, 1024, "tablet"], [390, 844, "phone"], [320, 568, "small phone"]]) {
      await cdp.send("Emulation.setDeviceMetricsOverride", { width: w, height: h, deviceScaleFactor: 1, mobile: false });
      await sleep(700);
      const m = await cdp.json(`(() => {
        const over = [...document.querySelectorAll('#hud *')].filter(el => {
          const r = el.getBoundingClientRect();
          return r.width > 0 && (r.right > window.innerWidth + 1 || r.left < -1);
        }).map(el => el.id || el.className || el.tagName);
        const panel = document.getElementById('panel').getBoundingClientRect();
        const brand = document.getElementById('brand').getBoundingClientRect();
        return {
          inner: window.innerWidth, over,
          docOverflow: document.documentElement.scrollWidth - window.innerWidth,
          panelBottom: window.innerHeight - panel.bottom,
          brandRight: brand.right, panelRight: panel.right,
          canvasW: document.getElementById('gl').clientWidth,
          panelTopOf: document.getElementById('panel').getBoundingClientRect().top / window.innerHeight,
        };
      })()`);
      check(`${label} ${w}x${h}: no element overflows the viewport`,
        m.over.length === 0 && m.inner === w,
        `innerWidth ${m.inner}, ${m.over.length ? "offenders: " + m.over.slice(0, 4).join(",") : "clean"}`);
      check(`${label}: the control panel sits inside the frame`,
        m.panelBottom >= 8 && m.panelRight <= w + 1,
        `panel ${m.panelBottom.toFixed(0)}px above the bottom edge`);
      const bb = await cdp.json("window.Vortex.bbox()");
      check(`${label}: the subject is framed, not cropped`,
        !bb.empty && bb.edgeFrac < 0.012 && bb.left > 0.012 && bb.right > 0.012,
        `margins L ${(bb.left * 100).toFixed(1)}% R ${(bb.right * 100).toFixed(1)}%, ` +
        `edge ink ${(bb.edgeFrac * 100).toFixed(2)}%`);
      /* on a phone the control sheet is full-width, so the subject must sit
         entirely above it; on wider layouts the panel is a side card */
      if (w <= 500) {
        check(`${label}: the subject clears the control sheet`,
          bb.screenBottom < bb.panelTop - 0.01,
          `subject ends at ${(bb.screenBottom * 100).toFixed(0)}% from the top, ` +
          `panel starts at ${(bb.panelTop * 100).toFixed(0)}%`);
      }
      if (label === "phone") await cdp.shot(path.join(SHOTS, "phone.png"));
    }
    await cdp.send("Emulation.setDeviceMetricsOverride", { width: 1500, height: 1000, deviceScaleFactor: 1, mobile: false });
    await sleep(400);

    /* ── packaging ────────────────────────────────────────────────────── */
    section("packaging");
    const off = await cdp.json(`(() => {
      const html = document.documentElement.outerHTML;
      return {
        fetch: /\\bfetch\\s*\\(/.test(html), xhr: /XMLHttpRequest/.test(html),
        cdn: /<(script|img|iframe|source|link)\\b[^>]*\\b(src|href)\\s*=\\s*["']?(https?:)?\\/\\//i.test(html),
        resources: performance.getEntriesByType('resource').filter(r => !r.name.startsWith('data:')).map(r => r.name),
      };
    })()`);
    check("page makes no network requests", !off.fetch && !off.xhr && !off.cdn,
      `${off.resources.length} non-data resources loaded`);
    check("no console errors for the whole session", cdp.errors.length === 0,
      cdp.errors.slice(0, 3).join(" | ") || "clean");

    /* ── verdict ──────────────────────────────────────────────────────── */
    console.log(`\n${fail === 0 ? "\x1b[32m" : "\x1b[31m"}${pass}/${pass + fail} browser assertions passed\x1b[0m`);
    if (fail) { console.log("failed:\n  - " + fails.join("\n  - ")); }
    console.log(`\x1b[2mscreenshots: ${fs.readdirSync(SHOTS).filter(f => f.endsWith(".png")).join(", ")}\x1b[0m`);
    cdp.ws.close();
    child.kill();
    process.exit(fail ? 1 : 0);
  } catch (err) {
    console.error("\nharness error:", err.message);
    if (cdp) { try { cdp.ws.close(); } catch (e) {} }
    child.kill();
    process.exit(1);
  }
})();

#!/usr/bin/env node
/**
 * shot.js — quick visual capture while iterating on the look.
 *
 *   node scripts/shot.js                        → screenshots/shot.png at 1500x1000
 *   node scripts/shot.js --w=390 --h=844 --out=phone
 *   node scripts/shot.js --eval="window.Vortex.setState({mode:1})"
 */
const fs = require("fs");
const path = require("path");
const os = require("os");
const { spawn } = require("child_process");

const ROOT = path.resolve(__dirname, "..");
const args = process.argv.slice(2);
const arg = (k, d) => {
  const hit = args.find((a) => a.startsWith("--" + k + "="));
  return hit ? hit.slice(k.length + 3) : d;
};
const W = +arg("w", 1500), H = +arg("h", 1000);
const OUT = path.join(ROOT, "screenshots", arg("out", "shot") + ".png");
const SETUP = arg("eval", "");
const WAIT = +arg("wait", 2200);

const CHROME = [
  "C:/Program Files/Google/Chrome/Application/chrome.exe",
  "C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe",
].find((p) => fs.existsSync(p));

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

(async () => {
  const port = 9700 + (process.pid % 200);
  const profile = path.join(os.tmpdir(), "vshot-" + process.pid);
  const child = spawn(CHROME, [
    "--headless=new", "--no-first-run", "--no-default-browser-check",
    "--hide-scrollbars", "--mute-audio", "--force-device-scale-factor=1",
    `--window-size=${W},${H}`, "--user-data-dir=" + profile,
    "--remote-debugging-port=" + port, "--remote-allow-origins=*", "about:blank",
  ], { stdio: "ignore" });

  let ws, page;
  for (let i = 0; i < 100 && !page; i++) {
    try {
      const list = await fetch(`http://127.0.0.1:${port}/json/list`).then((r) => r.json());
      page = list.find((t) => t.type === "page" && t.webSocketDebuggerUrl);
    } catch (e) {}
    if (!page) await sleep(200);
  }
  if (!page) { console.error("no target"); child.kill(); process.exit(1); }

  ws = new WebSocket(page.webSocketDebuggerUrl);
  await new Promise((res, rej) => { ws.onopen = res; ws.onerror = rej; });
  let id = 0; const pending = new Map();
  ws.onmessage = (ev) => {
    const m = JSON.parse(ev.data);
    if (m.id && pending.has(m.id)) { pending.get(m.id)(m.result || {}); pending.delete(m.id); }
  };
  const send = (method, params = {}) => new Promise((res) => {
    const mid = ++id; pending.set(mid, res);
    ws.send(JSON.stringify({ id: mid, method, params }));
  });
  const ev = (expr) => send("Runtime.evaluate", {
    expression: `(() => { ${expr} })()`, returnByValue: true, awaitPromise: true,
  });

  await send("Emulation.setDeviceMetricsOverride", { width: W, height: H, deviceScaleFactor: 1, mobile: false });
  await send("Page.navigate", { url: "file:///" + path.join(ROOT, "index.html").replace(/\\/g, "/") });
  await sleep(600);
  for (let i = 0; i < 100; i++) {
    const r = await ev("return typeof window.Vortex === 'object';");
    if (r.result && r.result.value) break;
    await sleep(200);
  }
  if (SETUP) await ev(SETUP + "; return true;");
  await sleep(WAIT);
  const shot = await send("Page.captureScreenshot", { format: "png" });
  fs.mkdirSync(path.dirname(OUT), { recursive: true });
  fs.writeFileSync(OUT, Buffer.from(shot.data, "base64"));
  const st = await ev("const s = window.Vortex.stats(); return JSON.stringify({fps: +s.fps.toFixed(1), step: +s.stepMs.toFixed(1), occ: s.occupancy, frame: window.Vortex.frame()});");
  console.log("shot:", path.relative(ROOT, OUT), st.result.value || "");
  ws.close(); child.kill();
  await sleep(300);
  process.exit(0);
})();

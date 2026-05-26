#!/usr/bin/env node
/**
 * Capture hackathon demo screenshots for docs/screenshots/
 * Requires: npx playwright (chromium), Docker on :3001, OPENAI key in .env
 */
import { chromium } from "playwright";
import { spawn } from "child_process";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.join(__dirname, "..");
const OUT = path.join(ROOT, "docs", "screenshots");
const PORT = process.env.FLOWZINT_PORT || "3001";
const BASE = `http://localhost:${PORT}`;
const STOREFRONT = `file://${path.join(ROOT, "demo", "storefront", "index.html")}`;

fs.mkdirSync(OUT, { recursive: true });

function serveStorefront(port = 8765) {
  return new Promise((resolve) => {
    const proc = spawn(
      "python3",
      ["-m", "http.server", String(port), "--bind", "127.0.0.1"],
      { cwd: path.join(ROOT, "demo", "storefront"), stdio: "ignore" }
    );
    setTimeout(() => resolve({ proc, url: `http://127.0.0.1:${port}/index.html` }), 800);
  });
}

async function waitForWidget(page, timeout = 20000) {
  const selectors = [
    '[aria-label="Toggle Menu"]',
    '[aria-label="Close"]',
  ];
  for (const sel of selectors) {
    try {
      await page.waitForSelector(sel, { timeout });
      return sel;
    } catch {
      /* try next */
    }
  }
  return null;
}

async function openChat(page) {
  const sel = await waitForWidget(page, 15000);
  if (sel) {
    await page.click(sel);
    await page.waitForTimeout(1200);
    return true;
  }
  await page.click("#openChatBtn").catch(() => {});
  await page.waitForTimeout(800);
  return false;
}

async function sendChatMessage(page, text) {
  const inputSelectors = [
    'textarea[placeholder*="message" i]',
    'textarea[placeholder*="Ask" i]',
    "#anythingllm-chat-widget textarea",
    ".anythingllm-chat-input textarea",
    'textarea',
  ];
  for (const sel of inputSelectors) {
    const el = page.locator(sel).first();
    if ((await el.count()) > 0) {
      await el.fill(text);
      await el.press("Enter");
      return true;
    }
  }
  return false;
}

async function main() {
  const ping = await fetch(`${BASE}/api/ping`).catch(() => null);
  if (!ping?.ok) {
    console.error(`ERROR: ${BASE} not reachable. Run ./scripts/start.sh`);
    process.exit(1);
  }

  const { proc: httpProc, url: storefrontUrl } = await serveStorefront();
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({
    viewport: { width: 1440, height: 900 },
    deviceScaleFactor: 2,
  });

  try {
    // 1. Storefront full page
    const page1 = await context.newPage();
    await page1.goto(storefrontUrl, { waitUntil: "networkidle", timeout: 60000 });
    await page1.waitForTimeout(2500);
    await page1.screenshot({
      path: path.join(OUT, "01-zintmart-storefront-full.png"),
      fullPage: true,
    });
    console.log("[ok] 01-zintmart-storefront-full.png");

    // 2. Chat widget open
    const page2 = await context.newPage();
    await page2.goto(storefrontUrl, { waitUntil: "networkidle", timeout: 60000 });
    await page2.waitForTimeout(2000);
    await openChat(page2);
    await page2.waitForTimeout(1500);
    await page2.screenshot({
      path: path.join(OUT, "02-chat-widget-open.png"),
      fullPage: false,
    });
    console.log("[ok] 02-chat-widget-open.png");

    // 3. Cited answer (demo query)
    const page3 = await context.newPage();
    await page3.goto(storefrontUrl, { waitUntil: "networkidle", timeout: 60000 });
    await page3.waitForTimeout(2000);
    await openChat(page3);
    await page3.waitForTimeout(1000);
    const sent = await sendChatMessage(
      page3,
      "What is the return window for wireless earbuds?"
    );
    if (sent) {
      await page3.waitForTimeout(12000);
    } else {
      console.warn("[warn] Could not find chat input — screenshot may show empty chat");
      await page3.waitForTimeout(2000);
    }
    await page3.screenshot({
      path: path.join(OUT, "03-cited-answer-earbuds.png"),
      fullPage: false,
    });
    console.log("[ok] 03-cited-answer-earbuds.png");

    // 4. Admin / workspace (public login page or workspace if session exists)
    const page4 = await context.newPage();
    await page4.goto(BASE, { waitUntil: "networkidle", timeout: 60000 });
    await page4.waitForTimeout(3000);
    await page4.screenshot({
      path: path.join(OUT, "04-admin-workspace.png"),
      fullPage: false,
    });
    console.log("[ok] 04-admin-workspace.png");

    // 5. Demo chips section
    const page5 = await context.newPage();
    await page5.setViewportSize({ width: 390, height: 844 });
    await page5.goto(storefrontUrl + "#support", { waitUntil: "networkidle", timeout: 60000 });
    await page5.waitForTimeout(1500);
    await page5.screenshot({
      path: path.join(OUT, "05-mobile-demo-chips.png"),
      fullPage: false,
    });
    console.log("[ok] 05-mobile-demo-chips.png");

    await page1.close();
    await page2.close();
    await page3.close();
    await page4.close();
    await page5.close();
  } finally {
    httpProc.kill();
    await browser.close();
  }

  console.log(`\nScreenshots saved to ${OUT}`);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});

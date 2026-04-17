const { defineConfig } = require('@playwright/test');

module.exports = defineConfig({
  testDir: './tests',
  timeout: 30_000,
  expect: {
    timeout: 10_000,
  },
  reporter: 'line',
  use: {
    baseURL: 'http://127.0.0.1:8010',
    trace: 'on-first-retry',
    headless: true,
  },
  webServer: {
    command: 'python3 -m http.server 8010',
    port: 8010,
    reuseExistingServer: true,
    timeout: 30_000,
  },
});

const { test, expect } = require('@playwright/test');

const LOCALES = ['en', 'es', 'ca'];

for (const locale of LOCALES) {
  test(`map smoke ${locale}`, async ({ page }) => {
    await page.goto(`/docs/${locale}/map.html`, { waitUntil: 'domcontentloaded' });
    await page.waitForSelector('#community-select');
    await page.waitForSelector('#district-select');

    // Assert the focus layer uses dissolved community geometries.
    const html = await page.content();
    expect(html).toContain("id: 'community-focus-outline', type: 'line', source: 'communities'");

    const y1933 = page.locator('.year-btn', { hasText: '1933' });
    if (await y1933.count()) {
      await y1933.first().click();
    }

    const districtSelect = page.locator('#district-select');
    const districtOptions = await districtSelect.locator('option').allTextContents();
    expect(districtOptions.some((t) => t.includes('Barcelona (provincia)'))).toBeTruthy();

    const communitySelect = page.locator('#community-select');
    const communityOptions = await communitySelect.locator('option').evaluateAll((opts) =>
      opts.map((o) => ({ value: o.value, label: (o.textContent || '').trim() }))
    );
    const selectedCommunity = communityOptions.find((o) => o.value && o.value.trim() !== '');
    expect(selectedCommunity).toBeTruthy();
    await communitySelect.selectOption(selectedCommunity.value);

    const resetButton = page.locator('button', { hasText: /reset|reiniciar|reinicia/i }).first();
    await expect(resetButton).toBeVisible();
    await resetButton.click();

    await expect(communitySelect).toHaveValue('');
    await expect(districtSelect).toHaveValue('');

    const notice = page.locator('#selection-notice');
    if (await notice.count()) {
      const text = ((await notice.textContent()) || '').trim();
      const visible = await notice.isVisible();
      expect(!visible || text === '').toBeTruthy();
    }
  });
}

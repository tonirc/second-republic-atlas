# Electoral Atlas of the Spanish Second Republic — v2

Multilingual interactive web atlas of municipal election results for
the three general elections of the Spanish Second Republic (1931, 1933, 1936).

**Languages:** English · Español · Català
**Map:** Maplibre GL JS · free, no API key required
**Built with:** R · Quarto · GitHub Pages

---

## Pages (all three languages)

| Tab | EN | ES | CA |
|-----|----|----|-----|
| Home | `index.qmd` | `index.qmd` | `index.qmd` |
| Map | `map.qmd` | `map.qmd` | `map.qmd` |
| Codebook | `codebook.qmd` | `codebook.qmd` | `codebook.qmd` |
| Contribute | `contribute.qmd` | `contribute.qmd` | `contribute.qmd` |
| About | `about.qmd` | `about.qmd` | `about.qmd` |
| The Book | `book.qmd` | `book.qmd` | `book.qmd` |

---

## Project structure

```
republic-elections/
├── en/                     # English Quarto project
│   ├── _quarto.yml
│   ├── index.qmd
│   ├── map.qmd
│   ├── codebook.qmd
│   ├── contribute.qmd
│   ├── about.qmd
│   └── book.qmd
├── es/                     # Spanish Quarto project (same structure)
├── ca/                     # Catalan Quarto project (same structure)
├── data/
│   ├── prepare_data.R      # Run locally to build municipios.geojson
│   └── municipios.geojson  # ← you create this (see below)
├── images/
│   ├── upf-logo.png        # ← add your logos here
│   └── ministerio-logo.png
├── pdfs/
│   └── codebook.pdf        # ← add your codebook PDF here
├── styles.css              # Shared stylesheet (all languages)
├── index.html              # Root redirect → /en/
└── .github/
    └── workflows/
        └── publish.yml     # Auto-deploy to GitHub Pages
```

---

## Quickstart

### 1. Prepare your GeoJSON

Edit and run `data/prepare_data.R` with your shapefile and election CSV.
The output `data/municipios.geojson` needs these properties per feature:

```
cod_muni, nombre, provincia,
left_1931,  right_1931,  other_1931,  turnout_1931,
left_1933,  right_1933,  other_1933,  turnout_1933,
left_1936,  right_1936,  other_1936,  turnout_1936
```
All vote share and turnout values should be **0 to 1** (not percentages).
Target file size: **under 8 MB** after simplification.

### 2. Add logos

Place `upf-logo.png` and `ministerio-logo.png` in `/images/`.
Then in each language's `index.qmd`, replace the `.logo-placeholder` div with:
```html
<img src="../../images/upf-logo.png" class="logo-img" alt="UPF">
```

### 3. Add your codebook PDF

Place `codebook.pdf` in `/pdfs/`.
Then in each language's `codebook.qmd`, uncomment the iframe line.

### 4. Update contact email

Search all `contribute.qmd` files for `yourname@upf.edu` and replace with your real address.

### 5. Render locally

```bash
./render-all.sh
# Open docs/en/index.html in browser to check
```

If you render a single language manually, use:

```bash
quarto render en --output-dir docs/en
rsync -a --delete en/docs/en/ docs/en/
rm -rf en/docs
```

### 6. Deploy

```bash
git add .
git commit -m "initial site"
git push origin main
```
GitHub Actions will render all three language sites and deploy to GitHub Pages automatically.
Enable Pages in: **Settings → Pages → Source: gh-pages branch (root)**.

Your site: `https://yourusername.github.io/yourrepo/`

---

## Customisation checklist

- [ ] Replace logo placeholders in `en/index.qmd`, `es/index.qmd`, `ca/index.qmd`
- [ ] Add `pdfs/codebook.pdf` and uncomment iframe in all `codebook.qmd` files
- [ ] Replace `yourname@upf.edu` in all `contribute.qmd` files
- [ ] Fill in real team member names/bios in all `about.qmd` files
- [ ] Update book details (publisher, date) in all `book.qmd` files
- [ ] Replace `PID2023-XXXXXX` grant reference in all `about.qmd` files
- [ ] Run `data/prepare_data.R` to produce `data/municipios.geojson`

# Project: Election Results — Spanish Second Republic

## Overview

This project builds a multilingual academic website to present municipality-level election results for Spain during the Second Republic (1931, 1933, 1936).

The site is built using **Quarto**, hosted on **GitHub Pages**, and combines:

- Static content pages
- Interactive web mapping (Maplibre GL JS)
- Downloadable documentation (PDFs)
- Multilingual structure (English, Spanish, Catalan)

---

## Core Features

### 1. Website Structure

The site consists of multiple tabs (pages), consistent across all languages:

- **Home (Landing page)**  
  - Project title: *Electoral Atles of the Spanish Second Republic*  
  - Two logos (UPF + Ministerio)  
  - Introductory text  
  - Optional plots/logs (R/ggplot)

- **Map**  
  - Interactive municipality-level map using Maplibre GL JS  
  - Displays election results for:
    - 1931
    - 1933
    - 1936  

- **Codebook**  
  - Embedded and downloadable PDF  
  - Description of variables and data structure  

- **About**  
  - Project description  
  - Team information  
  - Funding details  

- **Book Project**  
  - Description of associated academic book  
  - Chapters and research scope  

- **Contribute / Contact**  
  - Email link or form  
  - Users can report errors or suggest improvements  

---

## Multilingual Setup

Languages supported:

- English (`/en/`)
- Spanish (`/es/`)
- Catalan (`/ca/`)

### Approach

Each language is a separate Quarto project:

/en/
/es/
/ca/

Each contains identical structure:

index.qmd
map.qmd
codebook.qmd
about.qmd
book.qmd
contribute.qmd
_quarto.yml

Shared assets:

/images/
/pdfs/
/data/
styles.css

---

## Deployment

- Hosted via **GitHub Pages**
- Output directory: `/docs/`
- Each language renders to:
  - `docs/en/`
  - `docs/es/`
  - `docs/ca/`

---

## Mapping Strategy

### Library Choice

**Maplibre GL JS** is used because:

- No API key required (open source)
- High performance (WebGL)
- Handles ~9,000 municipalities efficiently
- Same technology family as Mapbox

---

---

## Map Features

### Core controls

Users can select:

- Year: 1931, 1933, 1936
- Variable:
  - Left support
  - Right support
  - Other parties
  - Turnout

### Party-level dropdown

- “Select party”
- Shows Party A → Party H (placeholder)
- Updates based on year

---

## Performance Considerations

- Geometry simplification (critical)
- GeoJSON target size: < 8MB
- Use PMTiles if needed

---

## Styling

Use custom CSS:

```yaml
format:
  html:
    theme: none
    css: "styles.css"
```
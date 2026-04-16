# Electoral Atlas of the Spanish Second Republic

<p align="center">
    <img src="en/images/upf-logo.png" alt="Universitat Pompeu Fabra" height="64">
    &nbsp;&nbsp;&nbsp;
    <img src="en/images/ministerio-logo.png" alt="Ministerio de Ciencia e Innovacion" height="64">
</p>

An interactive, multilingual website with municipality-level election results for the three general elections of the Spanish Second Republic: 1931, 1933, and 1936.

This project is designed for researchers, students, journalists, and anyone interested in Spanish political history.

## What You Can Find On The Site

- Home: project overview and highlights.
- Map: interactive municipality map (zoom, search, year/variable selection).
- Dataset: data documentation and downloadable codebook.
- Methods: how the dataset was built, project timeline, and source examples.
- Contribute: contact page to report corrections or suggest improvements.
- About: team and project information.
- The Book: related book project.

## Languages

- English
- Spanish
- Catalan

Each language has its own Quarto project folder:

- en/
- es/
- ca/

## Technology

- Quarto for the website structure and rendering.
- MapLibre GL JS for the interactive map.
- R scripts for data preparation.
- GitHub Pages for hosting.

## Project Structure

```
Website/
├── en/                # English source pages
├── es/                # Spanish source pages
├── ca/                # Catalan source pages
├── data/              # Data prep scripts and map inputs
├── docs/              # Rendered site (published by GitHub Pages)
├── render-all.sh      # Renders EN/ES/CA and syncs docs/
└── README.md
```

## Local Build

Requirements:

- Quarto installed
- R installed (for data preparation scripts)

Build all languages:

```bash
./render-all.sh
```

After rendering, open docs/en/index.html (or docs/es/index.html, docs/ca/index.html) in a browser.

## Data Expectations For The Map

Main map file: data/municipios.geojson

Expected properties include:

```
cod_muni, nombre, provincia,
left_1931, right_1931, other_1931, turnout_1931,
left_1933, right_1933, other_1933, turnout_1933,
left_1936, right_1936, other_1936, turnout_1936
```

Use values between 0 and 1 for vote shares and turnout.

## Updating Logos

Repository logo files are currently in:

- en/images/upf-logo.png
- en/images/ministerio-logo.png

If you replace these images, keep the same filenames to avoid changing page references.

## Contributing

Corrections and suggestions are welcome. Please use the Contribute page on the site or open an issue/pull request in this repository.

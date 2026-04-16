# ============================================================
# DATA PREPARATION SCRIPT
# Electoral Atlas of the Spanish Second Republic
# ============================================================
# Run this script LOCALLY before pushing to GitHub.
# Output: data/municipios.geojson
#
# GeoJSON properties per feature (1936 data only for now):
#   cod_muni         - municipality code (string)
#   nombre           - municipality name
#   provincia        - province name
#   left_1936        - left coalition vote share       (0–1)
#   right_1936       - right coalition vote share      (0–1)
#   basque_1936      - Basque nat. coalition           (0–1)
#   centrist_1936    - centrist platforms              (0–1)
#   other_1936       - other parties                   (0–1)
#   blank_null_1936  - blank and null votes            (0–1)
#   turnout_1936     - voter turnout (real)            (0–1)
#   turnout_est_1936 - voter turnout (estimated)       (0–1)
# ============================================================

library(sf)
library(dplyr)
library(rmapshaper)
library(readxl)

# ── 1. Load shapefile ─────────────────────────────────────
muni <- st_read("data/maps/map_muni_es_1930.shp")

muni_clean <- muni |>
  rename(
    cod_muni  = cod_ine,
    nombre    = muni,
    provincia = prov
  ) |>
  mutate(cod_muni = as.character(cod_muni)) |>
  select(cod_muni, nombre, provincia, geometry)

# ── 2. Load election data ─────────────────────────────────
elections_raw <- read_xlsx("../Datasets/Final_dataset1936/dataset_muni_vote_shares_1936_02.xlsx")

elections_raw <- elections_raw |>
  select(mun, cod_mun, turnout_est, turnout_real,
         pct_sumbased_basque_nat_coal,
         pct_sumbased_blank_and_null,
         pct_sumbased_left_coalition,
         pct_sumbased_right_coalition,
         pct_sumbased_other,
         pct_sumbased_centrist_platforms)

elections_clean <- elections_raw |>
  rename(cod_muni = cod_mun) |>
  mutate(cod_muni = as.character(cod_muni)) |>
  rename(
    left_1936        = pct_sumbased_left_coalition,
    right_1936       = pct_sumbased_right_coalition,
    basque_1936      = pct_sumbased_basque_nat_coal,
    centrist_1936    = pct_sumbased_centrist_platforms,
    other_1936       = pct_sumbased_other,
    blank_null_1936  = pct_sumbased_blank_and_null,
    turnout_1936     = turnout_real,
    turnout_est_1936 = turnout_est
  ) |>
  select(cod_muni, left_1936, right_1936, basque_1936, centrist_1936,
         other_1936, blank_null_1936, turnout_1936, turnout_est_1936)

# ── Normalize to 0–1 if values are in percentage scale (0–100) ────────────
pct_cols <- c("left_1936", "right_1936", "basque_1936", "centrist_1936",
              "other_1936", "blank_null_1936", "turnout_1936", "turnout_est_1936")
if (any(sapply(elections_clean[pct_cols], function(x) any(x > 1.1, na.rm = TRUE)))) {
  message("Values appear to be in percentage scale (0–100). Dividing by 100.")
  elections_clean <- elections_clean |>
    mutate(across(all_of(pct_cols), ~ . / 100))
}

# ── 3. Join ───────────────────────────────────────────────
muni_joined <- muni_clean |>
  left_join(elections_clean, by = "cod_muni")

n_matched <- sum(!is.na(muni_joined$left_1936))
cat("Municipalities with 1936 data:", n_matched, "/", nrow(muni_joined), "\n")

# ── 4. Simplify ───────────────────────────────────────────
# keep = 0.35 retains materially more boundary detail while keeping
# the municipality GeoJSON small enough for responsive browser rendering.
muni_simple <- ms_simplify(muni_joined, keep = 0.35, keep_shapes = TRUE)

# ── 5. Write GeoJSON ──────────────────────────────────────
dir.create("data", showWarnings = FALSE)
st_write(muni_simple, "data/municipios.geojson",
         driver = "GeoJSON",
         layer_options = c("RFC7946=YES", "COORDINATE_PRECISION=5"),
         delete_dsn = TRUE)

cat("File size:", round(file.size("data/municipios.geojson") / 1e6, 1), "MB\n")
# If > 8 MB: reduce keep to 0.03 or convert to PMTiles:
#   tippecanoe -o data/municipios.pmtiles -z12 data/municipios.geojson

# ── 6. Validate ───────────────────────────────────────────
muni_joined |>
  st_drop_geometry() |>
  filter(!is.na(left_1936)) |>
  mutate(sum_1936 = left_1936 + right_1936 + basque_1936 + centrist_1936 +
                    other_1936 + blank_null_1936) |>
  summarise(
    n          = n(),
    sum_min    = min(sum_1936, na.rm = TRUE),
    sum_max    = max(sum_1936, na.rm = TRUE),
    sum_median = median(sum_1936, na.rm = TRUE)
  ) |>
  print()

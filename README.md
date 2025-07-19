# Bee_Flight_Audio_Analysis

This repository holds the R scripts used to preprocess honey-bee wing-beat recordings, generate single-file spectra, and overlay 10 spectra.  
**All code is exactly the same as the version used for the manuscript; it has only been split into separate files.**

***Bug reports & pull requests.
Please open a GitHub issue or PR, or contact:

Author: Chien-Chun Hung
j35596768j@gmail.com

Lab: Chieh-Chen Huang Lab, National Chung Hsing University

***Citation
If you use this code, please cite our forthcoming manuscript:
A formal citation with DOI will be added once the paper is published.

---

## File map

| Path / file | Purpose |
|-------------|---------|
| `01_convert_and_filter.R` | Converts `.m4a` → `.wav`, FFT-filters > 600 Hz, writes `_filtered.wav` |
| `02_plot_single_spectrum.R` | Reads one filtered wav, plots 0–500 Hz spectrum |
| `03_overlay_multi_spectra.R` | Overlays 10 spectra, extracts mean freq/amp, saves PNG + CSV |
| `data/` | Raw `.m4a` recordings |
| `results/` | Filtered wav + CSV output |
| `figures/` | PNG figures |

---

## How to run

```bash
# 1. convert & filter *all* raw files
Rscript 01_convert_and_filter.R

# 2. plot the spectrum of ONE file 
Rscript 02_plot_single_spectrum.R 

# 3. overlay 10 spectra and export summary table
Rscript 03_overlay_multi_spectra.R


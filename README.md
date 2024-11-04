# Clinical-Trial-Disparities

This repository contains analyses of disparities in clinical trial participation among Black individuals for scleroderma and non-melanoma skin cancers (BCC and cSCC) in the United States. The analyses assess whether clinical trial demographics reflect those of the broader patient populations.

## Repository Contents

This repository includes the following files:

1. **Reports in Quarto and R Markdown formats**:
   - **US_Scleroderma_Clinical_Trial_Disparities_Analysis.qmd**: An analysis of demographic disparities in U.S. clinical trials for scleroderma. This report examines the proportion of Black participants in scleroderma clinical trials versus estimates from the general scleroderma patient population in the U.S., with a focus on the southeastern states.
   - **US_BCC_and_CSCC_Clinical_Trial_Disparities_Analysis.Rmd**: An analysis comparing the demographics of Black patients in clinical trials for Basal Cell Carcinoma (BCC) and Cutaneous Squamous Cell Carcinoma (cSCC) against those in a commercially insured cohort diagnosed with these cancers.

2. **Rendered Reports**:
   - Word document (.docx) versions of both analyses, including the code, interpretations, and visualizations of the findings.

3. **Raw R Code**:
   - **20240912_scleroAnalysis.R**: Contains the raw R code for the scleroderma clinical trial disparity analysis.
   - **20240915_bccCsccAnalysis.R**: Contains the raw R code for the BCC and cSCC clinical trial disparity analysis.

## Analysis Summaries

### Scleroderma Clinical Trial Disparity Analysis
The report investigates representation disparities of Black patients in scleroderma clinical trials compared to the general scleroderma population in the U.S. Using a Pearson's chi-square test, the analysis examines the underrepresentation of Black patients in clinical trials relative to the Black scleroderma patient population in the southeastern U.S. The analysis estimates the number of Black scleroderma patients unrepresented in clinical trials.

### BCC and cSCC Clinical Trial Disparity Analysis
This report compares the demographics of Black patients participating in U.S. clinical trials for BCC and cSCC with those of insurance claimants diagnosed with these cancers. Using data from ClinicalTrials.gov, the report visualizes and quantifies disparities through bar plots and chi-square tests, highlighting the underrepresentation of Black patients in clinical trials relative to insurance claims data.


## Data Sources

Data used in these analyses were collected from:
- **ClinicalTrials.gov**: Publicly available clinical trial data for scleroderma, BCC, and cSCC.
- **U.S. Census Bureau**: Population estimates and demographics for calculating expected representation in clinical trials.
- **Research Studies**: Findings from studies such as those by Mayes et al. (2003) and Lukowiak et al. (2020), which provided population and demographic baselines for the patient populations analyzed.

## Packages Used
The R scripts in this repository utilize the following packages:
- `tidyverse` for data wrangling and visualization
- `gt` for table creation
- `extrafont` (optional, for fonts in visualizations)

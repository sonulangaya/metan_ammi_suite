# metan_ammi_suite [![DOI](https://zenodo.org/badge/725119457.svg)](https://zenodo.org/doi/10.5281/zenodo.10804419)
# R script for comprehensive G * E analysis (AMMI model) based on metan package
Your one-stop solution for comprehensive genotype × environment interaction and stability analysis (AMMI model) using the metan package. Save time, perform analyses for all traits at once, and gain insightful visualizations effortlessly!"

## Overview

metan_ammi_suite is a powerful R script that facilitates comprehensive genotype × environment interaction and stability analysis using the metan package. The script is designed to import your data, clean and inspect it, and perform a range of analyses for all traits at once, with a specific focus on the AMMI model.


## Major highlights

- **Efficient Output Extraction:** The script excels in extracting analysis results in Excel format, ensuring clean and organized outputs. This feature enhances the interpretability of the results and facilitates seamless reporting.

- **All-in-One Operation:** Enjoy the convenience of performing all operations for multiple variables in your data file at once. The script is designed for usability, allowing users to conduct diverse analyses for all traits in a unified process.

## Features

- **Data Import and Inspection:** Easily import your data and inspect it for unique factors and traits.

- **Descriptive Statistics:** Obtain descriptive statistics for your dataset, including histograms and summary tables.

- **Mean Performances:** Calculate mean performances for genotypes, environments, and their interactions.

- **Two-Way Tables:** Generate two-way tables for all traits, providing a comprehensive overview.

- **Performance Plots:** Create high-quality plots illustrating performance across environments for each trait.

- **Genotype-Environment Winners:** Identify winners and ranking based on genotype-environment interactions.

- **GE or GGE Effects:** Visualize combined genotype-environment effects for all traits.

- **Fixed Effect Models:** Conduct individual and joint ANOVA for all traits.

- **AMMI Based Stability Analysis:**
  - ANOVA: Analyze stability using the AMMI model.
  - Model: Obtain AMMI-based stability analysis for all traits.
  - Means G*E: Explore means for genotype-environment interactions.

- **AMMI Biplots:**
  - Generate AMMI biplots for all traits in one using AMMI1 and AMMI2.

## Usage

1. Import your data using `read.csv()`.
2. Execute the script, adjusting parameters as needed.
3. View the results in the generated Excel files and plots.

## How to Run

1. Install required R packages: metan, ggplot2, ggrepel, writexl, openxlsx.

## Installation
Before running the script, make sure to install the required R packages. You can do this by running the following code in your R environment:

```R
# Install required R packages if not already installed
packages <- c("metan", "ggplot2", "ggrepel", "writexl", "openxlsx")

# Check if each package is installed, and install if not
for (package in packages) {
  if (!requireNamespace(package, quietly = TRUE)) {
    install.packages(package, dependencies = TRUE)
  }
}
```
2. Downlaod the [script](metan_ammi_suite.R) to your machine 
3. Run the script in RStudio or your preferred R environment.

## Folder Structure

- **output:** Store excel output.
- **perfor_plots:** Contains high-quality performance plots.
- **ge_plots:** Contains plots illustrating genotype-environment effects.
- **ammi1_plots and ammi2_plots:** Store AMMI biplots for AMMI1 and AMMI2, respectively.

## Contributors

- [Sonu Langaya]
  
## Acknowledgements

Special thanks to [Tiago Olivoto], the creator of the `metan` package used in this analysis. The `metan` package provides valuable tools for stability analysis, contributing significantly to the functionality of this project. We appreciate the author's dedication to developing and maintaining this resource for the scientific community.

Also the end user is advised to get into touch with the [metan pckage here](https://github.com/TiagoOlivoto/metan)


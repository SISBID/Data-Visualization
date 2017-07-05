# SISBID 2017 Module 2: Visualization of Biomedical Big Data

Instructors: Dianne Cook and Heike Hofmann

Module description: In this module, we will present general-purpose techniques for visualizing any sort of large data sets, 
as well as specific techniques for visualizing common types of biological data sets. Often the challenge of visualizing Big Data 
is to aggregate it down to a suitable level. Understanding Big Data involves an iterative cycle of visualization and modeling. 
We will illustrate this with several case studies during the workshop. The first segment of this module will focus on structured 
development of graphics using static graphics. This will use the ggplot2 package in R. It enables building plots using 
grammatically defined elements, and producing templates for use with multiple data sets. We will show how to extend these 
principles for genomic data using the ggplot2-based ggbio package. The second segment will focus on interactive graphics 
for rapid exploration of Big Data. We will also demonstrate interactive techniques using plotly, animint and ggvis. In addition 
we will explain how to create simple web GUIs for managing complex summaries of biological data using the shiny package. 
We will use a hands-on teaching methodology that combines short lectures with longer practice sessions. As students learn about 
new techniques, they will also be able to put them into practice and receive feedback from experts. We will teach using R and Rstudio. 
We will assume some familiarity with R.

Recommended Reading: Cookbook for R, by Winston Chang, available at <http://www.cookbook-r.com>, and R for Data Science, by Garrett Grolemund and Hadley Wickham, available at <http://r4ds.had.co.nz>.

## Course outline

### Day 1

1. The grammar of graphics and ggplot2 (Di).
1. Multivariate plots for bioinformatics, using ggplot2 and GGally (Di).

### Day 2

1. Tidy data and tidying your messy data with tidyr (Heike).
1. Data manipulation with dplyr, purrr and broom (Heike).
1. Advanced graphics, and statistical inference (Di) 
1. Drawing lineage using ggenealogy and genomic plots (Di).

### Day 3

1. Logo plots for genome sequences and proteins, networks (Heike).
1. Interactive graphics using plotly, animint and ggvis (Heike).
1. Building interactive web apps with shiny (Di).
1. Make your own shiny app (Di).

## Software list

Download [RStudio >= 1.0.143](https://www.rstudio.com/products/rstudio/download/), [R >= 3.4.1](https://cran.r-project.org/) (2017-06-30) -- "Single Candle" (Its ok to have 3.4.0, too.)

Open RStudio, and run the code below to install these packages and their dependencies:
```
# CRAN packages
packages <- c("tidyverse", "broom", "GGally", "nullabor", "shiny", "plotly", "xkcd", "gglogo", "geomnet", "seqinr", "ggenealogy", "ggmosaic")

install.packages(packages, dep=TRUE, repos = "https://cloud.r-project.org/")


# Bioconductor packages
bioC <- c("ggbio", "edgeR", "EDASeq", "limma", "splatter", "Glimma", "gplots")
source("https://bioconductor.org/biocLite.R")
biocLite(bioC)


# packages under development
devtools::install_github("dicook/nullabor")
```

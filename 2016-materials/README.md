# SISBID 2016 Module 2: Visualization of Biomedical Big Data

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

Recommended Reading: Cookbook for R, by Winston Chang, available at <http://www.cookbook-r.com>.

## Course outline

### Day 1

1. The grammar of graphics and ggplot2 (Di).
1. Multivariate plots for bioinformatics, using ggplot2 and GGally (Di).

### Day 2

1. Tidy data and tidying your messy data with tidyr (Di).
1. Data manipulation with dplyr, purrr and broom (Heike).
1. Logo plots for genome sequences and proteins (Heike).
1. Genomic plots using ggbio (Di).

### Day 3

1. Drawing lineage using ggenealogy (Di), networks (Heike)
1. Interactive graphics using plotly, animint and ggvis (Di).
1. Building interactive web apps with shiny (Heike).
1. Make your own shiny app (Heike).

## Software list

Download [RStudio >= 0.99.902](https://www.rstudio.com/products/rstudio/download/), [R >= 3.3.0](https://cran.r-project.org/) (2016-05-03) -- "Supposedly Educational" and install these and their dependencies
Open RStudio, and run the code below to install these packages and their dependencies:
```
# CRAN packages
packages <- c("devtools", "ggplot2", "tidyr", "dplyr", "purrr", "broom", "biobroom", 
"GGally", "nullabor", "shiny", "ggvis", "plotly", "xkcd", "gglogo",
"seqinr")

install.packages(packages, dep=TRUE, repos = "https://cloud.r-project.org/")


# Bioconductor packages
bioC <- c("ggbio", "epivzr", "edgeR", "EDAseq")
source("https://bioconductor.org/biocLite.R")
biocLite(bioC)


# packages under development
devtools::install_github("sctyner/geomnet")
devtools::install_github("lrutter/ggenealogy")
devtools::install_github("haleyjeppson/ggmosaic")
```


<!-- 
rmarkdown::render("README.Rmd")
#-->

# nhds

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/nhds)](https://CRAN.R-project.org/package=nhds)
[![Travis build
status](https://travis-ci.org/jackwasey/nhds.svg?branch=master)](https://travis-ci.org/jackwasey/nhds)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/jackwasey/nhds?branch=master&svg=true)](https://ci.appveyor.com/project/jackwasey/nhds)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
<!-- badges: end -->

The National Hospital Discharge Survey (2010) summarizes the state of
patients at the end of their hospital admissions. The US CDC publishes
the data in the public domain, and describes it as follows: The National
Hospital Discharge Survey (NHDS) is a continuing nationwide sample
survey of short-stay hospitals in the United States. The scope of NHDS
encompasses patients discharged from noninstitutional hospitals,
exclusive of military and Department of Veterans Affairs hospitals,
located in the 50 States and the District of Columbia. Only hospitals
having six or more beds for in-patient use are included in the survey.
See <https://www.cdc.gov/nchs/nhds> for more information.

See documentation for the [R CRAN package:
icd](https://jackwasey.github.io/icd/) for how to use this data. See
also the [R CRAN package:
icd.data](https://cran.r-project.org/package=icd.data).

# Examples

``` r
nhds2010$hypertension <- icd::comorbid_ahrq(nhds2010)[, "HTN"]
nhds2010$charlson <- icd::charlson(nhds2010)
hist(nhds2010[nhds2010$age_unit == "years", "age"],
     main = "Histogram of age when specified in years", 
     xlab = "Age in years"
     )
```

<img src="man/figures/README-examples-1.png" width="100%" />

``` r
boxplot(age ~ hypertension, 
        data = nhds2010,
        outline = FALSE,
        ylab = "Age")
```

<img src="man/figures/README-examples-2.png" width="100%" />

``` r
boxplot(charlson ~ adm_type, 
        data = nhds2010,
        las = 2, 
        varwidth = TRUE, 
        outline = FALSE,
        ylab = "Charlson Score"
        )
```

<img src="man/figures/README-examples-3.png" width="100%" />

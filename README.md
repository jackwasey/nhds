
<!-- rmarkdown::render("README.Rmd") -->

# nhds

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/nhds)](https://cran.r-project.org/package=nhds)
[![Travis build
status](https://travis-ci.org/jackwasey/nhds.svg?branch=master)](https://travis-ci.org/jackwasey/nhds)
<!-- badges: end -->

ICD-9 and ICD-10 definitions from the United States Center for Medicare
and Medicaid Services (CMS) are included in this package. A function is
provided to extract the WHO ICD-10 definitions from the public
interface, but the data themselves may not currently be redistributed.
This function ‘fetch\_icd10\_who’ should be run once after installing
this package. There are diagnostic and procedure codes, and lists of the
chapter and sub-chapter headings and the ranges of ICD codes they
encompass. There are also two sets of sample patient data with ICD-9 and
ICD-10 codes representing real patients and spanning common structures
of patient data. These data are used by the ‘icd’ package for finding
comorbidities and working with ICD codes.

See documentation for the [R CRAN package:
icd](https://jackwasey.github.io/icd/) for how to use this data. See
also the [R CRAN package:
icd.data](https://cran.r-project.org/package=icd.data).

#' @title National Hospital Discharge Survey 2010 data
#' @description The United States National Hospital Discharge Survey (NHDS) 2010
#'   data is public domain data from the US [Center for Disease
#'   Control](https://www.cdc.gov). This is de-identified patient data with
#'   summary information about each patient at the end of a hospital admission,
#'   including demographic information, admission diagnoses, comorbidities and
#'   procedure codes, death or disposition. There are no identifiers in the
#'   data, so a simple count was included.
#' @name nhds2010
#' @source \url{https://www.cdc.gov/nchs/nhds/index.htm}
#' @docType data
#' @keywords datasets
#' @examples
#' if (require("icd", versionCheck(version = "3.4", op = ">="))) {
#' head(nhds2010)
#' colSums(icd::comorbid_ahrq(nhds2010))
#' nhds2010$hypertension <- icd::comorbid_ahrq(nhds2010)[, "HTN"]
#' nhds2010$charlson <- icd::charlson(nhds2010)
#' hist(nhds2010[nhds2010$age_unit == "years", "age"],
#'      main = "Histogram of age when specified in years",
#'      xlab = "Age in years"
#' )
#' boxplot(age ~ hypertension,
#'         data = nhds2010,
#'         outline = FALSE,
#'         ylab = "Age")
#' boxplot(charlson ~ adm_type,
#'         data = nhds2010,
#'         las = 2,
#'         varwidth = TRUE,
#'         outline = FALSE,
#'         ylab = "Charlson Score"
#' )
#' }
#' @concept Hospital
#' @concept Diagnostic codes
#' @concept ICD-9 codes
#' @concept Hospital discharge data
#' @concept Patient data
NULL

# As the data and package share a name, this is superfluous: "_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL

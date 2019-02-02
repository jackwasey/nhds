#' Return adult, pediatric or just neonatal elements from the NHDS data
#'
#' The age in the adult data is all specified in years, so the `age_unit` column
#' is dropped. The `age_unit` field is retained when returning pediatric data.
#'
#' @section Neonates and newborns:
#'
#'   For newborns, when the `newborn` field is `TRUE`, the `age` is always zero
#'   at time of admission, so `age` and `age_unit` are dropped. This must
#'   therefore refer to birth in hospital, not an admission of a neonate who is
#'   transferred. For the same reason, `adm_type` is dropped because it is
#'   always `newborn`.
#'
#'   In contrast, neonatal data includes both in-hospital births and admissions
#'   of patients with age 28 or fewer days. Strangely, `marital_status` is
#'   populated with a variety of values for the neonatal data, but all `newborn`
#'   babies are considered `single`, so that field is dropped by `nhds_newborn`.
#' @param nhds_data The NHDS data, default is `nhds2010`, which is the only year
#'   currently provided by this package.
#' @param rename_age Logical, if `TRUE`, the default, the `age` field is renamed
#'   to either `age_days` (for neonatal data) or `age_years` (for adult data).
#' @examples
#' head(nhds_adult())
#' # subset returned data directly
#' nhds_pediatric()[11:20, c("age_unit", "age")]
#' nhds_pediatric()[1:5, 1:7]
#' nhds_infant()[111:115, 1:7]
#' nhds_infant_not_neonate()[1:5, 1:7]
#' nhds_neonatal()[1:5, 1:7]
#' nhds_neonatal_not_newborn()[1:5, 1:7]
#' identical(nhds_neonatal()[1:10, ],
#'           nhds_neonate()[1:10, ])
#' identical(nhds_neonatal_not_newborn()[1:10, ],
#'           nhds_neonate_not_newborn()[1:10, ])
#' nhds_newborn()[1:5, 1:7]
#' @export
nhds_adult <- function(
  nhds_data = nhds::nhds2010,
  rename_age = TRUE
) {
  out <- nhds_data[nhds_data$age_unit == "years", ]
  out <- out[out$age >= 18, ]
  out[c("newborn", "age_unit")] <- NULL
  if (rename_age) names(out)[names(out) == "age"] <- "age_years"
  out
}

#' @rdname nhds_adult
#' @export
nhds_adults <- nhds_adult

#' @rdname nhds_adult
#' @export
nhds_pediatric <- function(
  nhds_data = nhds::nhds2010
) {
  out <- nhds_data[
    (nhds_data$age_unit == "years" & nhds_data$age < 18) |
      (nhds_data$age_unit != "years"),
    ]
  out
}

#' @rdname nhds_adult
#' @export
nhds_peds <- nhds_pediatric

#' @rdname nhds_adult
#' @export
nhds_neonatal <- function(
  nhds_data = nhds::nhds2010,
  rename_age = TRUE
) {
  out <- nhds_data[nhds_data$age_unit == "days", ]
  out <- out[out$age <= 28, ]
  out$age_unit <- NULL
  if (rename_age) names(out)[names(out) == "age"] <- "age_days"
  out
}

#' @rdname nhds_adult
#' @export
nhds_neonatal_not_newborn <- function(
  nhds_data = nhds::nhds2010,
  rename_age = TRUE
) {
  out <- nhds_data[nhds_data$age_unit == "days", ]
  out <- out[!out$newborn, ]
  out <- out[out$age <= 28, ]
  out[c("age_unit", "newborn")] <- NULL
  if (rename_age) names(out)[names(out) == "age"] <- "age_days"
  out
}

#' @rdname nhds_adult
#' @export
nhds_neonate_not_newborn <- nhds_neonatal_not_newborn

#' @rdname nhds_adult
#' @export
nhds_neonate <- nhds_neonatal

#' @rdname nhds_adult
#' @export
nhds_infant <- function(
  nhds_data = nhds::nhds2010,
  rename_age = TRUE
) {
  nhds_data[nhds_data$age_unit != "years", ]
}

#' @rdname nhds_adult
#' @export
nhds_infant_not_neonate <- function(
  nhds_data = nhds::nhds2010,
  rename_age = TRUE
) {
  out <- nhds_data[nhds_data$age_unit != "years", ]
  out <- out[!out$newborn, ]
  out$newborn <- NULL
  out[!(out$age_unit == "days" & out$age <= 28), ]
}

#' @rdname nhds_adult
#' @export
nhds_newborn <- function(
  nhds_data = nhds::nhds2010
) {
  out <- nhds_data[nhds_data$newborn, ]
  out[c("newborn", "age_unit", "age", "adm_type", "marital_status")] <- NULL
  out
}

#' @rdname nhds_adult
#' @export
nhds_newborns <- nhds_newborn

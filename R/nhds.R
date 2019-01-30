#' Parse the National Hospital Discharge Survey data
#'
#' The raw data files are large, so are not included in the git repository or
#' package. The raw data is 22M, and the R data is 3.3M when compressed. The
#' data can be downloaded from the referenced URL.
#' @references \url{https://www.cdc.gov/nchs/nhds/index.htm}
#' @param save logical, if \code{TRUE} saves data in the \code{data/} directory
#'   in the package source tree
#' @keywords internal
#' @noRd
parse_nhds2010 <- function(save = TRUE) {
  widths <- c(2, 1, 1, 2, 1, 1, 1, 2, 1, 4, 1, 1, 1, 1, 5, 2,
              # now ICD-9 diagnostic codes
              rep.int(5, 15),
              # now ICD-9 procedure codes
              rep.int(4, 8),
              2, 2, 3, 1, 2,
              # admitting diagnosis
              5
  )
  col_spec <- readr::cols(
    .default = readr::col_character(),
    X1 = readr::col_skip(), # year (always 10!)
    X2 = readr::col_integer(), #newborn logical
    X3 = readr::col_integer(), # age unit
    X4 = readr::col_integer(), # age
    X5 = readr::col_integer(), # gender
    X6 = readr::col_integer(), # race
    X7 = readr::col_integer(), # marital
    X8 = readr::col_integer(), # dc month
    X9 = readr::col_integer(), # dc status
    X10 = readr::col_integer(), # days of care
    X11 = readr::col_integer(), # dc same day
    X12 = readr::col_integer(), # region
    X13 = readr::col_integer(), # beds
    X14 = readr::col_integer(), # hospital ownership
    X15 = readr::col_number(), # "weighting"
    X16 = readr::col_skip(), # century
    # 15 diagnoses, 8 procedure codes
    X40 = readr::col_integer(), # payor
    X41 = readr::col_integer(), # payor2
    X42 = readr::col_character(), # DRG
    X43 = readr::col_integer(), # type of admission
    X44 = readr::col_integer(), # levels = origin_levels 99 fix
    X45 = readr::col_character() # admitting diagnosis
  )
  nhds2010 <- readr::read_fwf(
    file.path("data-raw", "NHDS10.PU.txt.bz2"),
    col_positions = readr::fwf_widths(widths),
    col_types = col_spec,
    progress = FALSE
  )
  names(nhds2010) <- c(
    # skipping "year", #int
    "newborn", # logical
    "age_unit", # factor years, months, days
    "age", # int
    "sex", # factor M, F
    "race",
    "marital_status",
    "dc_month", # integer discharge month
    "dc_status",
    "care_days", # int >=1 (same day d/c is defined as 1)
    "dc_same_day", # !!! 0 is same day, so need to invert the logic
    "region", # 1=Northeast 2=Midwest 3=South 4=West
    "n_beds", # 1=6-99 2=100-199 3=200-299 4=300-499 5=500 and over
    "hospital_ownership",
    "weighting", # ? data type
    # skip "century", # 20 for 2010 data
    sprintf("dx%02d", 1:15), # dx codes
    sprintf("pc%02d", 1:8), # pc codes
    "payor_primary",
    "payor_secondary", # same as above
    "DRG", # character string? Grouper version 27
    "adm_type",
    "adm_origin",
    "dx_adm" # another ICD-9-CM code
  )

  mkf <- function(ints, map) {
    stopifnot(is.integer(ints))
    f <- match(ints, map)
    attr(f, "levels") <- names(map)
    class(f) <- "factor"
    f
  }
  nhds2010$newborn <- nhds2010$newborn == 1L
  nhds2010$age_unit <- mkf(nhds2010$age_unit, c(
    "years" = 1,
    "months" = 2,
    "days" = 3))
  nhds2010$sex <- mkf(nhds2010$sex, c(
    "male" = 1,
    "female" = 2
  ))
  nhds2010$race <- mkf(nhds2010$race, c(
    "white" = 1,
    "black" = 2,
    "native_continental" = 3,
    "asian" = 4,
    "native_island" = 5,
    "other" = 6,
    "multiple" = 8,
    "not_stated" = 9))
  nhds2010$marital_status <- mkf(nhds2010$marital_status, c(
    "married" = 1,
    "single" = 2,
    "widowed" = 3,
    "divorced" = 4,
    "separated" = 5,
    "not_stated" = 9))
  nhds2010$dc_status <- mkf(nhds2010$dc_status, c(
    "home" = 1,
    "AMA" = 2,
    "short_term" = 3,
    "long_term" = 4,
    "alive_NOS" = 5,
    "dead" = 6,
    "not_stated" = 9))
  nhds2010$dc_same_day <- nhds2010$dc_same_day == 0
  nhds2010$region <- mkf(nhds2010$region, c(
    "northeast" = 1,
    "midwest" = 2,
    "south" = 3,
    "west" = 4
  ))
  nhds2010$n_beds <- ordered(mkf(nhds2010$n_beds, c(
    "6-99" = 1,
    "100-199" = 2,
    "200-299" = 3,
    "300-499" = 4,
    "500+" = 5
  )))
  nhds2010$hospital_ownership <- mkf(nhds2010$hospital_ownership, c(
    "proprietary" = 1,
    "government" = 2,
    "non_profit" = 3
  ))
  nhds2010$payor_primary <- mkf(nhds2010$payor_primary, c(
    "worker compensation" = 1,
    "Medicare" = 2,
    "Medicaid" = 3,
    "other government" = 4,
    "blue cross blue shield" = 5,
    "HMO or PPO" = 6,
    "other private insurance" = 7,
    "self pay" = 8,
    "no charge" = 9,
    "other" = 10,
    "not stated" = 99))
  nhds2010$payor_secondary <- mkf(nhds2010$payor_secondary, c(
    "worker compensation" = 1,
    "Medicare" = 2,
    "Medicaid" = 3,
    "other government" = 4,
    "blue cross blue shield" = 5,
    "HMO or PPO" = 6,
    "other private insurance" = 7,
    "self pay" = 8,
    "no charge" = 9,
    "other" = 10,
    "not stated" = 99))
  nhds2010$adm_type <- mkf(nhds2010$adm_type, c(
    "emergency" = 1,
    "urgent" = 2,
    "elective" = 3,
    "newborn" = 4,
    "trauma" = 5,
    "not_stated" = 9
  ))
  nhds2010$adm_origin <- mkf(nhds2010$adm_origin, c(
    "Non-health care POA" = 1,
    "Clinic" = 2,
    "Transfer from a hospital" = 3,
    "Transfer from intermediate care" = 4,
    "Transfer from other healthcare" = 5,
    "Emergency room" = 6,
    "Court or law enforcement" = 7,
    "Transfer from ambulatory surgery" = 8,
    "Transfer from hospice" = 9,
    "Newborn, born inside this hospital" = 10,
    "Newborn, born outside this hospital" = 11,
    "Other" = 12,
    "Not available" = 99
  ))
  nhds2010 <- as.data.frame(nhds2010)
  for (dx_col in c(15:37, 43)) {
    nhds2010[[dx_col]] <- sub(pattern = "-",
                              replacement = "",
                              x = nhds2010[[dx_col]])
  }
  # add a _character_ identifier. icd 3.4 can handle an integer directly
  nhds2010 <- cbind(
    id = as.character(seq_len(nrow(nhds2010))),
    nhds2010,
    stringsAsFactors = FALSE)
  for (col in grep("^dx", names(nhds2010), value = TRUE))
    nhds2010[[col]] <- icd::as.icd9cm(nhds2010[[col]])
  for (col in grep("pc..$", names(nhds2010), value = TRUE))
    # workaround until everyone has icd 3.4
    nhds2010[[col]] <- get_icd34fun()(nhds2010[[col]])
  # xz didn't compress as well as bzip2
  if (save)
    save(nhds2010,
         file = file.path("data", "nhds2010.rda"),
         compress = "bzip2", compression_level = 9)
  invisible(nhds2010)
}

get_icd34fun <- function() {
  if (exists("as.icd9cm_pc", where = asNamespace("icd"), mode = "function"))
    get("as.icd9cm_pc", envir = asNamespace("icd"), mode = "function")
  else
    function(x) x
}

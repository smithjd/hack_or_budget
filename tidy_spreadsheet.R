library(tidyverse)
library(googlesheets)
library(stringr)
# source("~/Rfunctions/setup_my_google.R")
# source("~/Rfunctions/make_dd.R")
source("https://raw.githubusercontent.com/smithjd/Rfunctions/master/setup_my_google.R")
source("https://raw.githubusercontent.com/smithjd/Rfunctions/master/make_dd.R")


ss <- gs_key("1oIFE14jm7nOf_hR3Sskz_fT_V4-jOAcYyndNCQSKQLI")
ss_list <- gs_ws_ls(ss)

df1 <- gs_read(ss, ws = 1)

names(df1) <- tolower(str_replace_all(names(df1),"[ -]", "_"))

df1_tidy <- gather(df1, fiscal_year, amount,
  -fund_center_code,
  -fund_code,
  -functional_area_code,-object_code,
  -fund_center_name,
  -fund_name,-functional_area_name,-accounting_object_name,
  -service_area_code,
  -program_code,-sub_program_code,
  -fund_center,
  -division_code,-bureau_code,
  -bureau_name
)

# this data frame has a lot of redundancy, so need to pare it down before uploading it anywhere.
dim(df1_tidy)

dd_df1_tidy <- make_dd(df1_tidy)
# all of these might not be needed for the working version

str(df1_tidy)

# newss <- upload_google_ss(df1_tidy, "Tidy version of Hack Oregon Export 3 (2)")
newss <- upload_google_ss(dd_df1_tidy, "Data Dictionary of Tidy version of Hack Oregon Export 3 (2)")

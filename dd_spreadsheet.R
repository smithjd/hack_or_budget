library(tidyverse)
library(googlesheets)
library(stringr)
library(purrr)
# source("~/Rfunctions/setup_my_google.R")
# source("~/Rfunctions/make_dd.R")
source("https://raw.githubusercontent.com/smithjd/Rfunctions/master/setup_my_google.R")
source("https://raw.githubusercontent.com/smithjd/Rfunctions/master/make_dd.R")


fix_names <- function(df) {
  tolower(str_replace_all(names(df),"[ -]", "_"))
}

ss <- gs_key("1oIFE14jm7nOf_hR3Sskz_fT_V4-jOAcYyndNCQSKQLI")
ss_list <- gs_ws_ls(ss)
ss_list <- tolower(str_replace_all(ss_list,"[ -)(]", "_"))
ss_list

# sheet # 8 is "instructions" so does not have data and makes the DD function fail.
ss_list <- ss_list[1:7]

get_dd <- function(table_list) {
  dd_pile <- vector("list", length(table_list))
  for (i in seq_along(table_list)) {
    df <- gs_read(ss, ws = i)
    names(df) <- fix_names(df)
    dd_df <- make_dd(df)
    dd_df$table_name <- table_list[[i]]
##
    dd_pile[[i]]  <- dd_df
    print(dim(dd_df))
    rm(df)
    Sys.sleep(20)
  }
  dd_pile
}

# little_table_list <- table_list %>% filter(TABLE_ROWS < 100)

my_dd_pile <- get_dd(ss_list)

big_dd <- bind_rows(my_dd_pile)

upload_google_ss(big_dd, paste("data dictionary for Hack Oregon hx budget data ASV2.xlsx - as of", today() ) )

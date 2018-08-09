library(hutils)
library(data.table)
library(readr)
library(magrittr)

SLA_JTW_2006_raw <-
  readr::read_lines("SLA-v-JTW-SLA-2006.csv")

shoulder <- 12L # by inspection
ankle <- max(grep("Dataset: 2006 Census", SLA_JTW_2006_raw, fixed = TRUE))

SLA_JTW_2006_raw %>%
  .[seq(from = shoulder, to = ankle - 1L)] %>%
  write_lines("SLA-v-JTW-SLA-2006-clean.csv")

SLA_JTW <- 
  fread("SLA-v-JTW-SLA-2006.csv", fill = TRUE, skip = 10, header = TRUE)

SLA_JTW_2006 <-
  fread("SLA-v-JTW-SLA-2006-clean.csv", header = FALSE) %>%
  setnames(1:3, c("SLA_Home", "SLA_Work", "workers")) %>%
  .[!nzchar(SLA_Home), SLA_Home := NA_character_] %>%
  .[, SLA_Home := zoo::na.locf(SLA_Home, na.rm = FALSE)] %>%
  drop_empty_cols %>%
  .[SLA_Home != "Total"] %>%
  setnames(1:2, c("O_SLA_NAME06", "D_SLA_NAME06")) %>%
  .[]

fwrite(SLA_JTW_2006, "../O_SLA_NAME06-D_SLA_NAME06-workers.csv")
# 
# SA2_JTW_2011 <-
#   fread("SA2-by-DJZ-2011/SA2-by-DJZ-2011.csv", header = FALSE, na.strings = c("")) %>%
#   setnames(1:3, c("Home_SA2", "Work_DZN", "Count")) %>%
#   drop_empty_cols %>%
#   .[, Home_SA2 := zoo::na.locf(Home_SA2, na.rm = FALSE)] %>%
#   .[Home_SA2 != "Total"] %>%
#   .[Count > 0]

# fwrite(SA2_JTW_2011, "../2011-Home_SA2-Work_DZN-Count.csv")

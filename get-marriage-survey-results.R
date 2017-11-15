
library(httr)
library(data.table)
library(readxl)

GET(url = "https://marriagesurvey.abs.gov.au/results/files/australian_marriage_law_postal_survey_2017_-_response_final.xls",
    write_disk("inbox/2017-results-survey.xls"))
read_excel("~/../Downloads/australian_marriage_law_postal_survey_2017_-_response_final.xls",
           sheet = "Table 2",
           skip = 5) %>%
  setDT %>% 
  .[, .(X__1, Yes, No)] %>%
  .[!is.na(Yes)] %>%
  .[!grepl("Total", X__1, fixed = TRUE)] %>%
  .[!is.na(X__1)] %>%
  melt.data.table(id.vars = "X__1", variable.name = "Response", value.name = "count") %>%
  setnames("X__1", "CED_2016") %>%
  .[order(CED_2016)] %>%
  fwrite("2017-marriage-survey-CED__Response_count.csv")
  
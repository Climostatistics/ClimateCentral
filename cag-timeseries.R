require(jsonlite)
require(tidyverse)
require(stringr)
stats=c("tavg","tmin","tmax","pcp","cdd","hdd","pdsi","phdi","pmdi","zndx")
#url="https://www.ncdc.noaa.gov/cag/statewide/time-series/27-tavg-1-11-1895-2019.json?base_prd=true&begbaseyear=1901&endbaseyear=2000"
#details=unlist(fromJSON(url)[1])
url="https://www.ncdc.noaa.gov/cag/city/time-series/USW00014745-tavg-3-2-1970-2019.csv?base_prd=true&begbaseyear=1940&endbaseyear=2000"
download.file(url,"concord.csv")
#raw=unlist(fromJSON(url)[2])

raw <- read_csv("concord.csv", col_types = cols(Date = col_character()),skip = 4, na="-99.0") %>%
  mutate(Year=as.numeric(stringr::str_sub(Date,1,4)))
saveRDS(raw,"concord.rds")
# nhdata=tibble(state="NH",
#               state_code=27,
#               month=11,
#               year=seq(1895,2019),
#               temps=as.numeric(raw[seq(1,249,2)]),
#               anomolies=as.numeric(raw[seq(2,250,2)])
# )
# nhdata$base=with(nhdata,temps-anomolies)
# print(mean(nhdata$temps[nhdata$year>1900 & nhdata$year <2001]))




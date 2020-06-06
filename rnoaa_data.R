# require(rnoaa)
require(tidyverse)
require(jsonlite)
require(glue)
require(lubridate)
# ncdc_stations(datasetid='GHCND',  stationid='GHCND:USW00014745')
# ncdc_datasets()
# dt<-ncdc_datatypes()$data
# with_units <- ncdc(datasetid='GHCND', stationid='GHCND:USW00014745', datatypeid='TMIN', startdate = '1973-12-01', enddate = '1974-03-31', limit=500, add_units = TRUE)
# with_units[2]$data$units

endpoint="www.ncei.noaa.gov/access/services/data/v1"
dataset="daily-summaries"
station="USW00014745"
t<-NULL
for (nyear in (1939:2019)){
  sDate=glue("{nyear}-01-01")
  #sDate=glue("{nyear}-12-01")
  #  eDate=glue("{nyear+1}-03-01")
  eDate=glue("{nyear}-12-31")
  url=glue("https://{endpoint}?dataset={dataset}&stations={station}&startDate={sDate}&endDate={eDate}&format=JSON")
  d<-fromJSON(url)
  d$wyear<-nyear
  t<-bind_rows(t,d)
}

c2f<-function(t){
  return(round(as.numeric(t)*0.18+32,2))
}

concord<-t %>% 
  filter(!is.na(TMIN)) %>%
  filter(!is.na(TMAX)) %>%
  mutate(fmin=c2f(TMIN),
         fmax=c2f(TMAX),
         frng=(fmax-fmin),
         favg=(fmax+fmin)/2,
         tdate=ymd(DATE),
         tyear=year(tdate),
         wintermonth=month(tdate))
saveRDS(concord,"fullconcordallyears.rds")

concord_winter_months<- concord %>%
  filter(wintermonth %in% c(12,1,2)) %>%
  mutate(winter=ifelse(wintermonth==12,wyear+1,wyear)) %>%
  group_by(winter,wintermonth) %>%
  summarise(mintemp=mean(fmin),
            maxtemp=mean(fmax),
            avgtemp=mean(favg),
            stdtemp=sd(favg),
            rngtemp=mean(frng),
            minmax=min(fmax),
            maxmin=max(fmin),
            maxmax=max(fmax),
            minmin=min(fmin),
            ndays=n())
saveRDS(concord_summary,"concord_summary.rds")

concord_summary<- concord %>%
  filter(tmonth %in% c(12,1,2)) %>%
  mutate(winter=ifelse(tmonth==12,wyear+1,wyear)) %>%
  group_by(winter) %>%
  summarise(mintemp=mean(fmin),
            maxtemp=mean(fmax),
            avgtemp=mean(favg),
            stdtemp=sd(favg),
            rngtemp=mean(frng),
            minmax=min(fmax),
            maxmin=max(fmin),
            maxmax=max(fmax),
            minmin=min(fmin),
            ndays=n())
saveRDS(concord_summary,"concord_summary.rds")





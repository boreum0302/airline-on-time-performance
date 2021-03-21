## Prerequisite ----
library(readr)
library(dplyr)
library(RSQLite)

## Connect ----
con = dbConnect(SQLite(), "project.sqlite")

## Question 2 ----
dbWriteTable(con, "airlines",
             read_csv("./data/airlines.csv",
                      locale = locale(encoding = "UTF-8"), skip = 1))
dbWriteTable(con, "airports",
             read_csv("./data/airports.csv",
                      locale = locale(encoding = "UTF-8"),
                      col_names = c("Airport ID", "Name", "City", "Country", "IATA",
                                    "ICAO", "Latitude", "Longitude", "Altitude", "Timezone",
                                    "DST", "Tz database time zone", "Type", "Source")))
dbWriteTable(con, "airplanes",
             read_csv("./data/airplanes.csv",
                      locale = locale(encoding = "UTF-8")))

## Question 3 ----
for(year in 2001:2018){
  for(month in 1:12){
    filename = paste("./data/", year, sprintf("%02d", month), ".zip", sep = "")
    filedata = read_csv(filename, locale = locale(encoding = "UTF-8"))
    dbWriteTable(con, "flights", filedata, append = TRUE)
  }
}

## Question 4 ----
dbSendQuery(con, "CREATE INDEX date ON flights (Year, Month, Day_of_Month)")

## Disconnect ----
dbDisconnect(con)
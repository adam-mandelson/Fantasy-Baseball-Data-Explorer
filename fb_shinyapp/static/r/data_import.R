###########################################################
#
# Script: data_import.R
# Date: 2021-12-30 17:23:51
#
#
# Purpose:
#  - load data
#
###########################################################


# Connect to PostgreSQL database
library(DBI)
library(ini)
library(jsonlite)

# Read .ini info
read_ini <- read.ini('config/config.ini')
  
con <- dbConnect(
  RPostgres::Postgres(),
  host = read_ini$postgresql$host,
  port = read_ini$postgresql$port,
  dbname = read_ini$postgresql$database,
  user = read_ini$postgresql$user,
  password = read_ini$postgresql$password
)

res <- dbSendQuery(con, "SELECT * FROM yearly_stats")
league_data <- dbFetch(res)
dbClearResult(res)
dbDisconnect(con)


# Import full team names
league_stats <- fromJSON('config/league_stats.json', flatten=TRUE)
teams <- data.frame(
  'id' = as.integer(names(league_stats$league_teams)),
  'team_name' = unlist(league_stats$league_teams, use.names=FALSE))

# Import league categories
categories <- data.frame(
  'id' = names(league_stats$renamed_categories),
  "categories" = unlist(league_stats$renamed_categories, use.names=FALSE))

# Add team names to data file
league_data <- league_data %>%
  left_join(teams, by = c("team_id" = "id")) %>%
  left_join(categories, by = c("category" = "id")) %>%
  mutate(season = as.integer(season),
         won_category = as.logical(as.integer(won_category)),
         won_week = as.logical(won_week))

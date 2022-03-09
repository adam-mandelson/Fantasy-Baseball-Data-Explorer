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


# Connect to Postgres database
library(DBI)
library(ini)
library(jsonlite)

# Read .ini info
read_ini <- read.ini('./config/config.ini')

con <- dbConnect(RPostgres::Postgres(),
                 dbname = read_ini$postgresql$database,
                 host = read_ini$postgresql$host,
                 user = read_ini$postgresql$user,
                 password = read_ini$postgresql$password)

res <- dbSendQuery(con, "SELECT * FROM yearly_stats")
data <- dbFetch(res)
dbClearResult(res)
dbDisconnect(con)


# Import full team names
league_stats <- fromJSON('./config/league_stats.json', flatten=TRUE)
teams <- as.data.frame(league_stats['league_teams']) %>%
  mutate(id = as.integer(league_teams.id)) %>%
  rename(team_name = league_teams.team_name) %>%
  select(-league_teams.id)


# Import league categories
# categories <- data.frame("id" = categories$id, "categories" = categories$categories)
categories <- unlist(league_stats$league_categories)
categories <- data.frame('id' = names(categories), 'categories' = unlist(league_stats['league_categories'], use.names = FALSE))


# Add team names to data file
data <- data %>%
  left_join(teams, by = c("team_id" = "id")) %>%
  # left_join(categories, by = c("category" = "id")) %>%
  mutate(season = as.integer(season),
         won_category = as.logical(as.integer(won_category)),
         won_week = as.logical(won_week))

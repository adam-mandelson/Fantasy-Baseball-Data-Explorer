###########################################################
#
# Script: data_utils.R
# Date: 2022-01-01 14:08:35
#
# Purpose:
#  - loads functions for data
#
###########################################################

# DATA HELPER FUNCTIONS ---------------------------------------------------------------
# Plot data - filters by season and team name, returns full data frame
df.full <- function(figure_data, figure_category=NULL, figure_team_name = "All", figure_seasons=NULL) {
  if (length(figure_seasons) > 1) {
    figure_seasons <- seq(figure_seasons[1], figure_seasons[2], 1)
  }
  if ("All" %in% figure_team_name) {
    teams_filter <- unique(figure_data$team_name)
  } else {
    teams_filter <- figure_team_name
  }
  if (is.null(figure_seasons)) {
    figure_seasons <- unique(figure_data$season)
  }
  if (is.null(figure_category)) {
    df <- figure_data %>%
      filter(season %in% figure_seasons,
             team_name %in% teams_filter)
  } else {
    df <- figure_data %>%
      filter(categories == figure_category,
             season %in% figure_seasons,
             team_name %in% teams_filter)
  }
  return(df)
}


# Scatter data - Pivots into three columns - Team_1, Team_2, won_week
df.wider <- function(df, scatter=TRUE) {
  df_wider <- df %>%
    select(matchup, matchup_id, value, won_week) %>%
    mutate(matchup_id = if_else(matchup_id == "H", "Team_1", "Team_2"),
           won_week = if_else(won_week == TRUE, matchup_id, "NA"),
           won_week = na_if(won_week, "NA"))
  
  if (scatter==TRUE) {
    # Find winning team
    winning_teams <- df_wider %>% 
      drop_na() %>%
      select(matchup, won_week)
    
    # Pivot data 
    df_pivot <- df_wider %>%
      pivot_wider(id_cols = matchup,
                  names_from = matchup_id, 
                  values_from = value) %>%
      left_join(winning_teams, by = "matchup") %>%
      mutate(won_week = if_else(Team_1 == Team_2, "Tie", won_week))
    return(df_pivot)
  }
  else if (scatter==FALSE) {
    # Change scatter data won_week
    df_strip_plot <- df_wider %>%
      mutate(won_week = if_else(is.na(won_week), "Lost", "Won"))
    return(df_strip_plot)
  }
}


# valueBox data - Pivots and returns full season data by team
df.valueBox <- function(df, team_box=FALSE) {
  df_value_box <- df %>%
    select(team_name, season, category, value)
  df_counts <- df_value_box %>%
    pivot_wider(names_from=category,
                values_from=value,
                values_fn={sum}) %>%
    select(!ends_with('r', ignore.case = FALSE))
  df_rates <- df_value_box %>%
    pivot_wider(names_from=category,
                values_from=value,
                values_fn={mean}) %>%
    select(ends_with('r', ignore.case = FALSE))
  df_value_box <- cbind(df_counts, df_rates)
  if (team_box==TRUE) {
    df_value_box <- df_value_box
  } else if (team_box==FALSE) {
    season <- df_value_box$season[1]
    means <- data.frame(season=c(season), team_name=c("++LEAGUE AVERAGE++"))
    means <- cbind(
      means,
      t(do.call(rbind, lapply(colMeans(df_value_box[3:21]), data.frame)))
    )
    df_value_box <- rbind(df_value_box, means)
  }
}

df.get_rank <- function(df, teamname, selected_category) {
  if (selected_category %in% c("b_K", "p_L", "p_BB", "p_ERAr", "p_WHIPr")) {
    df <- df %>%
      mutate(cat_rank = rank(df[[selected_category]]))
  } else {
    df <- df %>%
      mutate(cat_rank = rank(-df[[selected_category]]))
  }
  rank <- df %>%
    filter(team_name == teamname) %>%
    select(cat_rank)
  return(round(rank$cat_rank, 0))
}
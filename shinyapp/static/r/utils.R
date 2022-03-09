###########################################################
#
# Script: shiny_utils.R
# Date: 2022-01-01 14:08:35
#
# Purpose:
#  - loads functions for page design and plots
#
###########################################################



# FLUID DESIGN FUNCTION ---------------------------------------------------------------
# Design pages with four boxes

fluid_design <- function(id, w, x, y, z) {
  fluidRow(
    div(
      id = id,
      column(
        width = 6,
        uiOutput(w),
        uiOutput(y)
      ),
      column(
        width = 6,
        uiOutput(x),
        uiOutput(z)
      )
    )
  )
}


# DATA HELPER FUNCTIONS ---------------------------------------------------------------
# Plot data - filters by season and team name, returns full data frame
df.full_plot <- function(figure_data, figure_category, figure_team_name = "All", figure_seasons) {
  if (length(figure_seasons) > 1) {
    figure_seasons <- seq(figure_seasons[1], figure_seasons[2], 1)
  }
  if ("All" %in% figure_team_name) {
    teams_filter <- unique(figure_data$team_name)
  } else {
    teams_filter <- figure_team_name
  }
  df <- figure_data %>%
    filter(categories == figure_category,
           season %in% figure_seasons,
           team_name %in% teams_filter)
  return(df)
}


# Scatter data - Pivots into three columns - Team_1, Team_2, won_week
df.wider <- function(df) {
  df_wider <- df %>%
    select(matchup, matchup_id, value, won_week) %>%
    mutate(matchup_id = if_else(matchup_id == "H", "Team_1", "Team_2"),
           won_week = if_else(won_week == TRUE, matchup_id, "NA"),
           won_week = na_if(won_week, "NA"))
  
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


df.strip_plot <- function(df) {
  df_strip_plot <- df %>%
    select(matchup, matchup_id, value, won_week) %>%
    mutate(matchup_id = if_else(matchup_id == "H", "Team_1", "Team_2"),
           won_week = if_else(won_week == TRUE, matchup_id, "NA"),
           won_week = na_if(won_week, "NA"))
  
  # Change scatter data won_week
  df_strip_plot <- df_strip_plot %>%
    mutate(won_week = if_else(is.na(won_week), "Lost", "Won"))
  
  return(df_strip_plot)
}



# FIGURE HELPER FUNCTIONS ---------------------------------------------------------------
fig.density <- function(df) {

  cdat <- ddply(df, "won_week", plyr::summarise, value.mean=round(mean(value), 3), value.median=round(median(value), 3))

  x_y <- density(df$value)
  x_q <- quantile(x_y$x)
  y_q <- quantile(x_y$y)
  
  fig_density <- ggplot(df, aes(x=value, color=won_week)) +
    geom_density() +
    geom_vline(data = cdat, aes(xintercept=value.mean, color=won_week),
               linetype="dashed", size=1)
  fig_density <- fig_density +
    # annotate("text", x = max(x_y$x), y = max(x_y$y),
    #          label = paste0("Median for won_week: ", cdat$value.median[1]),
    #          hjust = 1, vjust=0.5, size=4, fontface="italic")
    annotate("text", x = max(x_y$x), y = y_q[5],
             label = paste0("Mean for won_week: ", cdat$value.mean[1]),
             hjust = 1, vjust=0.5, size=4, fontface="italic")
  return(fig_density)
}
  
fig.scatter <- function(df) {
  
  df <- df.wider(df)
    
  fig_scatter <- ggplot(df,
                      aes(x = Team_1,
                          y = Team_2,
                          color = won_week)) +
    geom_point()
  
  return(fig_scatter)
}

fig.strip_plot <- function(df) {
  
  df <- df.strip_plot(df)
    
  fig_strip_plot <- ggplot(df,
                      aes(x = value,
                          y = won_week,
                          color = won_week)) +
    geom_jitter(position = position_jitter(0.1))

  return(fig_strip_plot)
}

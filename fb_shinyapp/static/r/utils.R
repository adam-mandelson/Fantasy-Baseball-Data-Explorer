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

# VISUAL BOX FUNCTION ---------------------------------------------------------------
categories_list <- list()
for (category in categories$categories[-1]) {
  categories_list <- append(categories_list, paste0(str_to_lower(str_replace_all(category, ' ', '_')), '_box'))
}

visual_box_design <- function(id,
                              stat02, stat03, stat04, stat05,
                              stat06, stat07, stat08, stat09,
                              stat10, stat11, stat12, stat13,
                              stat14, stat15, stat16, stat17,
                              stat18, stat19) {
  box_width <- 3
  fluidRow(
    div(
      id=stat02,
      valueBoxOutput(stat02, width=box_width)
    ),
    div(
      id=stat03,
      valueBoxOutput(stat03, width=box_width)
    ),
    div(
      id=stat04,
      valueBoxOutput(stat04, width=box_width)
    ),
    div(
      id=stat05,
      valueBoxOutput(stat05, width=box_width)
    ),
    div(
      id=stat06,
      valueBoxOutput(stat06, width=box_width)
    ),
    div(
      id=stat07,
      valueBoxOutput(stat07, width=box_width)
    ),
    div(
      id=stat08,
      valueBoxOutput(stat08, width=box_width)
    ),
    div(
      id=stat09,
      valueBoxOutput(stat09, width=box_width)
    ),
    div(
      id=stat10,
      valueBoxOutput(stat10, width=box_width)
    ),
    div(
      id=stat11,
      valueBoxOutput(stat11, width=box_width)
    ),
    div(
      id=stat12,
      valueBoxOutput(stat12, width=box_width)
    ),
    div(
      id=stat13,
      valueBoxOutput(stat13, width=box_width)
    ),
    div(
      id=stat14,
      valueBoxOutput(stat14, width=box_width)
    ),
    div(
      id=stat15,
      valueBoxOutput(stat15, width=box_width)
    ),
    div(
      id=stat16,
      valueBoxOutput(stat16, width=box_width)
    ),
    div(
      id=stat17,
      valueBoxOutput(stat17, width=box_width)
    ),
    div(
      id=stat18,
      valueBoxOutput(stat18, width=box_width)
    ),
    div(
      id=stat19,
      valueBoxOutput(stat19, width=box_width)
    )
  )
}

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

# VALUEBOX DATA ---------------------------------------------------------------
df.value_box <- function(df) {
  df_value_box <- df %>%
    select(season, category, value)
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
  
  return(cbind(df_counts, df_rates))
}

df.value_box_league <- function(df) {
  df_value_box <- df %>%
    select(season, category, value, team_name)
  df_counts <- df_value_box %>%
    pivot_wider(names_from=category,
                values_from=value,
                values_fn={sum})
}

vbox_helper <- function(category, data) {
  valueBox(
    value=round(data[[category]], 3),
    subtitle = categories[categories$id==category, 'categories'],
    href=NULL
    # icon='',
    # color='' # TODO: color dependent on ranking
    # TODO: add league avg
    # TODO: add avg to win
  )
}

# FIGURE HELPER FUNCTIONS ---------------------------------------------------------------
fig.team_categories <- function(df, selected_category, highlighted_team) {
  category <- categories[categories$id==selected_category, 'id']
  df <- df %>%
    mutate(to_highlight = if_else(team_name==highlighted_team, "yes", "no"))
  ggplot(
    data=df,
    aes(x=reorder(team_name,-.data[[category]]),
        y=.data[[category]],
        fill=to_highlight)) +
    geom_bar(stat='identity') +
    scale_fill_manual(values=c("yes" = "tomato", "no" = "gray"), guide="none") +
    labs(x = "Team Name",
         y=categories[categories$id==selected_category, 'categories'],
         subtitle=df$season[1]) +
    theme(axis.text.x = element_text(angle=45, hjust=1))
}

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

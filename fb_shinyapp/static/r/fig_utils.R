###########################################################
#
# Script: data_utils.R
# Date: 2022-01-01 14:08:35
#
# Purpose:
#  - loads functions for data
#
###########################################################


# FIGURE HELPER FUNCTIONS ---------------------------------------------------------------
fig.team_categories <- function(df, selected_category, highlighted_team) {
  category <- categories[categories$id==selected_category, 'id']
  df <- df %>%
    mutate(to_highlight = if_else(team_name %in% c(highlighted_team, "++LEAGUE AVERAGE++"), "yes", "no"))
  ggplot(
    data=df,
    aes(x=reorder(team_name,-.data[[selected_category]]),
        y=.data[[selected_category]],
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
             label = paste0("Mean for won_week: ", cdat$value.mean[2]),
             hjust = 1, vjust=0.5, size=4, fontface="italic")
  return(fig_density)
}
  
fig.scatter <- function(df) {
  
  df <- df.wider(df, scatter=TRUE)
    
  fig_scatter <- ggplot(df,
                      aes(x = Team_1,
                          y = Team_2,
                          color = won_week)) +
    geom_point()
  
  return(fig_scatter)
}

fig.strip_plot <- function(df) {
  
  df <- df.wider(df, scatter=FALSE)
    
  fig_strip_plot <- ggplot(df,
                      aes(x = value,
                          y = won_week,
                          color = won_week)) +
    geom_jitter(position = position_jitter(0.1))

  return(fig_strip_plot)
}

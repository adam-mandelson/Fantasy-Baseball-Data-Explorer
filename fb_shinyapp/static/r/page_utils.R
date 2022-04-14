###########################################################
#
# Script: page_utils.R
# Date: 2022-01-01 14:08:35
#
# Purpose:
#  - loads functions for page design
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

# VALUEBOX PAGE DESIGN FUNCTION ---------------------------------------------------------------
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

# VALUEBOX DESIGN FUNCTION ---------------------------------------------------------------
valueBox2 <- function(value, title, subtitle = NULL, icon = NULL, color = "aqua", width = 4, href = NULL){
  
  shinydashboard:::validateColor(color)
  
  if (!is.null(icon))
    shinydashboard:::tagAssert(icon, type = "i")
  
  boxContent <- div(
    class = paste0("small-box bg-", color),
    div(
      class = "inner",
      tags$small(title),
      h3(value),
      p(subtitle)
    ),
    if (!is.null(icon)) div(class = "icon-large", icon)
  )
  
  if (!is.null(href)) 
    boxContent <- a(href = href, boxContent)
  
  div(
    class = if (!is.null(width)) paste0("col-sm-", width), 
    boxContent
  )
}

vbox_helper <- function(category, data, rank = NULL) {

  valueBox2(
    value=round(data[[category]], 3),
    title = toupper(categories[categories$id==category, 'categories']),
    if(!is.null(rank)) subtitle=paste0("League Rank: ", rank),
    icon = icon("baseball-ball"),
    href=NULL
    # icon='',
    # color='' # TODO: color dependent on ranking
    # TODO: add league avg
    # TODO: add avg to win
  )
}

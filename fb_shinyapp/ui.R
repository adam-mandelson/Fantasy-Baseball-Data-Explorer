###########################################################
#
# Script: ui.R
# Date: 2022-01-01 16:02:07
#
#
# Purpose:
#  - shiny UI
#
###########################################################


# SOURCE LIBARIES, FUNCTIONS ---------------------------------------------------------------
source('global.R')

# SHINY UI ---------------------------------------------------------------
shinyUI(fluidPage(
  
  useShinyjs(),
  
  # load custom stylesheet
  includeCSS("static/css/style.css"),
  dashboardPage(
    skin = "red",
    
    dashboardHeader(title = "Fantasy Baseball Data Explorer", titleWidth = 250),
    
    # DASHBOARD SIDEBAR ---------------------------------------------------------------
    dashboardSidebar(
      width = 250,

      # SIDEBAR MENU ---------------------------------------------------------------
      sidebarMenu(
        menuItem(
          "Main Page",
          tabName = "main_page",
          icon = icon("home")
        ),
        menuItem(
          text = "Team Stats",
          tabName = "team_stats",
          icon = icon("chart-line"),
          
          menuItem(
            text='Team Stats by Year',
            tabName='team_stats_year',
            icon=icon('chart-bar')
          ),
          
          menuItem(
            text='Head-to-Head',
            tabName='head_to_head',
            icon=icon('users')
          )
        ),
        menuItem(
          text='Offline Data Exploration',
          tabName='data_reports',
          icon=icon('python'),
          
          menuItem(
            text='Bayesian modeling',
            tabName='bayes_modeling',
            icon=icon('file-code')
          ),
          
          menuItem(
            text='SVM modeling',
            tabName='svm_modeling',
            icon=icon('file-code')
          )
          
        ),
        menuItem(
          text = "Releases",
          tabName = "releases",
          icon = icon("tasks")
        )
      )
    ),
    
    # DASHBOARD BODY ---------------------------------------------------------------
    dashboardBody(
      tabItems(
        
        # MAIN PAGE ---------------------------------------------------------------
        tabItem(
          tabName = "main_page",
          fluid_design("main_page_panel", "box01", "box02", "box03", "box04")
        ),
        
        # TEAM_STATS_BY_YEAR PAGE ---------------------------------------------------------------
        tabItem(
          tabName = 'team_stats_year',
          div(
            id='team_stats_year',
            column(
              width=4,
              tags$h3(
                'Stats by Team by Year',
                style='text-align: left'
              ),
              tags$h5(
                'Click to compare'
              )
            ),
            column(
              width=3,
              tags$h5(
                'Select a Team:',
                style='font-weight: bold;'
              ),
              selectizeInput(
                inputId='team_stats.team',
                label=NULL,
                choices=c(sort(teams$team_name)),
                selected='The ProvSox',
                multiple=FALSE,
              )
            ),
            column(
              width=3,
              tags$h5(
                'Select a Season:',
                style='font-weight: bold;'
              ),
              selectizeInput(
                inputId='team_stats.season',
                label=NULL,
                choices=c(unique(league_data$season)),
                selected=2021,
                multiple=FALSE
              )
            )
          ),
          div(
            id='team_stats_year_data',
            renderPrint({
              output$team_stats_season_marker
            }),
            conditionalPanel(
              condition='output.team_stats_season_marker!=null',
              visual_box_design('team_boxes',
                                'r_box', 'hr_box', 'rbi_box', 'bbb_box',
                                'kb_box', 'avg_box', 'obp_box', 'slg_box',
                                'nsb_box', 'ip_box', 'w_box', 'l_box',
                                'bbp_box', 'kp_box', 'era_box', 'whip_box',
                                'qs_box', 'nsvh_box')
            )
          ),
        ),
                  
        # HEAD-TO-HEAD PAGE ---------------------------------------------------------------        
        tabItem(
          tabName = "head_to_head",
          div(
            id = "head_to_head",
            column(
              width = 12,
              tags$h3(
                'Head-to-Head Plots',
                style = 'text-align: left;'
              )
            ),
            fluidRow(
              column(
                width = 2,
                div(
                  id = "head_to_head_inputs",
                  style = "text-align: left",
                  tags$h5(
                    "Select Team Stats by Category",
                  ),
                  selectizeInput(
                    inputId = "head_to_head.category",
                    label = "Select a Category",
                    choices = c(Choose = NULL,
                                categories$categories),
                    multiple = FALSE,
                    options = list(
                      placeholder = 'Choose a category',
                      onInitialize = I('function() { this.setValue(""); }')
                    )
                  ),
                  selectizeInput(
                    inputId = "head_to_head.team_name",
                    label = "Select Team Name(s)",
                    choices = c("All",
                                sort(unique(league_data$team_name))),
                    selected = "All",
                    multiple = TRUE,
                  ),
                  sliderInput(
                    inputId = "head_to_head.seasons",
                    label = "Select season(s)",
                    min = min(league_data$season),
                    max = max(league_data$season),
                    value = c(2014, 2021),
                    step = 1,
                    sep = ""
                  ),
                  radioGroupButtons(
                    inputId = "head_to_head.plot_type",
                    label = "Choose a plot type:",
                    choices = c('Density', 'Scatter', 'StripPlot')
                  )
                  # TODO: Text here with stats? OR in box09?
                )
              ),
              box(
                id = "head_to_head_box",
                width = 9,
                uiOutput("head_to_head.fig")
              )
            )
          )
        ),
        
        # OFFLINE_DATA PAGE ---------------------------------------------------------------
        tabItem(
          tabName='bayes_modeling',
          tags$p(
            'More data available in ./shinyapps/static/www/bayes_pdf_report.pdf'
          ),
          includeHTML('static/www/bayes_exploration_2.html')
        ),
        
        tabItem(
          tabName='svm_modeling',
          includeHTML('static/www/svm_exploration.html')
        ),
        
        # RELEASES PAGE ---------------------------------------------------------------
        tabItem(
          tabName = "releases",
          includeMarkdown("static/www/releases.md")
        )
      )
    )
  )
))
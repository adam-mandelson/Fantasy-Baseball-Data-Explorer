###########################################################
#
# Script: server.R
# Wed Mar 09 14:32:16 2022
#
# Purpose:
#  - shiny server script
#
###########################################################

# SHINY OPTIONS ---------------------------------------------------------------

# SHINY SERVER ---------------------------------------------------------------
function(input, output, session) {
  # MAIN PAGE  - BOX01 ---------------------------------------------------------------
  output$box01 <- renderUI({
    div(
      style = "position: relative",
      box(
        id = "box01",
        width = NULL,
        height = 400,
        includeMarkdown("static/www/home.md")
      )
    )
  })
  
  # team_stats_year ---------------------------------------------------------------
  output$team_stats_season_marker <- reactive({
    input$team_stats.season
  })
  
  outputOptions(output, 'team_stats_season_marker', suspendWhenHidden=FALSE)
  
  output$r_box <- renderValueBox({
    box_category <- 'b_R'
    vbox_helper(category=box_category,
                data=team_stats.data())
  })
  
  output$hr_box <- renderValueBox({
    box_category <- 'b_HR'
    vbox_helper(category=box_category,
                data=team_stats.data())
  })
  
  output$rbi_box <- renderValueBox({
    box_category <- 'b_RBI'
    vbox_helper(category=box_category,
                data=team_stats.data())
  })
  
  output$bbb_box <- renderValueBox({
    box_category <- 'b_BB'
    vbox_helper(category=box_category,
                data=team_stats.data())
  })
  
  output$kb_box <- renderValueBox({
    box_category <- 'b_K'
    vbox_helper(category=box_category,
                data=team_stats.data())
  })
  
  output$avg_box <- renderValueBox({
    box_category <- 'b_AVGr'
    vbox_helper(category=box_category,
                data=team_stats.data())
  })
  
  output$obp_box <- renderValueBox({
    box_category <- 'b_OBPr'
    vbox_helper(category=box_category,
                data=team_stats.data())
  })
  
  output$slg_box <- renderValueBox({
    box_category <- 'b_SLGr'
    vbox_helper(category=box_category,
                data=team_stats.data())
  })
  
  output$nsb_box <- renderValueBox({
    box_category <- 'b_NSB'
    vbox_helper(category=box_category,
                data=team_stats.data())
  })
  
  output$ip_box <- renderValueBox({
    box_category <- 'p_IP'
    vbox_helper(category=box_category,
                data=team_stats.data())
  })
  
  output$w_box <- renderValueBox({
    box_category <- 'p_W'
    vbox_helper(category=box_category,
                data=team_stats.data())
  })
  
  output$l_box <- renderValueBox({
    box_category <- 'p_L'
    vbox_helper(category=box_category,
                data=team_stats.data())
  })
  
  output$bbp_box <- renderValueBox({
    box_category <- 'p_BB'
    vbox_helper(category=box_category,
                data=team_stats.data())
  })
  
  output$kp_box <- renderValueBox({
    box_category <- 'p_K'
    vbox_helper(category=box_category,
                data=team_stats.data())
  })
  
  output$era_box <- renderValueBox({
    box_category <- 'p_ERAr'
    vbox_helper(category=box_category,
                data=team_stats.data())
  })
  
  output$whip_box <- renderValueBox({
    box_category <- 'p_WHIPr'
    vbox_helper(category=box_category,
                data=team_stats.data())
  })
  
  output$qs_box <- renderValueBox({
    box_category <- 'p_QS'
    vbox_helper(category=box_category,
                data=team_stats.data())
  })
  
  output$nsvh_box <- renderValueBox({
    box_category <- 'p_NSVH'
    vbox_helper(category=box_category,
                data=team_stats.data())
  })
  
  
  output$box05.plot <- renderPlot({
    fig.team_categories(
      df=team_stats.data(),
      selected_category=input$box05.input
    )
  })
  
  output$box05 <- renderUI({
    div(
      style="position: relative",
      box(
        id='box05',
        width=NULL,
        height='400px',
        selectizeInput(
          inputId='box05.input',
          label=NULL,
          choices=c(categories$categories),
          selected='Runs',
          multiple=FALSE
        ),
        plotOutput('box05.plot', height='330px')
      )
    )
  })
  
  output$box06.plot <- renderPlot({
    fig.team_categories(
      df=team_stats.data(),
      selected_category=input$box06.input
    )
  })
  
  output$box06 <- renderUI({
    div(
      style="position: relative",
      box(
        id='box06',
        width=NULL,
        height='400px',
        selectizeInput(
          inputId='box06.input',
          label=NULL,
          choices=c(categories$categories),
          selected='On Base Percentage',
          multiple=FALSE
        ),
        plotOutput('box06.plot', height='330px')
      )
    )
  })
  
  output$box07.plot <- renderPlot({
    fig.team_categories(
      df=team_stats.data(),
      selected_category=input$box07.input
    )
  })
  
  output$box07 <- renderUI({
    div(
      style="position: relative",
      box(
        id='box07',
        width=NULL,
        height='400px',
        selectizeInput(
          inputId='box07.input',
          label=NULL,
          choices=c(categories$categories),
          selected='Walks Hits Per Innings Pitched',
          multiple=FALSE
        ),
        plotOutput('box07.plot', height='330px')
      )
    )
  })
  
  output$box08.plot <- renderPlot({
    fig.team_categories(
      df=team_stats.data(),
      selected_category=input$box08.input
    )
  })
  
  output$box08 <- renderUI({
    div(
      style="position: relative",
      box(
        id='box08',
        width=NULL,
        height='400px',
        selectizeInput(
          inputId='box08.input',
          label=NULL,
          choices=c(categories$categories),
          selected='Quality Starts',
          multiple=FALSE
        ),
        plotOutput('box08.plot', height='330px')
      )
    )
  })
  
  team_stats.data <- reactive({
    filtered_data <- df.full(
      figure_data=league_data,
      figure_team_name=input$team_stats.team,
      figure_seasons=input$team_stats.season
    )
    df.value_box(filtered_data)
  })

  # head_to_head -----------------------------------------------------
  output$head_to_head.plot <- renderPlot({
    shiny::validate(
      need(input$head_to_head.category, message = "Please choose a category to plot.")
    )
    
    head_to_head.data <- df.full(
      figure_data = league_data,
      figure_category = input$head_to_head.category,
      figure_team_name = input$head_to_head.team_name,
      figure_seasons = input$head_to_head.seasons
    )

    if (input$head_to_head.plot_type == "Density") {
      fig.density(df = head_to_head.data)
    } else if (input$head_to_head.plot_type == "Scatter") {
      fig.scatter(df = head_to_head.data)
    } else if (input$head_to_head.plot_type == "StripPlot") {
      fig.strip_plot(df = head_to_head.data)
    }
    
  })
  
  output$head_to_head.fig <- renderUI(plotOutput("head_to_head.plot", width = "100%"))

}
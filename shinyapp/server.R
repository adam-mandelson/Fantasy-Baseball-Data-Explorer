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
        tags$h4(
          "box01"
        ),
        includeMarkdown("static/www/home.md")
      )
    )
  })
  
  # team_stats_year ---------------------------------------------------------------
  output$box05 <- renderUI({
    div(
      style="position: relative",
      box(
        id='box05',
        width=NULL,
        height=250,
        selectizeInput(
          inputId='box05.input',
          label=NULL,
          choices=c(categories$categories),
          selected='Runs',
          multiple=FALSE
        ),
        plotOutput("box05.plot", height='200px')
      )
    )
  })
  
  output$box05.plot <- renderPlot({
    fig.team_categories(df=team_stats_year.data(),
                        selected_category=input$box05.input)
  })
  
  output$box06 <- renderUI({
    div(
      style="position: relative",
      box(
        id='box06',
        width=NULL,
        height=250,
        selectizeInput(
          inputId='box06.input',
          label=NULL,
          choices=c(categories$categories),
          selected='OBP',
          multiple=FALSE
        )
      )
    )
  })
  
  output$box07 <- renderUI({
    div(
      style="position: relative",
      box(
        id='box07',
        width=NULL,
        height=250,
        selectizeInput(
          inputId='box07.input',
          label=NULL,
          choices=c(categories$categories),
          selected='WHIP',
          multiple=FALSE
        )
      )
    )
  })
  
  output$box08 <- renderUI({
    div(
      style="position: relative",
      box(
        id='box08',
        width=NULL,
        height=250,
        selectizeInput(
          inputId='box08.input',
          label=NULL,
          choices=c(categories$categories),
          selected='Quality Starts',
          multiple=FALSE
        )
      )
    )
  })
  
  output$team_stats_year.fig <- renderUI({
    plotOutput('team_stats_year.plot')
  })
  
  # output$team_stats_category <- reactive({
  #   input$team_stats.category
  # })
  # 
  # outputOptions(output, 'team_stats_category', suspendWhenHidden=FALSE)
  
  team_stats_year.data <- reactive({
    filtered_data <- df.full(
      figure_data=data,
      figure_team_name=input$team_stats.team,
      figure_seasons=input$team_stats.season
    )
    df.value_box(filtered_data)
  })
  
  team_stats_year.plot <- renderPlot({
    df <- team_stats_year.data()
    ggplot(
      data=df,
      aes(x=season,
          )
    )
  })
  
  

  # head_to_head -----------------------------------------------------
  output$head_to_head.plot <- renderPlot({
    shiny::validate(
      need(input$head_to_head.category, message = "Please choose a category to plot.")
    )
    
    head_to_head.data <- df.full(
      figure_data = data,
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
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
  
  output$r_box.plot <- renderPlot({
    fig.team_categories(
      df=league_stats.data(),
      selected_category='b_R',
      highlighted_team=input$team_stats.team
    )
  })

  onclick('r_box', showModal(modalDialog(
    title='Yearly category values',
    plotOutput('r_box.plot'),
    footer=modalButton("Dismiss"),
    size="l"
  )))
  
  output$r_box <- renderValueBox({
    box_category <- 'b_R'
    team_rank = rank <- df.get_rank(df = league_stats.data(),
                        teamname = input$team_stats.team,
                        selected_category = box_category
    )
    vbox_helper(category=box_category,
                data=team_stats.data(),
                rank=team_rank)
  })
  
  ####
  
  output$hr_box.plot <- renderPlot({
    fig.team_categories(
      df=league_stats.data(),
      selected_category='b_HR',
      highlighted_team=input$team_stats.team
    )
  })
  
  onclick('hr_box', showModal(modalDialog(
    title='Yearly category values',
    plotOutput('hr_box.plot'),
    footer=modalButton("Dismiss"),
    size="l"
  )))
  
  output$hr_box <- renderValueBox({
    box_category <- 'b_HR'
    team_rank = rank <- df.get_rank(df = league_stats.data(),
                                    teamname = input$team_stats.team,
                                    selected_category = box_category
    )
    vbox_helper(category=box_category,
                data=team_stats.data(),
                rank=team_rank)
  })
  
  ####
  
  output$rbi_box.plot <- renderPlot({
    fig.team_categories(
      df=league_stats.data(),
      selected_category='b_RBI',
      highlighted_team=input$team_stats.team
    )
  })
  
  onclick('rbi_box', showModal(modalDialog(
    title='Yearly category values',
    plotOutput('rbi_box.plot'),
    footer=modalButton("Dismiss"),
    size="l"
  )))
  
  output$rbi_box <- renderValueBox({
    box_category <- 'b_RBI'
    team_rank = rank <- df.get_rank(df = league_stats.data(),
                                    teamname = input$team_stats.team,
                                    selected_category = box_category
    )
    vbox_helper(category=box_category,
                data=team_stats.data(),
                rank=team_rank)
  })
  
  ####
  
  output$bbb_box.plot <- renderPlot({
    fig.team_categories(
      df=league_stats.data(),
      selected_category='b_BB',
      highlighted_team=input$team_stats.team
    )
  })
  
  onclick('bbb_box', showModal(modalDialog(
    title='Yearly category values',
    plotOutput('bbb_box.plot'),
    footer=modalButton("Dismiss"),
    size="l"
  )))
  
  
  output$bbb_box <- renderValueBox({
    box_category <- 'b_BB'
    team_rank = rank <- df.get_rank(df = league_stats.data(),
                                    teamname = input$team_stats.team,
                                    selected_category = box_category
    )
    vbox_helper(category=box_category,
                data=team_stats.data(),
                rank=team_rank)
  })
  
  ####
  
  output$kb_box.plot <- renderPlot({
    fig.team_categories(
      df=league_stats.data(),
      selected_category='b_K',
      highlighted_team=input$team_stats.team
    )
  })
  
  onclick('kb_box', showModal(modalDialog(
    title='Yearly category values',
    plotOutput('kb_box.plot'),
    footer=modalButton("Dismiss"),
    size="l"
  )))

  output$kb_box <- renderValueBox({
    box_category <- 'b_K'
    team_rank = rank <- df.get_rank(df = league_stats.data(),
                                    teamname = input$team_stats.team,
                                    selected_category = box_category
    )
    vbox_helper(category=box_category,
                data=team_stats.data(),
                rank=team_rank)
  })
  
  ####
  
  output$avg_box.plot <- renderPlot({
    fig.team_categories(
      df=league_stats.data(),
      selected_category='b_AVGr',
      highlighted_team=input$team_stats.team
    )
  })
  
  onclick('avg_box', showModal(modalDialog(
    title='Yearly category values',
    plotOutput('avg_box.plot'),
    footer=modalButton("Dismiss"),
    size="l"
  )))
  
  output$avg_box <- renderValueBox({
    box_category <- 'b_AVGr'
    team_rank = rank <- df.get_rank(df = league_stats.data(),
                                    teamname = input$team_stats.team,
                                    selected_category = box_category
    )
    vbox_helper(category=box_category,
                data=team_stats.data(),
                rank=team_rank)
  })
  
  ####
  
  output$obp_box.plot <- renderPlot({
    fig.team_categories(
      df=league_stats.data(),
      selected_category='b_OBPr',
      highlighted_team=input$team_stats.team
    )
  })
  
  onclick('obp_box', showModal(modalDialog(
    title='Yearly category values',
    plotOutput('obp_box.plot'),
    footer=modalButton("Dismiss"),
    size="l"
  )))
  
  output$obp_box <- renderValueBox({
    box_category <- 'b_OBPr'
    team_rank = rank <- df.get_rank(df = league_stats.data(),
                                    teamname = input$team_stats.team,
                                    selected_category = box_category
    )
    vbox_helper(category=box_category,
                data=team_stats.data(),
                rank=team_rank)
  })
  
  ####
  
  output$slg_box.plot <- renderPlot({
    fig.team_categories(
      df=league_stats.data(),
      selected_category='b_SLGr',
      highlighted_team=input$team_stats.team
    )
  })
  
  onclick('slg_box', showModal(modalDialog(
    title='Yearly category values',
    plotOutput('slg_box.plot'),
    footer=modalButton("Dismiss"),
    size="l"
  )))
  
  output$slg_box <- renderValueBox({
    box_category <- 'b_SLGr'
    team_rank = rank <- df.get_rank(df = league_stats.data(),
                                    teamname = input$team_stats.team,
                                    selected_category = box_category
    )
    vbox_helper(category=box_category,
                data=team_stats.data(),
                rank=team_rank)
  })
  
  ####
  
  output$nsb_box.plot <- renderPlot({
    fig.team_categories(
      df=league_stats.data(),
      selected_category='b_NSB',
      highlighted_team=input$team_stats.team
    )
  })
  
  onclick('nsb_box', showModal(modalDialog(
    title='Yearly category values',
    plotOutput('nsb_box.plot'),
    footer=modalButton("Dismiss"),
    size="l"
  )))
  
  output$nsb_box <- renderValueBox({
    box_category <- 'b_NSB'
    team_rank = rank <- df.get_rank(df = league_stats.data(),
                                    teamname = input$team_stats.team,
                                    selected_category = box_category
    )
    vbox_helper(category=box_category,
                data=team_stats.data(),
                rank=team_rank)
  })
  
  ####
  
  output$ip_box.plot <- renderPlot({
    fig.team_categories(
      df=league_stats.data(),
      selected_category='p_IP',
      highlighted_team=input$team_stats.team
    )
  })
  
  onclick('ip_box', showModal(modalDialog(
    title='Yearly category values',
    plotOutput('ip_box.plot'),
    footer=modalButton("Dismiss"),
    size="l"
  )))
  
  output$ip_box <- renderValueBox({
    box_category <- 'p_IP'
    team_rank = rank <- df.get_rank(df = league_stats.data(),
                                    teamname = input$team_stats.team,
                                    selected_category = box_category
    )
    vbox_helper(category=box_category,
                data=team_stats.data(),
                rank=team_rank)
  })
  
  ####
  
  output$w_box.plot <- renderPlot({
    fig.team_categories(
      df=league_stats.data(),
      selected_category='p_W',
      highlighted_team=input$team_stats.team
    )
  })
  
  onclick('w_box', showModal(modalDialog(
    title='Yearly category values',
    plotOutput('w_box.plot'),
    footer=modalButton("Dismiss"),
    size="l"
  )))
  
  output$w_box <- renderValueBox({
    box_category <- 'p_W'
    team_rank = rank <- df.get_rank(df = league_stats.data(),
                                    teamname = input$team_stats.team,
                                    selected_category = box_category
    )
    vbox_helper(category=box_category,
                data=team_stats.data(),
                rank=team_rank)
  })
  
  ####
  
  output$l_box.plot <- renderPlot({
    fig.team_categories(
      df=league_stats.data(),
      selected_category='p_L',
      highlighted_team=input$team_stats.team
    )
  })
  
  onclick('l_box', showModal(modalDialog(
    title='Yearly category values',
    plotOutput('l_box.plot'),
    footer=modalButton("Dismiss"),
    size="l"
  )))
  
  output$l_box <- renderValueBox({
    box_category <- 'p_L'
    team_rank = rank <- df.get_rank(df = league_stats.data(),
                                    teamname = input$team_stats.team,
                                    selected_category = box_category
    )
    vbox_helper(category=box_category,
                data=team_stats.data(),
                rank=team_rank)
  })
  
  ####
  
  output$bbp_box.plot <- renderPlot({
    fig.team_categories(
      df=league_stats.data(),
      selected_category='p_BB',
      highlighted_team=input$team_stats.team
    )
  })
  
  onclick('bbp_box', showModal(modalDialog(
    title='Yearly category values',
    plotOutput('bbp_box.plot'),
    footer=modalButton("Dismiss"),
    size="l"
  )))
  
  output$bbp_box <- renderValueBox({
    box_category <- 'p_BB'
    team_rank = rank <- df.get_rank(df = league_stats.data(),
                                    teamname = input$team_stats.team,
                                    selected_category = box_category
    )
    vbox_helper(category=box_category,
                data=team_stats.data(),
                rank=team_rank)
  })
  
  ####
  
  output$kp_box.plot <- renderPlot({
    fig.team_categories(
      df=league_stats.data(),
      selected_category='p_K',
      highlighted_team=input$team_stats.team
    )
  })
  
  onclick('kp_box', showModal(modalDialog(
    title='Yearly category values',
    plotOutput('kp_box.plot'),
    footer=modalButton("Dismiss"),
    size="l"
  )))
  
  output$kp_box <- renderValueBox({
    box_category <- 'p_K'
    team_rank = rank <- df.get_rank(df = league_stats.data(),
                                    teamname = input$team_stats.team,
                                    selected_category = box_category
    )
    vbox_helper(category=box_category,
                data=team_stats.data(),
                rank=team_rank)
  })
  
  ####
  
  output$era_box.plot <- renderPlot({
    fig.team_categories(
      df=league_stats.data(),
      selected_category='p_ERAr',
      highlighted_team=input$team_stats.team
    )
  })
  
  onclick('era_box', showModal(modalDialog(
    title='Yearly category values',
    plotOutput('era_box.plot'),
    footer=modalButton("Dismiss"),
    size="l"
  )))
  
  output$era_box <- renderValueBox({
    box_category <- 'p_ERAr'
    team_rank = rank <- df.get_rank(df = league_stats.data(),
                                    teamname = input$team_stats.team,
                                    selected_category = box_category
    )
    vbox_helper(category=box_category,
                data=team_stats.data(),
                rank=team_rank)
  })
  
  ####
  
  output$whip_box.plot <- renderPlot({
    fig.team_categories(
      df=league_stats.data(),
      selected_category='p_WHIPr',
      highlighted_team=input$team_stats.team
    )
  })
  
  onclick('whip_box', showModal(modalDialog(
    title='Yearly category values',
    plotOutput('whip_box.plot'),
    footer=modalButton("Dismiss"),
    size="l"
  )))
  
  output$whip_box <- renderValueBox({
    box_category <- 'p_WHIPr'
    team_rank = rank <- df.get_rank(df = league_stats.data(),
                                    teamname = input$team_stats.team,
                                    selected_category = box_category
    )
    vbox_helper(category=box_category,
                data=team_stats.data(),
                rank=team_rank)
  })
  
  ####
  
  output$qs_box.plot <- renderPlot({
    fig.team_categories(
      df=league_stats.data(),
      selected_category='p_QS',
      highlighted_team=input$team_stats.team
    )
  })
  
  onclick('qs_box', showModal(modalDialog(
    title='Yearly category values',
    plotOutput('qs_box.plot'),
    footer=modalButton("Dismiss"),
    size="l"
  )))
  
  output$qs_box <- renderValueBox({
    box_category <- 'p_QS'
    team_rank = rank <- df.get_rank(df = league_stats.data(),
                                    teamname = input$team_stats.team,
                                    selected_category = box_category
    )
    vbox_helper(category=box_category,
                data=team_stats.data(),
                rank=team_rank)
  })
  
  output$nsvh_box.plot <- renderPlot({
    fig.team_categories(
      df=league_stats.data(),
      selected_category='p_NSVH',
      highlighted_team=input$team_stats.team
    )
  })
  
  onclick('nsvh_box', showModal(modalDialog(
    title='Yearly category values',
    plotOutput('nsvh_box.plot'),
    footer=modalButton("Dismiss"),
    size="l"
  )))
  
  output$nsvh_box <- renderValueBox({
    box_category <- 'p_NSVH'
    team_rank = rank <- df.get_rank(df = league_stats.data(),
                                    teamname = input$team_stats.team,
                                    selected_category = box_category
    )
    vbox_helper(category=box_category,
                data=team_stats.data(),
                rank=team_rank)
  })
  
  team_stats.data <- reactive({
    filtered_data <- df.full(
      figure_data=league_data,
      figure_team_name=input$team_stats.team,
      figure_seasons=input$team_stats.season
    )
    df.valueBox(filtered_data, team_box=TRUE)
  })
  
  league_stats.data <- reactive({
    filtered_data <- df.full(
      figure_data=league_data,
      figure_season=input$team_stats.season
    )
    df.valueBox(filtered_data)
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
function(input, output){
    

# create Reactive ---------------------------------------------------------

    workersYear <- reactive({
        data <- workers %>% 
            filter(year %in% input$selectYear)
        
        return(data)
    })    
    
    # workersCat <- reactive({
    #     data <- workers %>% 
    #         filter(major_category %in% input$selectCat)
    #     
    #     return(data)
    # })
        

# employment plot ---------------------------------------------------------
    output$employPlot <- renderPlotly({
    
        # transform data
        workers_gap <- workersYear() %>% 
           # filter(year %in% input$selectYear) %>% 
            group_by(major_category) %>% 
            summarise(Male = mean(percent_male),
                      Female = mean(percent_female)) %>% 
            ungroup() %>% 
            mutate(
                major_category = reorder(major_category,
                                         Male-Female)
            ) %>% 
            pivot_longer(cols = -major_category) %>% 
            mutate(
                text = glue::glue('{name}: {round(value,2)}%'))
        # visualize
        plot <- ggplot(workers_gap, aes(x = value, y = major_category, text = text))+
            geom_col(aes(fill = name))+
            geom_vline(xintercept = 50, linetype = "dotted")+
            labs(x=NULL, y = NULL, title = glue::glue("US Labor Force Participation"))+
            theme(legend.position = "none")+
            scale_x_continuous(labels = scales::unit_format(unit = "%"))+
            scale_fill_manual(values = c("indianred3","cadetblue"))+
            theme_algoritma
        
        # add interactivity
        ggplotly(plot, tooltip = "text") %>% config(displayModeBar = F)
    })
    

# wage plot ---------------------------------------------------------------

    output$wagePlot <- renderPlotly({
        workers_earn <- workersYear() %>% 
           # filter(year %in% input$selectYear) %>% 
            group_by(major_category) %>% 
            summarise(Male = mean(total_earnings_male),
                      Female = mean(total_earnings_female)) %>% 
            ungroup() %>% 
            mutate(
                major_category = reorder(major_category,
                                         Male-Female)
            ) %>% 
            pivot_longer(cols = -major_category) %>% 
            mutate(
                text = glue::glue('{name}: {round(value,2)}$')
            )
        
        # visualize
        plot_earn <- ggplot(workers_earn, aes(x = major_category,
                                              y = value, text = text))+
            coord_flip()+
            geom_col(aes(fill = name), position = "dodge")+
            labs(x=NULL, y = NULL, title = "Gender Wage Gap")+
            theme(legend.position = "none")+
            scale_y_continuous(labels = scales::unit_format(unit = "$"))+
            scale_fill_manual(values = c("indianred3","cadetblue"))+
            theme_algoritma
        
        # add interactivity
        ggplotly(plot_earn, tooltip = "text") %>% config(displayModeBar = F)
        
    })
    
    
    # Growth Plot -------------------------------------------------------------
    
    output$growthPlot <- renderPlotly({
        df <- workers %>% 
            filter(major_category == input$selectCat) %>% 
            group_by(year) %>% 
            summarise(
                Male = mean(percent_female),
                Female = mean(percent_male)
            ) %>% 
            ungroup() %>% 
            pivot_longer(cols = -year) %>% 
            mutate(text = glue::glue('{name}: {round(value,2)}%'))
        
        plot <- ggplot(df,aes(year, value, group = name, text = text))+
            geom_line(aes(color = name))+
            geom_point(aes(color = name))+
            facet_wrap(~name, ncol = 2, scales = "free")+
            scale_y_continuous(labels = scales::unit_format(unit = '%'))+
            scale_color_manual(values = c("indianred3","cadetblue"))+
            labs(x = NULL, y = NULL)+
            theme_algoritma+
            theme(panel.spacing = unit(-0.5, "lines"),
                  legend.position = "none")
        
        ggplotly(plot, tooltip = "text") %>% config(displayModeBar = F)
        
    })

# Data Table Output -------------------------------------------------------

    output$workersDT <-  DT::renderDataTable({
        workersYear()
    })    
    
}





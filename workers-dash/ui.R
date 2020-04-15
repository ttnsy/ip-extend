header <- dashboardHeader(
    title = tags$a(
        href = "https://www.bls.gov/",
        tags$img(
            src = "https://www.bls.gov/images/bls_emblem_trans.png",
            height = "90%"
        ),
        "BLS"
    )
)

sidebar <- dashboardSidebar(
   sidebarMenu(
       menuItem(
           text = "Overview",
           tabName = "overview",
           icon = icon("chart-bar")
       ),
       selectInput(
           inputId = "selectYear",
           label = "Select Year:",
           choices = yearOpt, #c(2013,2014,2015,2016)
           selected = yearOpt[1],
           multiple = T
       ),
       menuItem(
           text = "Source Data",
           tabName = "sourcedata",
           icon = icon("table")
       )
   )
)

body <- dashboardBody(
    tabItems(
        tabItem(
            tabName = "overview",
            fluidRow(
                column(
                    width = 5,
                    plotlyOutput("employPlot")
                ),
                column(
                    width = 5,
                    plotlyOutput("wagePlot")
                )
            ),
            br(),
            h2("Annual Employment Growth"),
            fluidRow(
                column(
                    width = 5,
                    selectInput(
                        inputId = "selectCat",
                        label = "Select Category:",
                        choices = unique(workers$major_category)
                    )
                )
            ),
            fluidRow(
                column(
                    width = 5,
                    plotlyOutput("growthPlot")
                )
            )
        ),
        tabItem(
            tabName = "sourcedata",
            fluidRow(
                DT::dataTableOutput("workersDT")
            )
        )
    )
)


dashboardPage(
    header = header,
    sidebar = sidebar,
    body = body,
    skin = "black"
)












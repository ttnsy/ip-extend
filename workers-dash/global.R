# prep library ------------------------------------------------------------
library(shiny)
library(shinydashboard)
library(tidyverse)
library(DT)
library(plotly)

# prep data ---------------------------------------------------------------

# read data
workers <- read_csv("data/jobs_gender.csv")

# read theme from RDS
theme_algoritma <- readRDS('assets/theme_algoritma.rds')

# tidy data
workers <- workers %>% 
  mutate(percent_male = 100-percent_female) %>% 
  drop_na(total_earnings_male, total_earnings_female)

# Options for choices -----------------------------------------------------

yearOpt <- unique(workers$year)
  
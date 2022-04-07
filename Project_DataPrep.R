#Calling libraries
install.packages("xlsx")
library(dplyr)
library(stringr)
library(tidyr)
library(xlsx)


#Reading datasets from Github - eceakansel :)
hollywood <- read.csv("https://raw.githubusercontent.com/eceakansel/ISM6562-TermProject/main/Highest%20Holywood%20Grossing%20Movies.csv")
imdb <- read.csv("https://raw.githubusercontent.com/eceakansel/ISM6562-TermProject/main/imdb_top_1000.csv")
movies <- read.csv("https://raw.githubusercontent.com/eceakansel/ISM6562-TermProject/main/movies.csv")
top4000 <- read.csv("https://raw.githubusercontent.com/eceakansel/ISM6562-TermProject/main/top_4000_movies_data.csv")
metadata <- read.csv("https://raw.githubusercontent.com/eceakansel/ISM6562-TermProject/main/movie_metadata.csv")

#Removing some overlapping data from datasets
hollywood %>% select(-Genre, -Movie.Info) -> hollywood


#Seperating Genre into 1-2-3
imdb <- imdb %>% separate(Genre, c('Genre 1', 'Genre 2', 'Genre 3'))

#rename columns
names(top4000)[1] <- 'Release Date'
names(top4000)[2] <- 'Title'
names(movies)[1] <- 'Title'

metadata$Title <- gsub("[^A-Za-z]", "", metadata$Title)


# Merging Datasets
master <- merge(x= imdb, y=hollywood, by = "Title", all = TRUE)


master %>% drop_na(IMDB_Rating) -> master


# Merging Datasets
master <- merge(x= master, y=top4000, by = "Title", all = TRUE)

master$Title <- gsub('\\s+', '', master$Title)
master <- merge(x= master, y=metadata, by = "Title", all = TRUE)
movies$Title <- gsub('\\s+', '', movies$Title)
master <- merge(x= master, y=movies, by = "Title", all = TRUE)


write.csv(master, "C:\\Study\\UF\\Spring Semester\\Module 4\\ISM6562 - Business Data Presentation and Visualization\\master.csv")

library(rvest)

#Getting the website link
website_link <- "https://www.imdb.com/chart/top/?ref_=nv_mv_250"

#Extracting the website html components
website_page <- read_html(website_link,encoding = "UTF-8")

#Extracting movie title
movie_title <- website_page %>% html_nodes(".titleColumn a") %>% html_text()

#Extracting movie link
movie_link <- website_page %>% html_nodes(".titleColumn a") %>% html_attr("href")
movie_link <- paste("https://www.imdb.com/",movie_link, sep = "")

#Extracting movie release year
movie_year <- website_page %>% html_nodes(".secondaryInfo") %>% html_text()
movie_year <- substring(movie_year,2,5)

#Extracting movie rating
movie_rating <- website_page %>% html_nodes("strong") %>% html_text()

rank <- seq(from=1 , to= 250, by = 1)

#Creating movie data frame
movie_list <- data.frame(rank,movie_title,movie_year,movie_rating,movie_link)

write.csv(movie_list, "movie_list.csv",row.names = FALSE )

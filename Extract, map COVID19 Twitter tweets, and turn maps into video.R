# install packages and load

library(rtweet)
library(tidyverse)
library(dplyr)
library(tidyr)
library(lubridate)

# EXTRACTING TWEETS AND
# EXAMPLE USING TWEETS FROM MAR 29,2020
 
mar29_coord <- lat_lng(twt_mar29T) 
# note twt_mar29T is the product of search_tweets("COVID19", n = 18000, include_rts = TRUE, lang = "en") on Mar 29, 2020
# Show twt_mar29T tweets

mar29_geo <- na.omit(mar29_coord[, c("lat", "lng")])
mar29_geo$date <- as.Date("2020-03-29")
write.csv(mar29_geo, "geo1.csv")

# MAPPING Method 1
# Plotting map using ggplot2
library(ggplot2)
library(maps)
library(ggthemes)

# Create base map
world_base <- ggplot() + borders("world", colour = "gray70", fill = "gray80") + theme_map()
world_base

# Plot the map
map <- world_base +
  geom_point(data = mar29_geo, aes(x = lng, y = lat), 
             colour = 'red', alpha = 0.5) +
  labs(title = "COVID19 Tweets Mar 29, 2020 ")
typeof(map)
map

# MAPPING Method 2
# Plotting map using leaflet
library(leaflet)
mar29 <- mar29_geo %>% leaflet() %>%
  addProviderTiles(provider = "Esri") %>%
  addCircleMarkers(lng = ~lng, lat = ~lat, radius = 5, color = "purple", stroke = FALSE, fillOpacity = 0.5)
mar29

# Saving to png Method 1
# from leaflet to html to png
library(htmlwidgets)
library(webshot)
saveWidget(mar29, "temp1.html", selfcontained = FALSE)
webshot("temp1.html", file = "webshot.png", cliprect = "viewport") 
# file can be .png, .pdf, or .jpeg
# selfcontained Whether to save the HTML as a single self-contained file (with external resources 
# base64 encoded) or a file with external resources placed in an adjacent directory 

saveWidget(mar29, "temp01.html", selfcontained = FALSE)
webshot("temp01.html", file = "image1.png", cliprect = "viewport")
# in which case the clipping rectangle matches the viewport size, size of viewing window

# Saving to png method 2
# from leaflet to png
library(mapview)
mapshot(mar29, file = "mapshot.png")
# file can be .png, .pdf, or .jpeg

install_phantomjs(version = "2.1.1",
                  baseURL = "https://bitbucket.org/ariya/phantomjs/downloads/",
                  force = FALSE)
# quickly grabs a web page and saves as a screenshot
# ability to load and manipulate web pages.

# For the rest of the tweets, use MAPPING Method 2

# MAR 30, 2020 TWEETS
mar30_coord <- lat_lng(twt_mar30T) 
mar30_geo <- na.omit(mar30_coord[, c("lat", "lng")])
mar30_geo$date <- as.Date("2020-03-30")
write.csv(mar30_geo, "geo2.csv")
mar30 <- mar30_geo %>% leaflet() %>%
  addProviderTiles(provider = "Esri") %>%
  addCircleMarkers(lng = ~lng, lat = ~lat, radius = 5, color = "purple", stroke = FALSE, fillOpacity = 0.5)
saveWidget(mar30, "temp2.html", selfcontained = FALSE)
webshot("temp2.html", file = "image2.png", cliprect = "viewport")

# Repeat the above for how ever many times you need to

# TURNING ALL MAPS FROM MAR 29, 2020 TO APR 28, 2020 INTO VIDEO
# ffmpeg (see link to download and install)
# run in command prompt

# check format
ffmpeg -formats 

# change directory
cd C:\ffmpeg\ffmpeg\bin

# combine png images to mp4 video 
ffmpeg -framerate 1/2 -i image%03d.png covid.mp4 # 2s between maps 

# I have provided Excel of latitude and longitude coordinates so you can upload using read.csv()
# Then you can plot your map


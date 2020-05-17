devtools::install_github('charlie86/spotifyr')
library(spotifyr)
library(dplyr)
library(ggplot2)
library(httpuv)
library(lubridate)
library(purrr)
library(knitr)
library(plotly)
library(tidytext)
library(textdata)
library(rvest)

Sys.setenv(SPOTIFY_CLIENT_ID = "CLIENT ID HERE")
Sys.setenv(SPOTIFY_CLIENT_SECRET = "CLIENT SECRET HERE")

# valence

mobb_deep <- get_artist_audio_features('mobb deep')
the_infamous <- mobb_deep %>% filter(album_id == "1cCAb1vN8uUsdfEylVmTLs")

nas <- get_artist_audio_features('nas')
illmatic <- nas %>% filter(album_id == "3kEtdS2pH6hKcMU9Wioob1")

big_l <- get_artist_audio_features('big l')
lifestyles_ov_da_poor_and_dangerous <- big_l %>% filter(album_id == "7xvBUHu5jJ7X0wdRHudLFD")

wu_tang <- get_artist_audio_features('wu-tang clan')
enter_the_wu_tang <- wu_tang %>% filter(album_id == "6acGx168JViE5LLFR1rGRE")

jay_z <- get_artist_audio_features('jay-z')
reasonable_doubt <- jay_z %>% filter(album_id == "3YPK0bNOuayhmSrs0sIIBR")

lost_boyz <- get_artist_audio_features('lost boyz')
legal_drug_money <- lost_boyz %>% filter(album_id == "6DciMZgZkLpqsjJUd5XgpF")

gang_starr <- get_artist_audio_features('gang starr')
hard_to_earn <- gang_starr %>% filter(album_id == "67kl5m0df6Bn0aSe3g5Ea7")

onyx <- get_artist_audio_features('onyx')
all_we_got_iz_us <- onyx %>% filter(album_id == "2tIjXLaBInbrlYGFaPH3Us")
bacdafucup <- onyx %>% filter(album_id == "5lUgtggG1KroP0qHkpxQ4K")

comp_albums <- the_infamous %>% 
  rbind(illmatic) %>% 
  rbind(lifestyles_ov_da_poor_and_dangerous) %>% 
  rbind(enter_the_wu_tang) %>% 
  rbind(reasonable_doubt) %>% 
  rbind(legal_drug_money) %>% 
  rbind(hard_to_earn) %>% 
  rbind(bacdafucup)

comp_albums_no_skits <- comp_albums %>% 
  filter(speechiness <= .7 & duration_ms >= 90000) %>% 
  mutate(`Album Name` = album_name,
         Valence = valence,
         `Track Number` = track_number)

valence_plot = ggplot(comp_albums_no_skits,aes(x = `Track Number`, y = Valence, colour = `Album Name`)) + 
  geom_line() +
  geom_point(aes(text = track_name)) + 
  scale_colour_manual(values = c("brown","yellow","red","orange","pink","black","gray","purple")) +
  theme_bw() +
  ggtitle("Track Valence in Mid-1990's NYC Hip-Hop Albums")

ggplotly(valence_plot,hoverinfo = "text")

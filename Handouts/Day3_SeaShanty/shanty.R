## Shanty adapted from the Stack Overflow discussion posted here: https://stackoverflow.com/questions/31782580/how-can-i-play-birthday-music-using-r
## some interesting further reading on processing sound in R: https://medium.com/@taposhdr/basics-of-audio-file-processing-in-r-81c31a387e8e 

# Install required packages
if(!require(dplyr)){install.packages("dplyr")}
if(!require(audio)){install.packages("audio")}

#####

# Load libraries
require("dplyr")
require("audio")

#### Set up functions and constants
tempo <- 110 
sample_rate <- 44100 #hertz = cycles per second
notes <- c(A = 0, B = 2, C = 3, D = 5, E = 7, F = 8, G = 10, B3= -8, C3= -7, D3= -5)

# Function to convert pitch and frequency to sin wave for audio file
make_sine <- function(freq, duration) {
  wave <- sin(seq(0, duration / tempo * 60, 1 / sample_rate) *
                freq * 2 * pi)
  fade <- seq(0, 1, 50 / sample_rate)
  wave * c(fade, rep(1, length(wave) - 2 * length(fade)), rev(fade))
}

## Program song melody

m_pitch <- 'F# B3 B3 B3 B3 D F# F# F# F# F# G E E E G G B B F# F# F# B3 C# D E F# F# F# F# F# E D D C# B3 B B G A A F# F# F# G E E F# G F# D B B B A G A A F# F# F# F# E D C# B3'
m_duration <- c(0.5,0.5,0.25,0.25,0.5,0.5,0.5,0.5,0.5,0.25,0.25,0.5,0.25,0.25,0.5,0.25,0.25,0.25,0.25,0.5,0.75,0.25,0.5,0.5,0.5,0.5,0.5,0.5,0.75,0.25,0.5,0.5,0.25,0.25,0.5,2,1,0.75,0.25,0.25,0.25,0.5,0.75,0.25,0.5,0.5,0.25,0.25,0.5,0.5,0.5,1,1,0.5,0.25,0.25,0.25,0.25,0.5,0.5,0.5,0.5,0.5,0.5,0.5,2)

# Combine pitch and duration into single data frame
melody <- data_frame(pitch = strsplit(m_pitch, " ")[[1]],
                   duration = m_duration)
# Add variables based on calculations
melody <-
  melody %>%
  mutate(octave = substring(pitch, nchar(pitch)) %>%
           {suppressWarnings(as.numeric(.))} %>%
           ifelse(is.na(.), 5, .),
         note = notes[substr(pitch, 1, 1)],
         note = note + grepl("#", pitch) -
           grepl("b", pitch) + octave * 12 +
           12 * (note < 3),
         freq = 2 ^ ((note - 60) / 12) * 440)

# Apply the make_sine function in a matrix-apply function 
# Note: "apply" family functions are powerful constructs in R that let you 
# use a function over a series of data inputs automagically. In this case, 
# we "apply" the make_sine function to all the values from the melody dataframe

melody_wave <-
  mapply(make_sine, melody$freq, melody$duration) %>%
  do.call("c", .)

### Program Harmony


h_pitch<- 'F B B B B D F# F# F# F# F# G E E E G G B B F# F# F# B C# D E F# F# F# F# F# E D D C# B G G D D A A B B G G D D A A B'
h_duration<- c(0.5,0.5,0.25,0.25,0.5,0.5,0.5,0.5,0.5,0.25,0.25,0.5,0.25,0.25,0.5,0.25,0.25,0.25,0.25,0.5,0.75,0.25,0.5,0.5,0.5,0.5,0.5,0.5,0.75,0.25,0.5,0.5,0.25,0.25,0.5,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2)


harmony <- data_frame(pitch = strsplit(h_pitch, " ")[[1]],
                     duration = h_duration)

harmony <-
  harmony %>%
  mutate(octave = substring(pitch, nchar(pitch)) %>%
           {suppressWarnings(as.numeric(.))} %>%
           ifelse(is.na(.), 4, .),
         note = notes[substr(pitch, 1, 1)],
         note = note + grepl("#", pitch) -
           grepl("b", pitch) + octave * 12 +
           12 * (note < 3),
         freq = 2 ^ ((note - 60) / 12) * 440)

harmony_wave <-
  mapply(make_sine, harmony$freq, harmony$duration) %>%
  do.call("c", .)

# Cut the melody wave down to the same length as the harmony for combining
melody_wave <- melody_wave[1:length(harmony_wave)]
shanty <- rbind(melody_wave, harmony_wave)
play(shanty)


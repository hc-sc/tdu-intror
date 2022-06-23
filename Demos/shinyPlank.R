suppressMessages(require(shiny))
suppressMessages(require(shinyjs))
suppressMessages(require(shinythemes))
suppressMessages(require(dplyr))
suppressMessages(require(audio))


wheel_of_names <- function(n){
  
  participants <- c("INSERT NAMES HERE")
  
  welcome <-c( "'Ahoy matey, its a fine day to walk the plank! Let's see who we've got here!'",
               "'Well well well, it's up to me to decide yer fate is it? How's about we parley a bit?'",
               "'No takers, is that it?? Well then, we'll just have to count on our trusty tools then won't we!'",
               "'The silent types, are ye? We'll make ye parley yet!'",
               "'Don't be shy! A piRates life is a wondRous thing! Sail the open-data seas with us!'")
  
  emote <- c("Scout circles the ship, cackling joyfully and landing on the shoulders of: ",
             "Suddenly, the wind changes, everyone loses their footing and disappears, leaving only: ",
             "Mysterious forces cause the ship's compass to spin wildly round and round. Suddenly, it stops, with its needle pointing directly at: ")
  
  play_shanty()
  message("Impatiently, the ship's parrot Scout shouts out:")
  Sys.sleep(3)
  message(sample(welcome, 1, replace = FALSE))
  Sys.sleep(3)
  message(sample(emote, 1, replace = FALSE))
  Sys.sleep(3)
  message("\n ...")
  Sys.sleep(3)
  message("\n .........")
  Sys.sleep(3)
  message("\n ................ \n")
  Sys.sleep(3)
  message(toupper(sample(participants, n, replace = FALSE)))
}


play_shanty <- function(){
  
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
}




runApp(shinyApp(
  ui = fixedPage(id = 'test',
                 tags$style('#test {
                             background-color: #A8D9F3;
              }'),
    theme = shinytheme("united"),
    titlePanel("Time ta paRlay!"),
    sidebarPanel(id = 'test2',
                 tags$style('#test2 {
                             background-color: #02A4D3;
              }'),
    shinyjs::useShinyjs(),
    actionButton("btn","PARLAY")), 
    mainPanel(
    uiOutput("text")
    )
  ),
  server = function(input,output, session) {
    observeEvent(input$btn, {
      withCallingHandlers({
        shinyjs::html("text", "")
        wheel_of_names(1)
      },
      message = function(m) {
        shinyjs::html(id = "text", html = m$message, add = TRUE)
      })
    })
  }
))


wheel_of_names <- function(n){

  participants <- c("INSERT NAMES HERE")
  
  welcome <-c( "'Ahoy matey, its a fine day to walk the plank! Let's see who we've got here!'",
                "'Well well well, it's up to me to decide yer fate is it? How's about we parley a bit?'",
                "'No takers, is that it?? Well then, we'll just have to count on our trusty tools then won't we!'",
                "'The silent types, are ye? We'll make ye parley yet!'",
                "'Don't be shy! A piRates life is a thing! Sail the open-data seas with us!'")
  
  emote <- c("Scout circles the ship, cackling joyfully and landing on the shoulders of: ",
             "Suddenly, the wind changes, everyone loses their footing and disappears, leaving only: ",
             "Mysterious forces cause the ship's compass to spin wildly round and round. Suddenly, it stops, with its needle pointing directly at: ")
  
  
print("Impatiently, the ship's parrot Scout shouts out:")
Sys.sleep(3)
print(sample(welcome, 1, replace = FALSE))
Sys.sleep(3)
print(sample(emote, 1, replace = FALSE))
print(".")
Sys.sleep(3)
print("..")
Sys.sleep(3)
print("...")
Sys.sleep(3)
print(toupper(sample(participants, n, replace = FALSE)))

}


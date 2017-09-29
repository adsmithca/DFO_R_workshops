#Example #1: 
#Gathering the dune data into long format

#Loading the packages and getting data ready
library(readr)
library(tidyr)
library(dplyr)
library(vegan)
dune_sp = read_csv("data/dune.csv")
dune_sp

#gathering the data up into the long format
gather(dune_sp, key=species, value = "cover_class", Achimill:Callcusp) 
dune_sp_gath <- gather(dune_sp, key=species, value = "cover_class", Achimill:Callcusp) 

spread(dune_sp_gath, species, cover_class)
dune_env = read_csv("data/dune.env.csv")
dune_env
spread(dune_env, Use, Moisture)

# Example #3: using pipes
dune_new <- dune_env %>%
  subset(Management == "HF") %>%
  spread(Use, Moisture)
dune_new

# Example #4: using summarise
dune_long <- gather(dune_sp, key=species, value = "cover_class", Achimill:Callcusp) 

dune_summary <- dune_long %>%
  group_by(species) %>%
  summarise(mean = mean(cover_class))

dune_summary
dune_summary <- dune_env %>%
  group_by(Management, Use) %>%
  summarise(count = n())
dune_summary

# Example #5: using mutate
## examples
dune_mutate <- dune_sp %>%
    mutate(sum_sp = Achimill + Agrostol)  

dune_mutate[c("Achimill", "Agrostol", "sum_sp")]
dune_mutate <- dune_sp %>%
    mutate(test = between(Achimill, 2, 3))
dune_mutate[c("Achimill", "test")]

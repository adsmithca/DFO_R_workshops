
# intermediate plots
biomass <- read_csv("data/trawl_biomass.csv")
ggplot(data = biomass, aes(x = factor(year), y = shrimp)) + geom_boxplot()



#' Function for calculating mean catch by year for species in the biomass data
#'
#' @param biomass Data frame with trawl catches of shrimp, cod, halibut and redfish from 1995-2010
#' @param species Species to select for calculations ("shrimp", "cod", "halibut" or "redfish")
#'
#' @return Returns a tibble containing mean, sd, n, lwr, and upr values by year.
#'         Columns lwr and upr represent lower and upper 95 percent confidence intervals.
#'
#' @export trends
#' @import dplyr
#'

trends <- function(biomass, species = "redfish") {

  ## Calculate mean, sd, n, and 95% confidence intervals (lwr, upr)
  biomass %>%
    select_("year", species) %>%
    group_by(year) %>%
    summarize_all(funs(mean, sd, n())) %>%
    mutate(lwr = mean - qnorm(0.975) * sd / sqrt(n),
           upr = mean + qnorm(0.975) * sd / sqrt(n))

}


#' Function for plotting trends in mean catch by year for species in the biomass data
#'
#' @inheritParams trends
#'
#' @return A plot of mean catch, +/- 95 percent confidence intervals, by year
#'
#' @export plot_trends
#' @import ggplot2
#'

plot_trends <- function(biomass, species = "redfish") {

  ## Calculate means, etc. using the trends function, then plot
  sp_trends <- trends(biomass, species = species)
  ggplot(sp_trends, aes(x = year, y = mean)) +
    geom_line() + geom_point(size = 3) +
    geom_errorbar(aes(min = lwr, max = upr), width = 0) +
    xlab("Year") + ylab("Mean") + theme_bw()

}

## this is a dummy committ

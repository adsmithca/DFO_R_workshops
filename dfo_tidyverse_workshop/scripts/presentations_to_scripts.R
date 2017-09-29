library(knitr)

# intro presentation to script ####


convert_pres_to_script = function(input_path, output_path){
  purl(input_path,
       output = output_path,
       documentation = 0)
  #cleaning the script to remove the opts line: 
  full_script = readLines(output_path)
  reduced_script = full_script[-grep("knitr::opts_knit",full_script)]
  writeLines(reduced_script,con = output_path)
}
  


convert_pres_to_script(input_path = "presentations/intro_to_tidyverse.Rpres",
                       output_path = "scripts/1. intro_to_tidyverse.R")
                       
convert_pres_to_script(input_path = "presentations/readr_presentation.Rpres",
                       output_path = "scripts/2. readr_script.R")

convert_pres_to_script(input_path = "presentations/tidyverse-KL.Rpres",
                       output_path = "scripts/3. tidyr_and_pipes.R")

convert_pres_to_script(input_path = "presentations/dplyr_beginning.Rpres",
                       output_path = "scripts/4. dplyr_part1_script.R")

convert_pres_to_script(input_path = "presentations/full_presentation.Rpres",
                       output_path = "scripts/tidyverse_full_script.R")
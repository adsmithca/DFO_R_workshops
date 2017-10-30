## Intermediate Example
## Project path and name
root_dir <- "D:/Keith/R/presentations/DFO_R_workshops/dfo_repro_research"                      # path to your project
proj_name <- "ReproResearch"       # project name

## Metadata for the project
proj_metadata <- list("Title" = "Reproducible research using RMarkdown",
                      "Authors@R" = 'c(person("Keith", "Lewis", 
                      email = "Keith.Lewis@dfo-mpo.gc.ca", role = c("aut", "cre")))',
                      "Description" = "This is a workshop demonstrating the importance of 
                      RR and how to set up RMarkdown files in RStudio",
                      "License" = "NA",
                      "Imports" = c("devtools", "knitr"))

## Generate the skeleton for the project
devtools::create(file.path(root_dir, proj_name),
                 description = proj_metadata)           # generates a minimum R package skeleton
devtools::use_git(pkg = file.path(root_dir, proj_name)) # Initalize local git repository
dir.create(file.path(root_dir, proj_name, "data"))      # adds a data folder to the directory
dir.create(file.path(root_dir, proj_name, "analysis"))  # adds an analysis folder to the directory
dir.create(file.path(root_dir, proj_name, "report"))  # adds an report folder to the directory
dir.create(file.path(root_dir, proj_name, "presentation"))  # adds an presentation folder to the directory




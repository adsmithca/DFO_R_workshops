## Project path and name
root_dir <- "D:/Keith/R/presentations/DFO_R_workshops/dfo_repro_research"                                  # path to your project
proj_name <- "ReproResearch"                                    # project name

## Metadata for the project
proj_metadata <- list("Title" = "Reproducible Research in R: an introduction",
                      "Authors@R" = 'c(person("Paul", "Regular", email = "Paul.Regular@dfo-mpo.gc.ca", 
                      role = c("aut", "cre")),
                      person("Keith", "Lewis", email = "Keith.Lewis@dfo-mpo.gc.ca", 
                      role = "aut"))',
                      "Description" = "An introduction to conducting reproducible research in R using RMarkdown",
                      "License" = "NA",
                      "Imports" = c("knitr"))

## Generate the skeleton for the project
devtools::create(file.path(root_dir, proj_name),
                 description = proj_metadata)           # generates a minimum R package skeleton
#devtools::use_git(pkg = file.path(root_dir, proj_name)) # Initalize local git repository - use this when creating a new project
dir.create(file.path(root_dir, proj_name, "data"))      # adds a data folder to the directory
dir.create(file.path(root_dir, proj_name, "analysis"))  # adds an analysis folder to the directory
dir.create(file.path(root_dir, proj_name, "R"))
dir.create(file.path(root_dir, proj_name, "report"))
dir.create(file.path(root_dir, proj_name, "presentation"))
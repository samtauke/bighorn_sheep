# bighorn_sheep


This repository contains the code necessary to replicate the analyses in our summer 2021 Stat 699 course final report.  The three team members are listed below:
  - Jake Reiners
  - Steven Min
  - Sam Tauke


### Preparing Your Machine

The code in this project is a combination of R and Python.  The R code can be run any way you like but we wrote it in RStudio.  The Python code is all written in Jupyter, so you will need to make some updates if you don't want to use Jupyter.  There are a number of R libraries / Pythong packages used, so if you are having problems running the code it is likely that you are missing a library or package.

To run the code, you should create a directory on your machine.  In that directory, you should have "code" and "data" folders.  The "code" folder contains all the files from this repository.  Make sure to maintain the subfolder structure within the "code" folder.  The "data" folder should contain "raw" and "datasets" subfolders.  From an organizational standpoint, the "raw" folder is meant to contain all the raw data given to us by the USGS and the "datasets" folder contains any output (intermediate or final) from our analyses.

Make sure that the "raw" folder contains: "batch 1 final.csv", "batch 2 final.csv", and "sheep_sample_meatadata_v2.csv". 

### Running the Code

The Code must be run in the following sequence:
  1. "./import/import_raw_data.R"
  2. "./build/build_analysis_data.R"
  3. "./analysis/00_train_test_split.ipynb"
  4. "./analysis/01_summarise_data.R"
  5. "./analysis/02_random_forest.ipynb"
  6. "./analysis/03_svm.ipynb"
  7. "./analysis/04_neural_net_optimization.ipynb"




### Questions
If you have questions about this repository, please email samtauke@gmail.com

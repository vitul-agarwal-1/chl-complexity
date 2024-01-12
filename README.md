# chl-complexity

The data and material are associated with the manuscript "Patterns in the temporal complexity of global chlorophyll concentration" submitted to Nature Communications. For any questions or concerns, please contact the corresponding author (Vitul Agarwal) at vitulagarwal@uri.edu

As there are greater than 350,000 time series that were considered in the final analysis, we have provided a sample of 5000 time series (sample.Rdata) with their coordinates (sample_loc.Rdata). The sample data can be found at 10.5281/zenodo.10498356
Raw data can be downloaded from https://hermes.acri.fr/

Each time series was created by (1) downloading raw data for each day between Jan 1998 to Jan 2023., (2) processing and combining the individual files for each 25x25km pixel into a single time series, (3) checking for sufficient data, and (4) using the filtered time series for complexity analysis. Given the spatial (25x25) and temporal (daily for 25 years) scale of the analysis, most of the analyses were conducted utilizing high-performance computing.

In the following attached files, we have provided some sample data alongside three R scripts: 'calculating_elasticity.R','calculating_fractal_dimension.R' and 'calculating_yearly_trend.R'. Each R script is designed to calculate the appropriate metric for a time series dataset. Any required packages are mentioned at the top of the R script. For those that are not familiar with R or require translation into other languages (or data formats such as Excel), please contact the corresponding author for assistance. 

Important Note: Despite the smaller, limited dataset, some personal computers may still need extended periods of time to run these scripts. For such cases, please create an even smaller dataset or reduce the 'no.trials' parameter. 

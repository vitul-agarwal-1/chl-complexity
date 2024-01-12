
require(abind)
require(fractaldim)

load("sample.Rdata") ####A dataset of 5000 chl-a concentration time series
load("sample_loc.Rdata") ####Location (Lat-lon) of the time series in the dataset

fdim <- vector()
nas <- vector()
range <- vector()

for(k in 1:length(sample)){
  
  df <- as.data.frame(sample[[k]])
  chl <- df$chl_values
  
  mn <- mean(chl, na.rm = T)
  std <- 3*(sd(chl, na.rm = T))
  chl[which(chl > (mn+std))] <- NA ####here, we remove all the values greater than 3 standard deviations from the mean
  
  nas[k] <- length(chl[is.na(chl)==TRUE])
  range[k] <- chl[which.max(chl)] - chl[which.min(chl)]
  
  chl[is.na(chl)==TRUE] <- sample(chl[is.na(chl)==FALSE], size = length(chl[is.na(chl) == TRUE]), replace = TRUE) ####resampling with replacement is used to fill in all the NAs in the time series
  
  res <- fd.estim.boxcount(chl,nlags = "auto") ####actually calculating the fractal dimension
  fdim[k] <- res$fd
  
  print(k)
  
}


#####the results are stored in the vector 'fdim'
####'nas' refers to the number of NAs that were filled in
####'range' is the range of values within the time series


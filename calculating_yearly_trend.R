

require(abind)
require(fractaldim)

load("sample.Rdata") ####A dataset of 5000 chl-a concentration time series
load("sample_loc.Rdata") ####Location (Lat-lon) of the time series in the dataset


calc_sens_slopes <- function(ts, no.trials){   ####this function performs the calculation
  
  diff <- diff(ts)
  
  if(length(which(is.na(diff))) + 100 < length(diff)) {
    
    value1 <- runif(no.trials, min = 0.01, max = 0.5)
    value2 <- runif(no.trials, min = 0.01, max = 0.5)
    scaling <- vector()
    ns <- vector()
    
    for(i in 1:no.trials){
      threshold <- value1[i]*median(ts,na.rm = T)
      no.blooms.1 <- length(which(diff > threshold))
      threshold <- value2[i]*median(ts,na.rm = T)
      no.blooms.2 <- length(which(diff > threshold))
      m <- (value2[i]/value1[i])-1
      N <- (no.blooms.2/no.blooms.1)-1
      scaling[i] <- m
      ns[i] <- N
    }
    
    ns[is.na(log(ns+1))| log(ns+1)=="Inf" | log(ns+1)=="-Inf" ] <- NA
    scaling[is.na(log(scaling+1))| log(scaling+1)=="Inf" | log(scaling+1)=="-Inf" ] <- NA
    
    mod <- lm(formula = log(ns+1)~log(scaling+1))
    return(mod$coefficients[2])
  }
  
  if(length(which(is.na(diff))) + 100 > length(diff)) {
    return(NA)
  }
  if(length(which(is.na(diff))) + 100 == length(diff)) {
    return(NA)
  }
}

fdim_results <- matrix(NA, ncol = 25, nrow = length(sample))
slopes_results <- matrix(NA, ncol = 25, nrow = length(sample))
yearly_mean <- matrix(NA, ncol = 25, nrow = length(sample))
number_outliers <- matrix(NA, ncol = 25, nrow = length(sample))

for(k in 1:length(sample)){
  
  df <- as.data.frame(sample[[k]])
  dates <- df$dates
  years <- unique(substr(dates,1,4))
  
  for(y in 1:25){
    temp <- df[which(substr(dates,1,4) == years[y]),]
    chl <- temp$chl_values
    
    mn <- mean(chl, na.rm = T)
    
    std <- 3*(sd(chl, na.rm = T))
    
    number_outliers[k,y] <- length(chl[which(chl > (mn+std))])
    chl[which(chl > (mn+std))] <- NA
    
    slopes_results[k,y] <- calc_sens_slopes(ts = chl,no.trials = 1000)
    
    if(length(which(is.na(chl))) < 265){
      
      yearly_mean[k,y] <- mean(chl, na.rm = T)
      
      chl[is.na(chl)==TRUE] <- sample(chl[is.na(chl)==FALSE], size = length(chl[is.na(chl) == TRUE]), replace = TRUE)
      
      res <- fd.estim.boxcount(chl,nlags = "auto")
      fdim_results[k,y] <- res$fd
      
      
    }
    
  }
  
  print(k)
  
}

####the results are stored in the vector 'fdim_results' and 'slopes_results'
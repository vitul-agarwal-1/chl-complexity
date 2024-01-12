
#######The following code is designed to calculate the elasticity of an entire dataset of time series######

load("sample.Rdata") ####A dataset of 5000 chl-a concentration time series
load("sample_loc.Rdata") ####Location (Lat-lon) of the time series in the dataset

slopes <- vector()
median_chl <- vector()

calc_sens_slopes <- function(ts, no.trials){   ####this function performs the calculation
  
  diff <- diff(ts)
  
  if(length(which(is.na(diff))) + 400 < length(diff)) {
    
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
  
  if(length(which(is.na(diff))) + 400 > length(diff)) {
    return(NA)
  }
  if(length(which(is.na(diff))) + 400 == length(diff)) {
    return(NA)
  }
}



for(k in 1:length(sample)){  #####loop to automate the calculation for all the time series
  
  df <- as.data.frame(sample[[k]])
  chl <- df$chl_values
  
  slopes[k] <- calc_sens_slopes(ts = chl,no.trials = 1000) ###number of trials determines how many threshold combinations are tested for each time series
  median_chl[k] <- median(chl, na.rm = T)
  
  print(k)
  
}

#####the results are stored in the vector 'slopes', the elasticity metric is the absolute value of 'slopes'
####the median of each time series is stored in 'median_chl'


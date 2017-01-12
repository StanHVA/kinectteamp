#functies definieren.
#Deze functie haalt de tug test uit de volledige data.
afleidenTugTest <- function(Head_y, Foot_right_z)
{
  
  for (i in 1:length(genormaliseerdFoot_z)) {
    if(genormaliseerdFoot_z[i] < drempelWaardeVoet) {
      msNaDrempelWaarde <- i
      break
    }
  }
  
  for (i in msNaDrempelWaarde:1) {
    if(genormaliseerdHead_y[i] < drempelWaardeHoofd) {
      beginTugTest <- i
      break
    }
  }
  
  if( ! exists('beginTugTest') )
  {
    #alternatieve methode nodig.
    return( alternatiefAfleidenTugTest (Head_y, Foot_right_z) ) 
  }
  
  for (i in (beginTugTest+minimumLengteTugTest):length(genormaliseerdHead_y)) {
    if(genormaliseerdHead_y[i] < drempelWaardeHoofd) {
      eindeTugTest <- i
      break
    }
  }
  tugTestTijd <- c(beginTugTest, eindeTugTest)
  return(tugTestTijd)
}

#de alternatieve methode
alternatiefAfleidenTugTest <- function(Head_y, Foot_right_z) {
  
  for (i in length(genormaliseerdFoot_z):1) {
    if(genormaliseerdFoot_z[i] < drempelWaardeVoet) {
      msNaDrempelWaarde <<- i
      break
    }
  }
  
  for (i in msNaDrempelWaarde:length(genormaliseerdFoot_z)) {
    if(genormaliseerdHead_y[i] < drempelWaardeHoofd) {
      eindeTugTest <- i
      break
    }
  }
  
  for (i in (eindeTugTest-minimumLengteTugTest):1) {
    if(genormaliseerdHead_y[i] < drempelWaardeHoofd) {
      beginTugTest <- i
      break
    }
  }
  
  tugTestTijd <- c(beginTugTest, eindeTugTest)
  return(tugTestTijd)
  
}

#posities herkennen functie
herkennenPosities <- function(Head_y, Foot_right_z, tugTestTijd) {
  
  for (i in (tugTestTijd[1]:1)) {
    if(genormaliseerdHead_y[i] > zitHoogteHoofd) {
      beginZitten <- i
      break
    }
  }
  
  if( ! exists('beginZitten') )
  {
    beginZitten <- 0
  }
  
  for (i in (tugTestTijd[1]:tugTestTijd[2])) {
    if(genormaliseerdHead_y[i] > minimumLengtePersoon) {
      beginStaan <- i
      break
    }
  }
  
  for (i in (tugTestTijd[2]:tugTestTijd[1])) {
    if(genormaliseerdHead_y[i] > minimumLengtePersoon) {
      eindStaan <- i
      break
    }
  }
  
  for (i in (tugTestTijd[2]:length(Head_y))) {
    if(genormaliseerdHead_y[i] > zitHoogteHoofd) {
      eindZitten <- i
      break
    }
  }
  if( ! exists('eindZitten') )
  {
    eindZitten <- length(Head_y)
  }
  
  posities <- c(beginZitten, tugTestTijd[1], beginStaan, eindStaan, tugTestTijd[2], eindZitten)
  
  return(posities)
  
}

normalisatie <- function(nietGenormaliseerd){
  
  return( (nietGenormaliseerd - min(nietGenormaliseerd)) / (max(nietGenormaliseerd) - min(nietGenormaliseerd)) )
  
}

verzachteGrafiek <- function(grafiek, waarde = 0.3){
  
  verzacht <- smooth.spline(grafiek, spar = 0.3)$y
  return(verzacht)
  
}


#definieren van drempelwaarden, als de verkeerde data uit de funcie komt kun je deze aanpassen
drempelWaardeVoet <- 0.8
drempelWaardeHoofd <- 0.15
minimumLengtePersoon <- 0.7
minimumLengteTugTest <- 50
minimumZitLengte <- 5
zitHoogteHoofd <- 0.25
meterPerSeconde <- 3.6
tugTestAfstand <- 2*3

#kiezen van dataset
csv <- file.choose()

datacsv <- read.csv(csv)

#data uit dataset halen
Foot_right_z <- datacsv$Foot_right_z
Head_y <- datacsv$Head_y

Foot_right_z <- verzachteGrafiek(Foot_right_z)
Head_y <- smooth.spline(Head_y, spar = 0.3)$y

#zorgen dat alle waarden tussen 0 en 1 zitten, zo is deze functie voor elke test te gebruiken.

genormaliseerdHead_y <- normalisatie(Head_y)
genormaliseerdFoot_z <- normalisatie(Foot_right_z)

tugTestTijd <- afleidenTugTest(genormaliseerdHead_y, genormaliseerdFoot_z)

tugStart <- datacsv$Milliseconds[tugTestTijd[1]]
tugStop <- datacsv$Milliseconds[tugTestTijd[2]]

tugTijd <- (tugStop - tugStart) / 1000

gemiddeldeSnelheid <- ( tugTestAfstand / tugTijd ) * meterPerSeconde


plot((datacsv$Milliseconds/1000), genormaliseerdHead_y)

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

tugTestTijden <-  as.numeric(min(tugTestTijd):max(tugTestTijd))
tugTestTijden <- data.frame(tugTestTijden)

BenodigdeData <- filter(datacsv, datacsv$Milliseconds >= tugStart & datacsv$Milliseconds <= tugStop)
BenodigdeData <- data.frame(BenodigdeData)


#Herkenne positie
  #van 79 naar 1
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

   positie1 <- c(posities[1]:posities[2])
   positie1 <- positie1 - max
   positie1 <- data.frame(positie1)
   positie1$houding <- "beginZitten"
   names(positie1) <- c("TugTestTijd", "Houding")
   
   positie2 <- c(posities[2]:posities[3])
   positie2 <- data.frame(positie2)
   positie2 <- head(positie2, -1)
   positie2$houding <- "opstaan"
   names(positie2) <- c("TugTestTijd", "Houding")
   
   positie3 <- c(posities[3]:posities[4])
   positie3 <- data.frame(positie3)
   positie3 <- head(positie3, -1)
   positie3$houding <- "lopen"
   names(positie3) <- c("TugTestTijd", "Houding")
   
   positie4 <- c(posities[4]:posities[5])
   positie4 <- data.frame(positie4)
   positie4 <- head(positie4, -1)
   positie4$houding <- "gaan zitten"
   names(positie4) <- c("TugTestTijd", "Houding")
   
   positie5 <- c(posities[5]:posities[6])
   positie5 <- data.frame(positie5)
   positie5$houding <- "Zitten"
   names(positie5) <- c("TugTestTijd", "Houding")
  
   
   
  Houdingen <-rbind( positie2, positie3, positie4)
 names(Houdingen) <- c("TugTestTijd", "Houding")
  
  Houdingen <- data.frame(Houdingen)
  
  
 NewDataset <- cbind(BenodigdeData, Houdingen)

 
library(ggplot2)

p = ggplot(NewDataset, aes(y=NewDataset$Head_y, x=NewDataset$Milliseconds, color= NewDataset$Houding))
p + geom_line(size = 2)
#+ scale_size_discrete(range = c(4,6))

Totaletugtesttijd <-  max(NewDataset$Milliseconds) - min(NewDataset$Milliseconds)
Totaletugtesttijd <- Totaletugtesttijd / 1000

if (Totaletugtesttijd < 11) {
print(" U bent gezond")
} else if (Totaletugtesttijd > 10 & Totaletugtesttijd <20 ) {
    print("Goed")
} else {
  print("Laat u onderzoeken")
}
 

  
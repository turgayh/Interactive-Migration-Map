





data_mig <- read.csv("./data/2018-2019_data.csv", header=T)[,1:7]




library(dplyr)

# Group by islands

data_by_island <- data_mig %>%
                 arrange(Islands)%>%
                 group_by(Islands)
             

#Boats arrived

ts_boats <- lapply(1:6, function(i) ts(group_split(data_by_island)[[i]]$Boats.Arrived, start = c(2018,1), end = c(2020,0), frequency = 12) )

#Excluding "5"th element.  It is "Other island"

data_boats <- cbind("Chios"=ts_boats[[1]],"Kos"=ts_boats[[2]], "Leros"=ts_boats[[3]], "Lesvos"=ts_boats[[4]],"Samos"=ts_boats[[6]])
   
dygraph(data_boats)
   

#Total arrivals

ts_arrivals <- lapply(1:6, function(i) ts(group_split(data_by_island)[[i]]$Total.Arrivals, start = c(2018,1), end = c(2020,0), frequency = 12) )

#Excluding "5"th element.  It is "Other island"

data_arrivals <- cbind("Chios"=ts_arrivals[[1]],"Kos"=ts_arrivals[[2]], "Leros"=ts_arrivals[[3]], "Lesvos"=ts_arrivals[[4]],"Samos"=ts_arrivals[[6]])

dygraph(data_arrivals)


#Transfer to mainland

ts_mainland <- lapply(1:6, function(i) ts(group_split(data_by_island)[[i]]$Transfers.to.mainland, start = c(2018,1), end = c(2020,0), frequency = 12) )

#Excluding "5"th element.  It is "Other island"

data_mainland  <- cbind("Chios"=ts_mainland [[1]],"Kos"=ts_mainland [[2]], "Leros"=ts_mainland [[3]], "Lesvos"=ts_mainland [[4]],"Samos"=ts_mainland [[6]])

dygraph(data_mainland)



#Total population

ts_population <- lapply(1:6, function(i) ts(group_split(data_by_island)[[i]]$Total.population, start = c(2018,1), end = c(2020,0), frequency = 12) )

#Excluding "5"th element.  It is "Other island"

data_population  <- cbind("Chios"=ts_population[[1]],"Kos"=ts_population[[2]], "Leros"=ts_population[[3]], "Lesvos"=ts_population[[4]],"Samos"=ts_population[[6]])

dygraph(data_population)





   
   
   


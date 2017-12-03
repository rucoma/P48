library(data.table)
library(zoo)
library(tidyverse)
library(TTR)

p48FinalSal <- rbindlist(mget(ls(pattern = "^p48FinalSal")))

p48FinalSal[, yearmon := as.yearmon(date)]

p48FinalSal <- p48FinalSal[, .(periodoIntervalo = sum(periodoIntervalo)), by = .(CodUP, yearmon)]

setkey(p48FinalSal, CodUP)

p48FinalSal <- tablaUP[p48FinalSal]

columnasFinales <- c("CodUP", "Nombre", "yearmon", "periodoIntervalo")

p48FinalSal <- p48FinalSal[, ..columnasFinales]

p48FinalSal[, Nombre := ifelse(test = is.na(Nombre), yes = "OTRO", no = Nombre)]

p48FinalSal <- p48FinalSal[, .(periodoIntervalo = sum(periodoIntervalo)), by = .(Nombre, yearmon)]

p48FinalSal <- p48FinalSal[, cuota := periodoIntervalo / sum(periodoIntervalo), by = yearmon]

# p48FinalSal <- p48FinalSal[, evol := ROC(x = periodoIntervalo, n = 12), by = Nombre]

# p48FinalSal <- p48FinalSal %>% 
#   mutate(yearmon = as.yearmon(date)) %>% 
#   group_by(yearmon, CodUP) %>% 
#   summarise(energia = sum(periodoIntervalo))
# 
# p48FinalSal <- left_join(x = p48FinalSal, y = tablaUP, by = "CodUP",)

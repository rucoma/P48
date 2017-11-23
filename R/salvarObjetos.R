library(data.table)
library(dplyr)
library(plyr)
library(XML)
library(stringr)

mes <- "201710"
carpeta <- 
  paste0("~/Dropbox/MOOCs/R/P48/XMLFILES/", mes, "/")

carpetaRObjects <- "~/Dropbox/MOOCs/R/P48/RObjects/"

ficheros <- 
  list.files(path = carpeta,
             pattern = "\\.xml")

p48Final    <- data.frame()
p48FinalEnt <- data.frame()
p48FinalSal <- data.frame()

for (fichero in ficheros) {
  
  # Creamos un loop para que recorra todos los ficheros de la carpeta del mes
  print(fichero)
  p48 <- 
    plyr::ldply(XML::xmlToList(paste0(carpeta,
                                      fichero)),
                data.frame,
                sringsAsFactors = F)
  fecha <- as.Date(str_sub(string = p48[1, 2],
                           start = 11,
                           end = 18),
                   format = "%Y%m%d")
  
  colnames(p48)[1] <- "id"
  
  p48 <- p48 %>%
    filter(id == "SeriesTemporales") %>% 
    mutate(date = fecha)
  
  columnasEliminar <- 
    grep(pattern = "Periodo.Intervalo.Pos",
         x = colnames(p48))
  
  columnasNumericas <- 
    colnames(p48)[grep(pattern = "Periodo.Intervalo.Ctd",
                       x = colnames(p48))]
  
  p48 <- p48 %>%
    select(-columnasEliminar)
  
  p48 <- p48 %>%
    mutate_at(.vars = columnasNumericas, .funs = as.numeric)
  
  p48 <- p48 %>%
    mutate(periodoIntervalo = rowSums(.[, columnasNumericas, drop = F]))
  
  columnasNumericas <- 
    grep(pattern = "Periodo.Intervalo.Ctd", 
         x = colnames(p48))
  
  p48 <- p48 %>%
    select(-columnasNumericas)
  
  p48 <- p48 %>%
    select(c("date", "UPEntrada", "UPSalida", "periodoIntervalo"))
  
  p48Ent <- p48 %>% 
    filter(UPEntrada != "NES" & !is.na(UPEntrada)) %>% 
    select(c("date", "UPEntrada", "periodoIntervalo")) %>% 
    mutate(UP = "Entrada")
  
  colnames(p48Ent)[2] <- "CodUP"
  
  p48Sal <- p48 %>% 
    filter(UPSalida != "NES" & !is.na(UPSalida)) %>% 
    select(c("date", "UPSalida", "periodoIntervalo")) %>% 
    mutate(UP = "Salida")
  
  colnames(p48Sal)[2] <- "CodUP"
  
  p48Final    <- rbind(p48Final, p48)
  p48FinalEnt <- rbind(p48FinalEnt, p48Ent)
  p48FinalSal <- rbind(p48FinalSal, p48Sal)
  
}

assign(paste0(deparse(substitute(p48Final)), mes), p48Final)
assign(paste0(deparse(substitute(p48FinalEnt)), mes), p48FinalEnt)
assign(paste0(deparse(substitute(p48FinalSal)), mes), p48FinalSal)

save(list = ls(pattern = mes), # O en vez de mes poner p48Final
     file = paste0(carpetaRObjects, mes, ".RData"))

# rm(list = ls())

objetos <-
  list.files(path = carpetaRObjects,
             full.names = T,
             recursive = T,
             pattern = "\\.RData")

lapply(objetos, load, .GlobalEnv)

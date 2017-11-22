library(data.table)

mes <- "201710"
carpeta         <- "~/Dropbox/MOOCs/R/P48/"
carpetaRObjects <- "~/Dropbox/MOOCs/R/P48/RObjects/"

dt <- 
  data.table(v1 = rnorm(n = 100, mean = 0, sd = 0),
             v2 = rnorm(n = 100, mean = 0, sd = 0),
             v3 = rnorm(n = 100, mean = 0, sd = 0))

assign(paste0(deparse(substitute(dt)), mes), dt)

save(list = ls(pattern = mes), # O en vez de mes poner p48Final
     file = paste0(carpetaRObjects, mes, ".RData"))

rm(list = ls())

objetos <- 
  list.files(path = "~/Dropbox/MOOCs/R/P48/RObjects", 
             full.names = T, 
             recursive = T,
             pattern = "\\.RData")

lapply(objetos, load, .GlobalEnv)

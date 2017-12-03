## Script para extraer las tablas de UP

library(data.table)
library(tidyverse)

carpetaSujetos <- "~/Dropbox/MOOCs/R/P48/SUJETOS/"

uFisicas <- list.files(path = carpetaSujetos, pattern = "export_unidades-fisicas")
sujMercado <- list.files(path = carpetaSujetos, pattern = "export_sujetos-del-mercado")
uProg <- list.files(path = carpetaSujetos, pattern = "export_unidades-de-programacion")

sujetos <- lapply(list(paste0(carpetaSujetos, uFisicas),
                       paste0(carpetaSujetos, sujMercado),
                       paste0(carpetaSujetos, uProg)
                       ),
                  fread,
                  encoding = "UTF-8"
)

names(sujetos) <- c("uFisicas", "sujMercado", "uProg")

colnames(sujetos$sujMercado)[grep(colnames(sujetos$sujMercado), pattern = "Código de sujeto")] <- "Sujeto del Mercado"

tablaUP <- left_join(x = sujetos$uProg,
                y = sujetos$sujMercado[, 1:2],
                by = "Sujeto del Mercado")

colnames(tablaUP)[grep(pattern = "Código de UP", x = colnames(tablaUP))] <- "CodUP"

setDT(tablaUP)

setkey(x = tablaUP, CodUP)

rm(list = c("carpetaSujetos", "uFisicas", "sujMercado", "uProg"))

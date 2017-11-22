library(data.table)

mes <- "201711"

dt <- data.table(v1 = rnorm(n = 100, mean = 0, sd = 0),
                 v2 = rnorm(n = 100, mean = 0, sd = 0),
                 v3 = rnorm(n = 100, mean = 0, sd = 0))

assign(paste0(deparse(substitute(dt)), mes), dt)

save(list = ls(pattern = "2017"),
     file = )


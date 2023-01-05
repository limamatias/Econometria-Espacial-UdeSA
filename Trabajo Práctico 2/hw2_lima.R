# Homework 2: Selección de modelos espaciales
# Materia: Econometría Espacial
# Profesor: Marcos Herrera Gómez
# Alumno: Matías Lima

rm(list=ls())

library(R.matlab)
library(spdep)
library(spatialreg)
library(rgdal)
options("rgdal_show_exportToProj4_warnings"="none")


setwd("C:/Maestría UdeSA/Materias UdeSA/Econometría Espacial/Homework/HW2/")


data <- readMat("mystery_process.mat")
w <- data$W
w_lista <- mat2listw(w, style = "W")

### De lo particular a lo general:

# 0. OLS
reg.ols <- lm(y ~ x1 + x2, data=data)
summary(reg.ols)

lm.morantest(reg.ols,w_lista, alternative = "two.sided")

lms <- lm.LMtests(reg.ols, w_lista, test = "all")
tests1 <- t(sapply(lms, function(x) c(x$statistic, x$parameter, x$p.value)))
colnames(tests1) <- c("Test","df","p-valor")
printCoefmat(tests1)

# 1. SLX

reg.slx <- lm(y ~ x1 + x2 + wx1 + wx2, data=data)
summary(reg.slx)

lm.morantest(reg.slx,w_lista, alternative = "two.sided")

lms <- lm.LMtests(reg.slx, w_lista, test = "all")
tests2 <- t(sapply(lms, function(x) c(x$statistic, x$parameter, x$p.value)))
colnames(tests2) <- c("Test","df","p-valor")
printCoefmat(tests2)

# 2. SEM

reg.sem <- spatialreg::errorsarlm(y ~ x1 + x2, data=data, w_lista)
summary(reg.sem)

#3. SDEM

reg.sdem <- spatialreg::errorsarlm(y ~ x1 + x2, Durbin=~x1 + x2, data=data, w_lista, etype = "emixed")
summary(reg.sdem)

### De lo general a lo particular

# Modelo SDM

reg.sdm <- spatialreg::lagsarlm(y ~ x1 + x2, Durbin=~x1 + x2, data=data, w_lista, type = "mixed")
summary(reg.sdm)

# Sumo SLM para poder comparar contra SDM.

reg.slm <- spatialreg::lagsarlm(y ~ x1 + x2, data=data, w_lista)
summary(reg.slm)

# Tests LR para ver si se reduce el modelo, partiendo desde SDM.
LR.Sarlm(reg.sdm,reg.slm)
LR.Sarlm(reg.sdm,reg.sem)
LR.Sarlm(reg.sdm,reg.slx)

# Sumo SARAR para comparar ajuste contra SDEM y SDM.

reg.sarar <- spatialreg::sacsarlm(y ~ x1 + x2, data=data, w_lista)
summary(reg.sarar)
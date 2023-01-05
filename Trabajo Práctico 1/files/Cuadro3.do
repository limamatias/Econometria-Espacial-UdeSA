
global myFolder "C:/Maestría UdeSA/Materias UdeSA/Econometría Espacial/Homework/HW1"


import dbase "${myFolder}/locales_rob_com_obel.dbf", clear

outreg2 using cuadro3, tex replace sum(log) eqkeep(mean median sd min max) keep(robos_500m dist_comis dist_obel)


correlate LN_PR_USD robos_500m dist_comis dist_obel

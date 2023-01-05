import delimited "/Users/camilasury/Desktop/Econometría Espacial /localesventa18posgar6/tablastata.csv", encoding(ISO-8859-1)

encode barrio_2, gen(barrio)

gen outliers=1 if lisa_cl>=3
replace outliers=0 if lisa_cl<3

xtreg ln_pr_usd antig_ m2total ambientes banos robos_500m dist_comis dist_obel outliers, fe i(barrio)

outreg2 using regresion5.xls, replace tex

predict residuals5, residuals 

export delimited using "/Users/camilasury/Desktop/Econometría Espacial /localesventa18posgar6/punto5.csv", replace

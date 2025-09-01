install.packages("pacman")
library(pacman)
p_load(readr,rio,tidyverse,skimr,visdat, corrplot,stargazer, scales, haven)  


# Importar datos de GitHub
geih_data <- read_csv("https://raw.githubusercontent.com/9marlon9/ProblemSet1/refs/heads/main/geih_data/GEIH2018_filterVariab.csv")

#Análisis descriptivo (variable de salario por hora):

skim(geih_data$y_salary_m_hu)
#14.676 missing 
#7.949 salario promedio por hora
#11.607 desviación
#Mediana: 4.476
#Min: 152
#Max: 291.667

ggplot(geih_data, aes(x = y_salary_m_hu)) +
  geom_histogram(bins = 30, fill = "steelblue", na.rm = TRUE) +
  labs(title = "Distribución de Salario",
       x = "Salario ",
       y = "Frecuencia") +
  scale_x_continuous(labels = comma)

#Debido a la asimetría positiva deberíamos imputar por mediana (4476)

mediana <- median(geih_data$y_salary_m_hu, na.rm = TRUE)


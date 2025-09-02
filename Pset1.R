install.packages("pacman")
library(pacman)
p_load(readr,rio,tidyverse,skimr,visdat, corrplot,stargazer, scales, haven)  


# Importar datos de GitHub
geih_data <- read_csv("https://raw.githubusercontent.com/9marlon9/ProblemSet1/refs/heads/main/geih_data/GEIH2018_filterVariab.csv")

#Análisis descriptivo (variable de salario por hora):

skim(geih_data$y_salary_m_hu)
#6.650 missing 
#7.946 salario promedio por hora
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
media <- mean(geih_data$y_salary_m_hu,na.rm = TRUE)
mediana <- median(geih_data$y_salary_m_hu, na.rm = TRUE)

names(geih_data)
ggplot(geih_data, aes(x = y_salary_m_hu)) +
  geom_histogram(bins = 30, fill = "steelblue", na.rm = TRUE) +
  geom_vline(aes(xintercept = media), color = "red", linetype = "solid", linewidth = 1) +
  geom_vline(aes(xintercept = mediana), color = "green", linetype = "dashed", linewidth = 1) +
  # Escala personalizada para mostrar media y mediana en eje X
  scale_x_continuous(
    labels = scales::comma,
    breaks = sort(c(seq(0, max(geih_data$y_salary_m_hu, na.rm = TRUE), by = 5000),
                    media, mediana))  # Agrega valores al eje
  ) +
  ggplot2::labs(title = "Distribución de Salario (en miles)",
                x = "Salario (miles)",
                y = "Frecuencia") +
  # Rotar texto para mejor visualización
  ggplot2::theme(axis.text.x = element_text(angle = 45, hjust = 1))

skim(geih_data$totalhoursworked)
min(geih_data$totalhoursworked)

#Análisis de missing values

names(geih_data)

#Método de imputación (opción 1):
#Debido a la asimetría positiva, se imputa con base a la mediana.

geih_data_i <- geih_data %>%
  mutate(y_salary_m_hu_i = ifelse(is.na(y_salary_m_hu), 
                                 median(y_salary_m_hu, na.rm = TRUE), 
                                 y_salary_m_hu))

geih_data_i %>% select(y_salary_m_hu,y_salary_m_hu_i) %>% view()

skim(geih_data_i$clase)

sum(geih_data_i$clase == 0, na.rm = TRUE)

#Punto 3


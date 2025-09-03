# 0. Configuación inicial ===============================================

install.packages("pacman")
library(pacman)
p_load(readr,rio,tidyverse,skimr,visdat, corrplot,stargazer, scales, haven)  

# 1. Importación de datos GitHub ========================================

geih_data <- read_csv("https://raw.githubusercontent.com/9marlon9/ProblemSet1/refs/heads/main/geih_data/GEIH2018_filterVariab.csv")

# 2. Análisis descriptivo de la base =====================================

#Variables en la base:
names(geih_data)


# 3. Variable explicada (Y) (Salario por hora) ================================

skim(geih_data$y_salary_m_hu)
#6.650 missing 
#7.946 salario promedio por hora
#11.607 desviación
#Mediana: 4.476
#Min: 152
#Max: 291.667

media <- mean(geih_data$y_salary_m_hu,na.rm = TRUE)
mediana <- median(geih_data$y_salary_m_hu, na.rm = TRUE)

#Distribución del salario por hora:

ggplot(geih_data, aes(x = y_salary_m_hu)) +
  geom_histogram(bins = 30, fill = "steelblue", na.rm = TRUE) +
  labs(title = "Distribución de Salario",
       x = "Salario ",
       y = "Frecuencia") +
  scale_x_continuous(labels = comma)

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

# 4. Variables explicativas==========================================

#4.1 Totalhoursworked
skim(geih_data$totalhoursworked)
min(geih_data$totalhoursworked)

# 0. Configuación inicial ===============================================

install.packages("pacman")
library(pacman)
library(dplyr)
p_load(readr,rio,tidyverse,skimr,visdat, corrplot,stargazer, scales, haven, dplyr)  

# 1. Importación de datos GitHub ========================================

geih_data <- read_csv("https://raw.githubusercontent.com/9marlon9/ProblemSet1/refs/heads/main/geih_data/GEIH2018_filterVariab.csv")

# 2. Análisis descriptivo de la base =====================================

#Variables en la base:
names(geih_data)

geih_data <- geih_data %>% 
  rename(Experiencia = p6426)


#Mantener salarios positivos. 

geih_data <- subset(geih_data, y_salary_m_hu > 0)



# 3. Variable explicada (Y) (Salario por hora) ================================

skim(geih_data$y_salary_m_hu)
#6.650 missing 
#7.946 salario promedio por hora
#11.607 desviación
#Mediana: 4.476
#Min: 152
#Max: 291.667

skim(geih_data$y_inglab_m_ha)


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

skim(geih_data$maxeduclevel)

#Tratamiento de datos del regimen de salud

ggplot(geih_data, aes(x = regsalud)) +
  geom_histogram(bins = 30, fill = "steelblue", na.rm = TRUE) +
  labs(title = "Distribución del regimen de salud",
       x = "Tipo ",
       y = "Frecuencia") +
  scale_x_continuous(labels = comma)

# calculamos el valor más común de regsalud. 
mode_reg <- as.numeric(names(sort(table(geih_data$regsalud), decreasing = TRUE)[1]))

# imputación de datos faltantes 
geih_data <- geih_data  %>%
  mutate(regsalud = ifelse(is.na(regsalud) == TRUE, mode_reg , regsalud))
skim(geih_data$regsalud)

#Tipo de vinculación#

skim(geih_data$relab)

ggplot(geih_data, aes(x = relab)) +
  geom_histogram(bins = 30, fill = "steelblue", na.rm = TRUE) +
  labs(title = "Distribución del regimen de salud",
       x = "Tipo ",
       y = "Frecuencia") +
  scale_x_continuous(labels = comma)

#Es formal o informal#

skim(geih_data$formal)

ggplot(geih_data, aes(x = formal)) +
  geom_histogram(bins = 30, fill = "steelblue", na.rm = TRUE) +
  labs(title = "Distribución de formalidad",
       x = "Tipo ",
       y = "Frecuencia") +
  scale_x_continuous(labels = comma)


ggplot(geih_data, aes(x = sizefirm)) +
  geom_histogram(bins = 30, fill = "steelblue", na.rm = TRUE) +
  labs(title = "Distribución del tamaño de la firma",
       x = "Tipo ",
       y = "Frecuencia") +
  scale_x_continuous(labels = comma)


#Experiencia, frecuencia en meses#
#Transformación de la variable de meses a años#

geih_data$Experiencia <- geih_data$Experiencia / 12

skim(geih_data$Experiencia)


max(geih_data$Experiencia)


ggplot(geih_data, aes(x = Experiencia)) +
  geom_histogram(bins = 30, fill = "steelblue", na.rm = TRUE) +
  labs(title = "Distribución de experiencia",
       x = "Tipo ",
       y = "Frecuencia") +
  scale_x_continuous(labels = comma)

p95 <- quantile(geih_data$Experiencia, 0.95, na.rm = TRUE)

ggplot(geih_data, aes(x = Experiencia)) +
  geom_histogram(bins = 30, fill = "steelblue", na.rm = TRUE) +
  labs(title = "Distribución de experiencia",
       x = "Tipo",
       y = "Frecuencia") +
  scale_x_continuous(labels = comma) +
  coord_cartesian(xlim = c(0, p95)) 

skim(geih_data$totalhoursworked)


ggplot(geih_data, aes(x = totalhoursworked)) +
  geom_histogram(bins = 30, fill = "steelblue", na.rm = TRUE) +
  labs(title = "Distribución de experiencia",
       x = "Tipo ",
       y = "Frecuencia") +
  scale_x_continuous(labels = comma)
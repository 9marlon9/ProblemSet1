import pandas as pd
import requests
from bs4 import BeautifulSoup
import os
from io import StringIO

BASE_URL = "https://ignaciomsarmiento.github.io/GEIH2018_sample/pages/geih_page_{}.html"
OUTPUT_FOLDER = "geih_data"
os.makedirs(OUTPUT_FOLDER, exist_ok=True)

def leer_pagina(i):
    """Lee una página y extrae la tabla HTML como DataFrame"""
    try:
        url = BASE_URL.format(i)
        print(f"Leyendo: {url}")
        
        # Descargar y parsear HTML
        response = requests.get(url)
        soup = BeautifulSoup(response.text, 'html.parser')
        
        # Encontrar todas las tablas
        tables = soup.find_all('table')
        if not tables:
            return None
        
        # Convertir la primera tabla a DataFrame
        df = pd.read_html(StringIO(str(tables[0])))[0]
        
        # Limpiar nombres de columnas (como janitor::clean_names)
        df.columns = [col.lower().replace(' ', '_') for col in df.columns]
        
        return df
        
    except Exception as e:
        print(f"Error leyendo página {i}: {e}")
        return None

# Leer las 10 páginas
dataframes = []
for i in range(1, 11):
    df = leer_pagina(i)
    if df is not None:
        dataframes.append(df)

# Combinar todos los DataFrames
if dataframes:
    geih_df = pd.concat(dataframes, ignore_index=True)
    print(f"Dataset combinado: {geih_df.shape[0]} filas, {geih_df.shape[1]} columnas")
    
    # Guardar en CSV
    csv_path = os.path.join(OUTPUT_FOLDER, "GEIH2018_completo.csv")
    geih_df.to_csv(csv_path, index=False, encoding='utf-8')
    print(f"Datos guardados en: {csv_path}")
    
    # Mostrar información básica
    print("\nPrimeras filas:")
    print(geih_df.head())
    print("\nInfo del dataset:")
    print(geih_df.info())
    
else:
    print("No se pudieron leer datos de ninguna página")

# =============================================================================
# 2. LIMPIEZA Y PREPROCESAMIENTO DE DATOS
# =============================================================================
import pandas as pd
import os

def filter_age_ge_18_and_employed(input_path, output_path):
    # Leer el archivo CSV
    df = pd.read_csv(input_path)
    
    # Filtrar: edad >= 18 Y empleados (ocu == 1)
    df_filtered = df[(df['age'] >= 18) & (df['ocu'] == 1)]
    
    # Crear directorio si no existe
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    
    # Guardar el resultado
    df_filtered.to_csv(output_path, index=False)
    print(f"Archivo filtrado guardado en: {output_path}")
    print(f"Filas originales: {len(df)}")
    print(f"Filas después del filtro: {len(df_filtered)}")

if __name__ == "__main__":
    input_csv = "geih_data/GEIH2018_completo.csv"
    output_csv = "geih_data/GEIH2018_age_employed_filtered.csv"
    filter_age_ge_18_and_employed(input_csv, output_csv)


# =============================================================================
# 2. Base de datos con variables relevantes
# =============================================================================
import pandas as pd
# Variables que quieres conservar
variables = ['y_salary_m_hu', 'y_inglab_m_ha', 'estrato1','sex', 'age','regsalud', 'maxeduclevel', 'p6426', 'sizefirm','totalhoursworked', 'relab', 'formal']

# Leer el CSV filtrado y conservar solo las variables especificadas
df = pd.read_csv("geih_data/GEIH2018_age_employed_filtered.csv")
df_filtered = df[variables]

# Guardar el nuevo CSV con solo las variables seleccionadas
df_filtered.to_csv("geih_data/GEIH2018_filterVariab.csv", index=False)




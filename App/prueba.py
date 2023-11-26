import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd 

df = pd.read_csv("./dataset/HCV-Egy-Data.csv")
fig, ax = plt.subplots(figsize=(12, 6))

print(df.columns)

df_plot = df.head(10)
fig.set_facecolor('lightgray') 
ax.set_facecolor('gray')
x = ['AST 1', 'ALT 1', 'ALT 4', 'ALT 12', 'ALT 24', 'ALT 36', 'ALT 48', "Baselinehistological staging"]
df_subset = df[x]


colores = sns.light_palette("red", n_colors=len(x))

for index, row in df_subset.iterrows():
    y = row.to_list()  # Eje X
    color = colores[0] 
    plt.plot(x, y, marker='o', color=color)
 
# Etiquetas de los ejes
plt.xlabel('Instancias')
plt.ylabel('Nombres de las Columnas')
 
# Título del gráfico
plt.title('Gráfico Temporal con Baseline Stage')
 
etiquetas = [f'{nivel}' for nivel in ["F0", "F1", "F2", "F3", "F4"]]
plt.legend(etiquetas, loc='upper right')
 
 
# Mostrar el gráfico
plt.grid(True)
plt.show()
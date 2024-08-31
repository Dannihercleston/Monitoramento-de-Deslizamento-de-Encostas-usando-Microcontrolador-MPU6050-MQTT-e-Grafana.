import pandas as pd


df = pd.read_csv("/home/livia/Documentos/integrador/Monitoramento-de-Deslizamento-de-Encostas-usando-Microcontrolador-MPU6050-MQTT-e-Grafana./teorema_chebyshev/query(1).csv")  


df.columns = ['group', 'false', 'false.1', 'true', 'true.1', 'false.2', 'false.3', 'true.2', 'true.3', 'true.4', 'true.5']



df = df[['true', 'true.1', 'false.2', 'false.3', 'true.2']]  


df.columns = ['start', 'stop', 'time', 'value', 'field']


output_file = 'dados_filtrados.csv'
df.to_csv(output_file, index=False)

print(f"Arquivo CSV salvo como '{output_file}'")
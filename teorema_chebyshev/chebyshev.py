import numpy as np
import pandas as pd
from scipy.signal import butter, filtfilt

# Carregar o CSV
df = pd.read_csv("/home/livia/Documentos/sensor/Monitoramento-de-Deslizamento-de-Encostas-usando-Microcontrolador-MPU6050-MQTT-e-Grafana./teorema_chebyshev/dados_filtrados3108.csv")
df.columns = ['start', 'stop', 'time', 'value', 'field']
df['value'] = pd.to_numeric(df['value'], errors='coerce')

# Função de filtragem
def aplicar_filtro_butter(dados, cutoff=0.1, ordem=4):
    b, a = butter(ordem, cutoff, btype='low', analog=False)
    return filtfilt(b, a, dados)

eixos = df['field'].unique()
resultados = []

for eixo in eixos:
    dados_eixo = df[df['field'] == eixo]['value'].dropna().to_numpy()
    
    if len(dados_eixo) == 0:
        continue

    dados_filtrados = aplicar_filtro_butter(dados_eixo)
    
    media = np.mean(dados_filtrados)
    desvio_padrao = np.std(dados_filtrados, ddof=1)
    k = 2
    proporcao_minima = 1 - (1 / k**2)

    intervalo_inf = media - k * desvio_padrao
    intervalo_sup = media + k * desvio_padrao

    dados_fora_do_intervalo = dados_filtrados[(dados_filtrados < intervalo_inf) | (dados_filtrados > intervalo_sup)]

    resultados.append({
        'eixo': eixo,
        'média': media,
        'desvio padrão': desvio_padrao,
        'proporção mínima dentro de 2 desvios padrão': proporcao_minima,
        'intervalo inferior': intervalo_inf,
        'intervalo superior': intervalo_sup,
        'dados fora do intervalo': dados_fora_do_intervalo.tolist()
    })

# Converter a lista de resultados em um DataFrame
resultados_df = pd.DataFrame(resultados)
resultados_df.to_csv('/home/livia/Documentos/sensor/Monitoramento-de-Deslizamento-de-Encostas-usando-Microcontrolador-MPU6050-MQTT-e-Grafana./teorema_chebyshev/regrausada', index=False)

for resultado in resultados:
    print(f"{resultado['eixo']}:")
    print(f"  Média: {resultado['média']:.4f}")
    print(f"  Desvio padrão: {resultado['desvio padrão']:.4f}")
    print(f"  Proporção mínima de dados dentro de 2 desvios padrão: {resultado['proporção mínima dentro de 2 desvios padrão']:.2f}")
    print(f"  Intervalo: [{resultado['intervalo inferior']:.4f}, {resultado['intervalo superior']:.4f}]")
    print(f"  Dados fora do intervalo: {resultado['dados fora do intervalo']}")
    print()

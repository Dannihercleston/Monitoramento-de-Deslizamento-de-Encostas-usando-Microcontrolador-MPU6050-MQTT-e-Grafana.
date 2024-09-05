import pandas as pd
import matplotlib.pyplot as plt

# Carregar os dados do arquivo CSV
dados_filtrados = pd.read_csv('/home/livia/Desktop/teste/comprovando/dados_filtrados2hfk.csv')

# Verificar os nomes das colunas para garantir que estamos acessando corretamente
print(dados_filtrados.columns)

# Converter a coluna '_time' para datetime usando inferência automática
dados_filtrados['_time'] = pd.to_datetime(dados_filtrados['_time'], errors='coerce')

# Remover linhas onde a conversão falhou
dados_filtrados = dados_filtrados.dropna(subset=['_time'])

# Garantir que as datas não têm timezone
dados_filtrados['_time'] = dados_filtrados['_time'].dt.tz_localize(None)

# Verificar se ainda há valores NaT após a limpeza
print(f'Número de entradas NaT após limpeza: {dados_filtrados["_time"].isna().sum()}')

# Filtrar os dados para cada eixo
dados_ax = dados_filtrados[dados_filtrados['_field'] == 'ax']
dados_ay = dados_filtrados[dados_filtrados['_field'] == 'ay']
dados_az = dados_filtrados[dados_filtrados['_field'] == 'az']
dados_gx = dados_filtrados[dados_filtrados['_field'] == 'gx']
dados_gy = dados_filtrados[dados_filtrados['_field'] == 'gy']
dados_gz = dados_filtrados[dados_filtrados['_field'] == 'gz']

# Criar uma figura com subgráficos para cada eixo
fig, axs = plt.subplots(6, 1, figsize=(14, 18), sharex=True)

# Configurar subgráficos
axs[0].plot(dados_ax['_time'], dados_ax['_value'], color='blue')
axs[0].set_title('Eixo AX')
axs[0].set_ylabel('Valor')
axs[0].grid(True)

axs[1].plot(dados_ay['_time'], dados_ay['_value'], color='green')
axs[1].set_title('Eixo AY')
axs[1].set_ylabel('Valor')
axs[1].grid(True)

axs[2].plot(dados_az['_time'], dados_az['_value'], color='red')
axs[2].set_title('Eixo AZ')
axs[2].set_ylabel('Valor')
axs[2].grid(True)

axs[3].plot(dados_gx['_time'], dados_gx['_value'], color='purple')
axs[3].set_title('Eixo GX')
axs[3].set_ylabel('Valor')
axs[3].grid(True)

axs[4].plot(dados_gy['_time'], dados_gy['_value'], color='orange')
axs[4].set_title('Eixo GY')
axs[4].set_ylabel('Valor')
axs[4].grid(True)

axs[5].plot(dados_gz['_time'], dados_gz['_value'], color='brown')
axs[5].set_title('Eixo GZ')
axs[5].set_xlabel('Tempo')
axs[5].set_ylabel('Valor')
axs[5].grid(True)

# Ajustar o layout
plt.tight_layout()

# Salvar o gráfico como um arquivo PNG
plt.savefig('/home/livia/Desktop/teste/comprovando/grafico_detalhado.png', dpi=300)

# Exibir o gráfico
plt.show()

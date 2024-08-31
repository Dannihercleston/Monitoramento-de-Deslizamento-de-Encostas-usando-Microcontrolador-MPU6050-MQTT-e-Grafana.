from influxdb_client import InfluxDBClient
import requests
import time
from datetime import datetime, timedelta, timezone
import numpy as np

# Configurações do InfluxDB
token = "PsUAIrOkU250KbfW8Vcf8PXr-BXNmxvfJYuJZ9BTaypY4lbyJsDCPUr9pqK5jjAA1y6_23Ocs8hrP4zR4hnyKQ=="
org = "Monitoramento de Encostas"
bucket = "Dados"
url = "http://localhost:8086"  # ou o URL do seu servidor InfluxDB

# Configurações do Telegram
telegram_bot_token = '7507857581:AAGG40ghZg7U8k-XcuGwQK-sh77kPJ1CJTs'
telegram_chat_id = '-4512529076'

# Limites para desvio padrão
limites_desvio_padrao = {
    "ax": 0.0040,
    "ay": 0.0043,
    "az": 0.0098,
    "gx": 0.0007,
    "gy": 0.0002,
    "gz": 0.0009,
    "temp": 0.5  # Adicione um limite para a temperatura, se necessário
}

# Função para enviar alerta para o Telegram
def send_telegram_alert(message):
    url = f'https://api.telegram.org/bot{telegram_bot_token}/sendMessage'
    data = {'chat_id': telegram_chat_id, 'text': message}
    response = requests.post(url, data=data)
    print("Resposta da API do Telegram:", response.text)  # Depuração
    if response.status_code == 200:
        print("Alerta enviado com sucesso!")
    else:
        print("Falha ao enviar alerta. Status code:", response.status_code)
        print("Resposta:", response.text)

# Conexão ao InfluxDB
client = InfluxDBClient(url=url, token=token, org=org)
query_api = client.query_api()

# Função para obter o intervalo de tempo para a query
def get_time_range():
    now = datetime.now(timezone.utc)
    start_time = now - timedelta(minutes=1)  # Ajuste conforme necessário
    return start_time.isoformat(), now.isoformat()

# Exemplo de query para monitorar um campo específico
def get_query(start_time, end_time):
    return f'''
    from(bucket: "{bucket}")
    |> range(start: {start_time}, stop: {end_time})
    |> filter(fn: (r) => r["_measurement"] == "mqtt_consumer")
    |> filter(fn: (r) => r["_field"] == "ax" or r["_field"] == "ay" or r["_field"] == "az" or r["_field"] == "gx" or r["_field"] == "gy" or r["_field"] == "gz" or r["_field"] == "temp")
    |> yield(name: "mean")
    '''

# Função principal para monitoramento
def monitorar_dados():
    start_time, end_time = get_time_range()
    query = get_query(start_time, end_time)
    print("Consultando InfluxDB com a query:")
    print(query)
    
    try:
        tables = query_api.query(query)
        if not tables:
            print("Nenhuma tabela retornada.")
            return
        
        dados = {eixo: [] for eixo in limites_desvio_padrao.keys()}
        
        for table in tables:
            print(f"Processando tabela com {len(table.records)} registros.")
            for record in table.records:
                campo = record.get_field()
                if campo in dados:
                    valor = record.get_value()
                    dados[campo].append(valor)
        
        for eixo, valores in dados.items():
            if valores:
                media = np.mean(valores)
                desvio_padrao = np.std(valores, ddof=1)  # Usar ddof=1 para amostra
                k = 2
                intervalo_inf = media - k * desvio_padrao
                intervalo_sup = media + k * desvio_padrao
                
                dados_fora_do_intervalo = [v for v in valores if v < intervalo_inf or v > intervalo_sup]
                
                print(f"Dados coletados para {eixo}: {valores}")
                print(f"Média: {media:.4f}")
                print(f"Desvio padrão calculado: {desvio_padrao:.4f}")
                print(f"Intervalo: [{intervalo_inf:.4f}, {intervalo_sup:.4f}]")
                print(f"Dados fora do intervalo: {dados_fora_do_intervalo}")
                
                if dados_fora_do_intervalo:
                    message = f'Alerta: {len(dados_fora_do_intervalo)} valores do eixo {eixo} estão fora do intervalo calculado de Chebyshev ({intervalo_inf:.4f} a {intervalo_sup:.4f}).'
                    send_telegram_alert(message)
                    
    except Exception as e:
        print("Erro ao consultar o InfluxDB:", e)

# Loop de monitoramento
while True:
    monitorar_dados()
    time.sleep(60)  # Espera 60 segundos antes de fazer a próxima consulta
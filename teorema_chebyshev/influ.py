from influxdb_client import InfluxDBClient
import csv

#Codigo para coletar os dados do bucket no InfluxDB e transforma em .csv


url = "http://localhost:8086"
token = ""
org = "Monitoramento de Encostas"  # Nome da organização
bucket = "Dados"  # Nome do bucket

# Conectando ao InfluxDB
client = InfluxDBClient(url=url, token=token)

def exportar_influxdb_para_csv():
    # Defina sua consulta Flux
    query = f'''
    from(bucket: "{bucket}")
    |> range(start: -1y)
    |> filter(fn: (r) => r["_measurement"] == "mqtt_consumer")
    |> filter(fn: (r) => r["_field"] == "ax" or r["_field"] == "az" or r["_field"] == "ay" or r["_field"] == "gx" or r["_field"] == "gy" or r["_field"] == "gz" or r["_field"] == "temp")
    |> aggregateWindow(every: 1m, fn: mean, createEmpty: false)
    '''

    try:
        # Executar a consulta
        tables = client.query_api().query(query, org=org)
        
        # Nome do arquivo CSV
        nome_arquivo_csv = "dados_influxdb.csv"

        # Abrir arquivo CSV para escrita
        with open(nome_arquivo_csv, mode='w', newline='', encoding='utf-8') as arquivo_csv:
            writer = csv.writer(arquivo_csv)
            
            # Definir cabeçalho
            header = ["_time", "_measurement", "_field", "_value"]
            writer.writerow(header)
            
            # Iterar sobre os registros e escrever no CSV
            for table in tables:
                for record in table.records:
                    row = [
                        record.get_time(),
                        record.get_measurement(),
                        record.get_field(),
                        record.get_value(),
                    ]
                    writer.writerow(row)
        
        print(f"Dados exportados para {nome_arquivo_csv}")
    
    except Exception as e:
        print(f"Erro ao exportar dados: {e}")

# Executar a exportação
exportar_influxdb_para_csv()

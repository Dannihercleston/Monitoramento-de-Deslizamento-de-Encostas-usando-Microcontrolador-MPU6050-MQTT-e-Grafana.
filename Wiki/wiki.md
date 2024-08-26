# Documentação do Projeto

Os sistemas do projeto "Monitoramento de Encostas usando Microcontrolador, MPU6050, MQTT e Grafana" incluem um arquivo Docker Compose para o provisionamento dos containers do InfluxDB, Telegraf, MQTT e Grafana. Além disso, o projeto utiliza um sensor MPU6050, um microcontrolador ESP32, uma protoboard, uma bateria de 9V e jumpers.

<pre> Arquitetura do projeto: </pre> 
 ![arquitetura_projeto](/Wiki/imagens_projeto/arquitetura.jpeg)


<pre>
Protoboard e Codigo ino
</pre>

Antes de mais nada, é necessário conectar o sensor MPU6050, ESP32 ao protoboard e a pilha de 9V ao protoboard. Depois, inserir o codigo ino na sketch do programa arduino. Para o codigo se comunicar com o microcontrolador, deve ser baixado algumas bibliotecas, incluido "adafruit_sensor", adafruit_MPU6050" e "pubsubclient".


<pre>
Criando os Containers
</pre>


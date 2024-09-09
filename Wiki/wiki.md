# Documentação do Projeto

Os sistemas do projeto "Monitoramento de Encostas usando Microcontrolador, MPU6050, MQTT e Grafana" incluem um arquivo Docker Compose para o provisionamento dos containers do InfluxDB, Telegraf, MQTT e Grafana. Além disso, o projeto utiliza um sensor MPU6050, um microcontrolador ESP32, uma protoboard, uma bateria de 9V e jumpers.

<pre> Arquitetura do projeto: </pre> 
 ![arquitetura_projeto](/Wiki/imagens_projeto/arquitetura.jpeg)


<pre>
Protoboard e Codigo ino
</pre>

Antes de mais nada, é necessário conectar o sensor MPU6050, ESP32 ao protoboard e a pilha de 9V ao protoboard. Depois, inserir o codigo ino na sketch do programa arduino. Para o codigo se comunicar com o microcontrolador, deve ser baixado algumas bibliotecas, incluido "adafruit_sensor", adafruit_MPU6050" e "pubsubclient".

###########################################################################################################################

<pre>
Criando os Containers
</pre>

Para iniciar os contêineres, navegue até o diretório onde o arquivo docker-compose.yml está localizado, utilizando o terminal ou a IDE de sua preferência.

Em seguida, execute o seguinte comando:

<pre>
docker compose up -d
</pre>

Após a execução, os contêineres serão iniciados em segundo plano e estarão acessíveis via "localhost" na porta especificada no arquivo de configuração.

###########################################################################################################################

<pre>
Configuração Telegraf e InfluxDB
</pre>

A configuração do Telegraf depende do arquivo telegraf.conf e de um Token de API gerada no InfluxDB. Para obter essa chave, siga os seguintes passos:

    Acesse o InfluxDB e, ao clicar em "Get Started", você será solicitado a preencher informações como:
        Usuário
        Senha
        Organização
        Bucket

    Após fornecer essas informações, você será redirecionado para uma página onde será gerado um Token de API com permissões de administrador. Esse token deverá ser utilizado no arquivo de configuração do Telegraf (telegraf.conf) para autenticação no InfluxDB.

    Após copiar e colar o token, basta reiniciar o container do Telegraf, usando o comando:

        <pre>
            docker compose restart telegraf
        </pre>

Após essa configuração feita, o bucket no InfluxDB já estará recebendo os dados do tópico MQTT.

###########################################################################################################################



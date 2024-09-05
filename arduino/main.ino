#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_MPU6050.h>
#include <WiFi.h>
#include <PubSubClient.h>
#include <SimpleKalmanFilter.h>

// as credenciais da rede WiFi
const char* ssid = "";
const char* password = "";

// informações do broker MQTT local
const char* mqtt_server = "test.mosquitto.org";
const int mqtt_port = 1883;

WiFiClient espClient;
PubSubClient client(espClient);

// Sensor MPU6050
Adafruit_MPU6050 mpu;
sensors_event_t a, g, temp;

// Configuração do filtro de Kalman
SimpleKalmanFilter kalmanFilterAccelX(2, 2, 0.01);
SimpleKalmanFilter kalmanFilterAccelY(2, 2, 0.01);
SimpleKalmanFilter kalmanFilterAccelZ(2, 2, 0.01);
SimpleKalmanFilter kalmanFilterGyroX(2, 2, 0.01);
SimpleKalmanFilter kalmanFilterGyroY(2, 2, 0.01);
SimpleKalmanFilter kalmanFilterGyroZ(2, 2, 0.01);

// Variáveis para dados do sensor
float aceleracaoX, aceleracaoY, aceleracaoZ;
float giroscopioX, giroscopioY, giroscopioZ;
float temperatura;

// Variáveis para dados filtrados
float aceleracaoX_filtrada, aceleracaoY_filtrada, aceleracaoZ_filtrada;
float giroscopioX_filtrado, giroscopioY_filtrado, giroscopioZ_filtrado;

// Intervalo de publicação de dados (ajuste para a frequência desejada em tempo real)
const long intervalo = 1500;  // Enviar dados a cada  milissegundos (50 Hz)

void configurar_wifi() {
  Serial.begin(115200);
  delay(10);

  Serial.print("Conectando à rede WiFi: ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi conectado");
  Serial.print("Endereço IP: ");
  Serial.println(WiFi.localIP());
}

void reconectar() {
  while (!client.connected()) {
    Serial.print("Tentando conexão MQTT...");
    if (client.connect("ClienteESP32")) {
      Serial.println("conectado");
    } else {
      Serial.print("falhou, rc=");
      Serial.print(client.state());
      Serial.println(" tentando novamente em 5 segundos");
      delay(5000);
    }
  }
}

void setup() {
  Wire.begin();

  if (!mpu.begin()) {
    Serial.println("Falha ao inicializar o sensor MPU6050");
    while (1);
  }

  configurar_wifi();
  client.setServer(mqtt_server, mqtt_port);
}

void loop() {
  if (!client.connected()) {
    reconectar();
  }
  client.loop();

  unsigned long millisAtual = millis();
  static unsigned long millisAnterior = 0;

  if (millisAtual - millisAnterior >= intervalo) {
    millisAnterior = millisAtual;

    mpu.getEvent(&a, &g, &temp);

    aceleracaoX = a.acceleration.x;
    aceleracaoY = a.acceleration.y;
    aceleracaoZ = a.acceleration.z;

    giroscopioX = g.gyro.x;
    giroscopioY = g.gyro.y;
    giroscopioZ = g.gyro.z;

    temperatura = temp.temperature;

    // Aplicando o filtro de Kalman nos dados de aceleração
    aceleracaoX_filtrada = kalmanFilterAccelX.updateEstimate(aceleracaoX);
    aceleracaoY_filtrada = kalmanFilterAccelY.updateEstimate(aceleracaoY);
    aceleracaoZ_filtrada = kalmanFilterAccelZ.updateEstimate(aceleracaoZ);

    // Aplicando o filtro de Kalman nos dados de giroscópio
    giroscopioX_filtrado = kalmanFilterGyroX.updateEstimate(giroscopioX);
    giroscopioY_filtrado = kalmanFilterGyroY.updateEstimate(giroscopioY);
    giroscopioZ_filtrado = kalmanFilterGyroZ.updateEstimate(giroscopioZ);

    // Pacote de dados eficiente e publicação única para transmissão mais rápida
    char bufferDadosBrutos[128];
    sprintf(bufferDadosBrutos,
            "{\"ax\":%.2f,\"ay\":%.2f,\"az\":%.2f,"
            "\"gx\":%.2f,\"gy\":%.2f,\"gz\":%.2f,"
            "\"temp\":%.2f}",
            aceleracaoX, aceleracaoY, aceleracaoZ,
            giroscopioX, giroscopioY, giroscopioZ, temperatura);

    char bufferDadosFiltrados[128];
    sprintf(bufferDadosFiltrados,
            "{\"ax\":%.2f,\"ay\":%.2f,\"az\":%.2f,"
            "\"gx\":%.2f,\"gy\":%.2f,\"gz\":%.2f,"
            "\"temp\":%.2f}",
            aceleracaoX_filtrada, aceleracaoY_filtrada, aceleracaoZ_filtrada,
            giroscopioX_filtrado, giroscopioY_filtrado, giroscopioZ_filtrado, temperatura);

    client.publish("Encostas/Mpu6050", bufferDadosBrutos);
    client.publish("Encostas/Kalman", bufferDadosFiltrados);

    Serial.print("Dados brutos enviados: ");
    Serial.println(bufferDadosBrutos);
    Serial.print("Dados filtrados enviados: ");
    Serial.println(bufferDadosFiltrados);
  }
}

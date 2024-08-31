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

// Intervalo de publicação de dados (ajuste para a frequência desejada em tempo real)
const long intervalo = 1500;  // Enviar dados a cada 20 milissegundos (50 Hz)

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

    // Aplicando o filtro de Kalman nos dados de aceleração
    aceleracaoX = kalmanFilterAccelX.updateEstimate(a.acceleration.x);
    aceleracaoY = kalmanFilterAccelY.updateEstimate(a.acceleration.y);
    aceleracaoZ = kalmanFilterAccelZ.updateEstimate(a.acceleration.z);

    // Aplicando o filtro de Kalman nos dados de giroscópio
    giroscopioX = kalmanFilterGyroX.updateEstimate(g.gyro.x);
    giroscopioY = kalmanFilterGyroY.updateEstimate(g.gyro.y);
    giroscopioZ = kalmanFilterGyroZ.updateEstimate(g.gyro.z);

    temperatura = temp.temperature;

    // Pacote de dados eficiente e publicação única para transmissão mais rápida
    char bufferDados[128];  // o tamanho do buffer conforme necessário
    sprintf(bufferDados,
            "{\"ax\":%.2f,\"ay\":%.2f,\"az\":%.2f,"
            "\"gx\":%.2f,\"gy\":%.2f,\"gz\":%.2f,"
            "\"temp\":%.2f}",
            aceleracaoX, aceleracaoY, aceleracaoZ,
            giroscopioX, giroscopioY, giroscopioZ, temperatura);

    client.publish("Encostas/dados", bufferDados);

    Serial.print("Dados enviados: ");
    Serial.println(bufferDados);
  }
}


WiFiClient espClient;
PubSubClient client(espClient);

// Sensor MPU6050
Adafruit_MPU6050 mpu;
sensors_event_t a, g, temp;

// Variáveis para dados do sensor
float aceleracaoX, aceleracaoY, aceleracaoZ;
float giroscopioX, giroscopioY, giroscopioZ;
float temperatura;

// Intervalo de publicação de dados (ajuste para a frequência desejada em tempo real)
const long intervalo = 1500;  // Enviar dados a cada 20 milissegundos (50 Hz)

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

    // Pacote de dados eficiente e publicação única para transmissão mais rápida
    char bufferDados[128];  // o tamanho do buffer conforme necessário
    sprintf(bufferDados,
            "{\"ax\":%.2f,\"ay\":%.2f,\"az\":%.2f,"
            "\"gx\":%.2f,\"gy\":%.2f,\"gz\":%.2f,"
            "\"temp\":%.2f}",
            aceleracaoX, aceleracaoY, aceleracaoZ,
            giroscopioX, giroscopioY, giroscopioZ, temperatura);

    client.publish("Encostas/dados", bufferDados);

    Serial.print("Dados enviados: ");
    Serial.println(bufferDados);
  }
}
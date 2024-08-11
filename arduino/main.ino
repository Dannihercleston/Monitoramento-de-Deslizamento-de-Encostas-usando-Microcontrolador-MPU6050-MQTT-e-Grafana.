#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_MPU6050.h>
#include <WiFi.h>
#include <PubSubClient.h>

// Definir as credenciais da rede WiFi
const char* ssid = "";
const char* password = "";

// Definir as informações do broker MQTT
const char* mqtt_server = "test.mosquitto.org";
const int mqtt_port = 1883;

WiFiClient espClient;
PubSubClient client(espClient);

// Objeto do sensor MPU6050
Adafruit_MPU6050 mpu;

// Variáveis para armazenar os valores do sensor
float accelerometerX, accelerometerY, accelerometerZ;
float gyroX, gyroY, gyroZ;
float temperature;

// Variáveis de controle de tempo para enviar dados em tempo real
unsigned long previousMillis = 0;
unsigned long reconnectMillis = 0;
const long interval = 100; // Intervalo em milissegundos
const long reconnectInterval = 5000; // Intervalo de reconexão em milissegundos

void setup_wifi() {
  delay(10);
  // Conectar-se à rede WiFi
  Serial.println();
  Serial.print("Conectando-se à rede ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi conectado");
  Serial.println("Endereço IP: ");
  Serial.println(WiFi.localIP());
}

void reconnect() {
  // Loop até que o cliente MQTT esteja conectado
  if (!client.connected()) {
    unsigned long currentMillis = millis();
    if (currentMillis - reconnectMillis >= reconnectInterval) {
      reconnectMillis = currentMillis;
      Serial.print("Tentando conectar ao MQTT...");
      if (client.connect("ESP32Client")) {
        Serial.println("Conectado");
      } else {
        Serial.print("falhou, rc=");
        Serial.print(client.state());
        Serial.println(" tentar novamente em 5 segundos");
      }
    }
  }
}

void setup() {
  Serial.begin(115200);
  Wire.begin();
  if (!mpu.begin()) {
    Serial.println("Falha ao iniciar o sensor MPU6050");
    while (1);
  }
  setup_wifi();
  client.setServer(mqtt_server, mqtt_port);
}

void loop() {
  if (!client.connected()) {
    reconnect();
  } else {
    client.loop();
  }

  unsigned long currentMillis = millis();
  // Verificar se é hora de enviar os dados
  if (currentMillis - previousMillis >= interval) {
    previousMillis = currentMillis;

    // Ler os valores do sensor MPU6050
    sensors_event_t a, g, temp;
    mpu.getEvent(&a, &g, &temp);

    accelerometerX = a.acceleration.x;
    accelerometerY = a.acceleration.y;
    accelerometerZ = a.acceleration.z;

    gyroX = g.gyro.x;
    gyroY = g.gyro.y;
    gyroZ = g.gyro.z;

    temperature = temp.temperature;

    // Construir a mensagem JSON
    char data[200];
    snprintf(data, sizeof(data), "{\"accelerometerX\":%.2f,\"accelerometerY\":%.2f,\"accelerometerZ\":%.2f,\"gyroX\":%.2f,\"gyroY\":%.2f,\"gyroZ\":%.2f,\"temperature\":%.2f}", 
             accelerometerX, accelerometerY, accelerometerZ, gyroX, gyroY, gyroZ, temperature);

    // Publicar a mensagem no tópico MQTT
    if (client.publish("Encostas", data)) {
      Serial.println("Dados enviados com sucesso");
    } else {
      Serial.println("Falha ao enviar dados");
    }
  }
}
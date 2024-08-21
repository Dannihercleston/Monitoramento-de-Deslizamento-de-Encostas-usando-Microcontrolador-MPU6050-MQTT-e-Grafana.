import processing.net.*;  // Biblioteca para comunicação de rede
import processing.serial.*; // Biblioteca para comunicação serial

// Configurações da rede WiFi (não utilizadas diretamente no Processing)
final String ssid = "";  // Substitua pelo nome da sua rede WiFi
final String password = "";  // Substitua pela senha da sua rede WiFi

// Configurações do MQTT
final String mqttServer = "test.mosquitto.org";
final int mqttPort = 1883;
final String topic = "sensor/simulacao";

// Variáveis do sensor
float gyroX, gyroY, gyroZ;
float accelX, accelY, accelZ;
int sensorX, sensorY;

// Variáveis do terreno e movimento da encosta
int cols, rows;
int scl = 20;
float w = 1200;
float h = 800;
float[][] terrain;
float[][] velocity;
float[][] acceleration;
float gravity = 0.05;
float noiseScale = 0.1;
long lastMoveTime = 0;
long moveInterval = 60000;
boolean vibrating = false;
long vibrationStartTime;
long vibrationDuration = 10000;
boolean moving = false;

Client mqttClient;

void setup() {
  size(800, 600, P3D);
  cols = int(w / scl);
  rows = int(h / scl);
  terrain = new float[cols][rows];
  velocity = new float[cols][rows];
  acceleration = new float[cols][rows];
  generateTerrain();
  noStroke();

  sensorX = cols / 2;
  sensorY = rows / 2;

  // Inicializa o cliente MQTT
  mqttClient = new Client(this, mqttServer, mqttPort);
}

void draw() {
  background(135, 206, 250);

  if (moving && millis() - lastMoveTime >= moveInterval) {
    vibrating = true;
    vibrationStartTime = millis();
    lastMoveTime = millis();
  }

  if (vibrating) {
    if (millis() - vibrationStartTime < vibrationDuration) {
      applyVibration();
    } else {
      vibrating = false;
    }
  }

  if (!vibrating) {
    updateTerrain();
  }

  updateSensorReadings();
  sendToMQTT(gyroX, gyroY, gyroZ, accelX, accelY, accelZ); // Envia os dados para o MQTT

  pushMatrix();
  translate(width / 2, height / 2);
  rotateX(PI / 3);
  translate(-w / 2, -h / 2);

  for (int x = 0; x < cols - 1; x++) {
    for (int y = 0; y < rows - 1; y++) {
      fill(139, 69, 19);
      beginShape(QUADS);
      vertex(x * scl, y * scl, terrain[x][y]);
      vertex((x + 1) * scl, y * scl, terrain[x + 1][y]);
      vertex((x + 1) * scl, (y + 1) * scl, terrain[x + 1][y + 1]);
      vertex(x * scl, (y + 1) * scl, terrain[x][y + 1]);
      endShape();
    }
  }

  drawSensor();
  popMatrix();

  displaySensorReadings();
}

void updateSensorReadings() {
  if (sensorX >= 0 && sensorX < cols && sensorY >= 0 && sensorY < rows) {
    gyroX = terrain[sensorX][sensorY] * 0.01;
    gyroY = terrain[sensorX][sensorY] * 0.01;
    gyroZ = 0;

    accelX = velocity[sensorX][sensorY] * 0.1;
    accelY = velocity[sensorX][sensorY] * 0.1;
    accelZ = 0;
  }
}

void generateTerrain() {
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      float nx = x * noiseScale;
      float ny = y * noiseScale;
      terrain[x][y] = map(noise(nx, ny), 0, 1, -100, 100);
      velocity[x][y] = 0;
      acceleration[x][y] = 0;
    }
  }
}

void updateTerrain() {
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      acceleration[x][y] = gravity * (terrain[x][y] / 100.0);
      velocity[x][y] += acceleration[x][y];
      terrain[x][y] -= velocity[x][y];

      if (terrain[x][y] < -150) {
        terrain[x][y] = -150;
        velocity[x][y] = 0;
      }
    }
  }
}

void applyVibration() {
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      float vibrationStrength = 10;
      terrain[x][y] += sin(millis() * 0.01) * vibrationStrength;
    }
  }
}

void drawSensor() {
  pushMatrix();
  translate(sensorX * scl, sensorY * scl, terrain[sensorX][sensorY]);
  fill(0);
  sphere(8);
  popMatrix();
}

void displaySensorReadings() {
  fill(0);
  textSize(14);
  text("Giroscópio (Inclinação):", 10, 20);
  text("X: " + nf(gyroX, 1, 2), 10, 40);
  text("Y: " + nf(gyroY, 1, 2), 10, 60);
  text("Z: " + nf(gyroZ, 1, 2), 10, 80);

  text("Acelerômetro:", 10, 120);
  text("X: " + nf(accelX, 1, 2), 10, 140);
  text("Y: " + nf(accelY, 1, 2), 10, 160);
  text("Z: " + nf(accelZ, 1, 2), 10, 180);
}

// Função para enviar os dados do sensor para um tópico MQTT
void sendToMQTT(float gyroX, float gyroY, float gyroZ, float accelX, float accelY, float accelZ) {
  if (!mqttClient.active()) {
    reconnectMQTT();
  }

  String payload = "Giroscopio: X=" + nf(gyroX, 1, 2) + ", Y=" + nf(gyroY, 1, 2) + ", Z=" + nf(gyroZ, 1, 2);
  payload += " | Acelerometro: X=" + nf(accelX, 1, 2) + ", Y=" + nf(accelY, 1, 2) + ", Z=" + nf(accelZ, 1, 2);
  mqttClient.write(payload);
  println("Dados enviados ao MQTT: " + payload);
}

// Função para reconectar ao broker MQTT
void reconnectMQTT() {
  while (!mqttClient.active()) {
    println("Tentando conectar ao broker MQTT...");
    mqttClient = new Client(this, mqttServer, mqttPort);
    if (mqttClient.active()) {
      println("Conectado!");
    } else {
      println("Falha na conexão, tentando novamente em 5 segundos...");
      delay(5000);
    }
  }
}

// Comandos de teclado para reiniciar terreno ou alternar movimento
void keyPressed() {
  if (key == 'r' || key == 'R') {
    generateTerrain();
  } else if (key == 'm' || key == 'M') {
    moving = !moving;
    if (moving) {
      println("Movimento iniciado.");
      lastMoveTime = millis();
    } else {
      println("Movimento parado.");
      vibrating = false;
    }
  }
}

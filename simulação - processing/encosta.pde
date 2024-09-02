import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
import processing.serial.*;
import java.util.ArrayList;
import processing.data.JSONObject;  // Importação da biblioteca JSON interna do Processing

// Configurações da rede WiFi (não utilizadas diretamente no Processing)
final String ssid = "";  // nome da rede WiFi
final String password = "";  // senha da rede WiFi

// Configurações do MQTT
final String mqttBroker = "tcp://test.mosquitto.org:1883";
final String mqttClientId = "ProcessingClient";
final String mqttTopic = "Encostas/dados";

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

// Lista de casas
ArrayList<House> houses = new ArrayList<House>();

MqttClient client;

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

  // Conectar ao broker MQTT
  connectToMQTT();

  // Adiciona casas ao redor do sensor
  addHousesAroundSensor();
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
      endShape(CLOSE);

      // Desenha linhas de contorno para o terreno
      stroke(0);
      noFill();
      beginShape();
      vertex(x * scl, y * scl, terrain[x][y]);
      vertex((x + 1) * scl, y * scl, terrain[x + 1][y]);
      vertex((x + 1) * scl, (y + 1) * scl, terrain[x + 1][y + 1]);
      vertex(x * scl, (y + 1) * scl, terrain[x][y + 1]);
      endShape(CLOSE);
    }
  }

  drawSensor();
  drawHouses();
  popMatrix();

  displaySensorReadings();
}

// Conectar ao broker MQTT e assinar o tópico
void connectToMQTT() {
  try {
    client = new MqttClient(mqttBroker, mqttClientId, new MemoryPersistence());
    MqttConnectOptions connOpts = new MqttConnectOptions();
    connOpts.setCleanSession(true);
    client.connect(connOpts);
    client.subscribe(mqttTopic, (topic, msg) -> {
      String payload = new String(msg.getPayload());
      parseSensorData(payload);
    });
    println("Conectado ao broker MQTT e inscrito no tópico: " + mqttTopic);
  } catch (MqttException e) {
    e.printStackTrace();
    println("Erro ao conectar ao broker MQTT.");
  }
}

// Processar os dados do sensor recebidos do MQTT
void parseSensorData(String payload) {
  try {
    JSONObject json = JSONObject.parse(payload);  // Usando a biblioteca JSON interna

    // Extrair os valores do JSON
    accelX = json.getFloat("ax");
    accelY = json.getFloat("ay");
    accelZ = json.getFloat("az");
    gyroX = json.getFloat("gx");
    gyroY = json.getFloat("gy");
    gyroZ = json.getFloat("gz");

    // Exibir os dados recebidos no console
    println("Dados recebidos: ax=" + accelX + ", ay=" + accelY + ", az=" + accelZ +
            ", gx=" + gyroX + ", gy=" + gyroY + ", gz=" + gyroZ);
  } catch (Exception e) {
    println("Erro ao processar dados JSON: " + payload);
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

  // Atualiza a posição das casas
  for (House house : houses) {
    house.updatePosition(terrain);
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

void drawHouses() {
  for (House house : houses) {
    house.display();
  }
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

// Comandos de teclado para reiniciar terreno ou alternar movimento
void keyPressed() {
  if (key == 'r' || key == 'R') {
    generateTerrain();
  } else if (key == 'm' || key == 'M') {
    moving = !moving;
  }
}

// Classe para casas
class House {
  float x, y, z;
  float w, h;

  House(float x, float y, float z) {
    this.x = x * scl;
    this.y = y * scl;
    this.z = z;
    this.w = scl;
    this.h = scl;
  }

  void display() {
    pushMatrix();
    translate(x, y, z);
    fill(255, 0, 0);
    box(w, h, h);
    popMatrix();
  }

  void updatePosition(float[][] terrain) {
    int tx = int(x / scl);
    int ty = int(y / scl);
    z = terrain[tx][ty];
  }
}

// Adicionar casas ao redor do sensor
void addHousesAroundSensor() {
  int offset = 5;
  for (int i = 0; i < 4; i++) {
    int houseX = sensorX + (i % 2 == 0 ? -offset : offset);
    int houseY = sensorY + (i < 2 ? -offset : offset);
    float houseZ = terrain[houseX][houseY];
    houses.add(new House(houseX, houseY, houseZ));
  }
}

int cols, rows;
int scl = 20; // Escala da malha
float w = 1200; // Largura da malha
float h = 800; // Altura da malha
float[][] terrain;
float[][] velocity;
float[][] acceleration;
float gravity = 0.05; // Força da gravidade
float noiseScale = 0.1; // Escala de ruído para a geração do terreno
float rainIntensity = 0.0; // Intensidade da chuva
float maxRainIntensity = 0.1; // Intensidade máxima da chuva
boolean raining = false; // Estado da chuva
long rainStartTime; // Tempo de início da chuva
long rainDuration = 5000; // Duração da chuva em milissegundos

// Variáveis do sensor
float gyroX, gyroY, gyroZ; // Inclinação simulada do giroscópio
float accelX, accelY, accelZ; // Aceleração simulada
int sensorX, sensorY; // Posição do sensor na grade

// Variáveis para movimentação da encosta
long lastMoveTime = 0; // Último tempo de movimentação
long moveInterval = 60000; // Intervalo de 1 minuto (60000 ms)
boolean vibrating = false; // Estado da vibração
long vibrationStartTime; // Tempo de início da vibração
long vibrationDuration = 10000; // Duração da vibração em milissegundos (10 segundos)


void setup() {
  size(800, 600, P3D);
  cols = int(w / scl);
  rows = int(h / scl);
  terrain = new float[cols][rows];
  velocity = new float[cols][rows];
  acceleration = new float[cols][rows];
  generateTerrain();
  noStroke();
  
  // Inicializa a posição do sensor
  sensorX = cols / 2; // Posição central na grade
  sensorY = rows / 2; // Posição central na grade
}

//Função chamada continuamente para atualizar e desenhar o conteúdo na tela
void draw() {
  background(135, 206, 250); // Cor do fundo

  // Verifica se é hora de iniciar a vibração
  if (millis() - lastMoveTime >= moveInterval) {
    vibrating = true;
    vibrationStartTime = millis();
    lastMoveTime = millis(); // Atualiza o tempo de última movimentação
  }

  // Aplica vibração se estiver no estado de vibração
  if (vibrating) {
    if (millis() - vibrationStartTime < vibrationDuration) {
      applyVibration(); // Aplica vibração ao terreno
    } else {
      vibrating = false; // Interrompe a vibração após a duração
    }
  }

  // Atualiza o terreno fora do período de vibração
  if (!vibrating) {
    updateTerrain();
  }

  // Atualiza os dados do sensor
  updateSensorReadings();

  // Desenha o terreno
  pushMatrix();
  translate(width / 2, height / 2);
  rotateX(PI / 3);
  translate(-w / 2, -h / 2);

  for (int x = 0; x < cols - 1; x++) {
    for (int y = 0; y < rows - 1; y++) {
      fill(139, 69, 19); // Cor do terreno
      beginShape(QUADS);
      vertex(x * scl, y * scl, terrain[x][y]);
      vertex((x + 1) * scl, y * scl, terrain[x + 1][y]);
      vertex((x + 1) * scl, (y + 1) * scl, terrain[x + 1][y + 1]);
      vertex(x * scl, (y + 1) * scl, terrain[x][y + 1]);
      endShape();
    }
  }

  // Desenha o sensor fixo na encosta
  drawSensor();

  popMatrix();

  // Desenha os valores do sensor na tela
  displaySensorReadings();
}

// Função para atualizar as leituras do sensor
void updateSensorReadings() {
  // Atualiza os valores do sensor com base na posição do sensor na grade
  if (sensorX >= 0 && sensorX < cols && sensorY >= 0 && sensorY < rows) {
    // Simula leitura do giroscópio e acelerômetro baseando-se no terreno
    gyroX = terrain[sensorX][sensorY] * 0.01; // Exemplo de cálculo para giroscópio
    gyroY = terrain[sensorX][sensorY] * 0.01; // Exemplo de cálculo para giroscópio
    gyroZ = 0; // Gira apenas no plano X-Y

    accelX = velocity[sensorX][sensorY] * 0.1; // Exemplo de cálculo para acelerômetro
    accelY = velocity[sensorX][sensorY] * 0.1; // Exemplo de cálculo para acelerômetro
    accelZ = 0; // Aceleração no plano X-Y
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

// Atualiza o terreno com base na gravidade e na intensidade da chuva
void updateTerrain() {
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      // Aplica gravidade às células com base na inclinação
      acceleration[x][y] = gravity * (terrain[x][y] / 100.0) + rainIntensity;

      // Atualiza a velocidade e a altura
      velocity[x][y] += acceleration[x][y];
      terrain[x][y] -= velocity[x][y];

      // Limita o deslizamento para não ir abaixo de um certo nível
      if (terrain[x][y] < -150) {
        terrain[x][y] = -150;
        velocity[x][y] = 0;
      }
    }
  }
}

// Aplica uma vibração ao terreno
void applyVibration() {
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      // Adiciona uma pequena oscilação à altura do terreno
      float vibrationStrength = 10; // Força da vibração
      terrain[x][y] += sin(millis() * 0.01) * vibrationStrength;
    }
  }
}

// Desenha o sensor
void drawSensor() {
  // Desenha o sensor como uma pequena esfera preta na posição designada
  pushMatrix();
  translate(sensorX * scl, sensorY * scl, terrain[sensorX][sensorY]);
  fill(0); // Cor preta para o sensor
  sphere(8); // Esfera representando o sensor
  popMatrix();
}

// Desenha as leituras do sensor na tela
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

  if (raining) {
    text("Chovendo: Sim", 10, 220);
    text("Intensidade da Chuva: " + nf(rainIntensity, 0, 2), 10, 240);
  } else {
    text("Chovendo: Não", 10, 220);
  }
}

// Comandos
void keyPressed() {
  if (key == 'r' || key == 'R') {
    generateTerrain(); // Redefine o terreno
  } else if (key == 'c' || key == 'C') {
    raining = true;
    rainStartTime = millis(); // Marca o início da chuva
  }
}

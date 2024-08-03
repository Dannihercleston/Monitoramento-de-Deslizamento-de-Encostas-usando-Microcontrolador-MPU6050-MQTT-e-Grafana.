#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_MPU6050.h>
#include <WiFi.h>
#include <PubSubClient.h>

// Objeto do sensor MPU6050
Adafruit_MPU6050 mpu;
// Variáveis para armazenar os valores do sensor
float accelerometerX, accelerometerY, accelerometerZ;
float gyroX, gyroY, gyroZ;
float temperature;
void setup() {
  
}
}

void loop() {
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
}

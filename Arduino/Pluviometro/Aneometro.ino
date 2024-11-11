#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

#define Hall_sensor 23 // Pino digital D23 no ESP32 (GPIO 23)

// Constantes
const float pi = 3.14159265;
const int period = 5000; 
const int radius = 105; 

// Variáveis globais
unsigned int counter = 0; 
unsigned int RPM = 0;
float windspeed = 0;
float speedwind = 0;

// Credenciais Wi-Fi
const char* ssid = "Auri mayolo";     
const char* password = "auri2019";

void setup() {
  pinMode(Hall_sensor, INPUT_PULLUP); 
  Serial.begin(9600); 
  connectToWiFi(); 
}

void loop() {
  anemometro(); // Chama o método comprimido
}

void anemometro() {
  counter = 0;
  attachInterrupt(digitalPinToInterrupt(Hall_sensor), addcount, RISING); 

  delay(period); // Espera pelo tempo de medida
  
  detachInterrupt(Hall_sensor);

  RPM = (counter * 60) / (period / 1000);
  windspeed = ((4 * pi * radius * RPM) / 60) / 1000;
  speedwind = windspeed * 3.6;

  Serial.printf("Velocidade do vento: %.2f [m/s] / %.2f [km/h]\n", windspeed, speedwind);

  sendWindDataToServer(windspeed, speedwind);
}

void addcount() {
  counter++; 
}

void connectToWiFi() {
  Serial.print("Conectando-se à rede Wi-Fi ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }

  Serial.println("\nConectado à rede Wi-Fi");
  Serial.println(WiFi.localIP());
}

void sendWindDataToServer(float windspeed, float speedwind) {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin("http://192.168.0.106:9000/aneometro");
    http.addHeader("Content-Type", "application/json");

    StaticJsonDocument<200> jsonDoc;
    jsonDoc["windspeed_mps"] = windspeed;
    jsonDoc["speedwind_kph"] = speedwind;

    String jsonData;
    serializeJson(jsonDoc, jsonData);

    int httpResponseCode = http.POST(jsonData);

    if (httpResponseCode > 0) {
      Serial.printf("HTTP Response code: %d\n", httpResponseCode);
      Serial.println("Resposta do servidor: " + http.getString());
    } else {
      Serial.printf("Erro no envio HTTP POST, código: %d\n", httpResponseCode);
    }

    http.end();
  } else {
    Serial.println("Erro na conexão Wi-Fi");
  }
}

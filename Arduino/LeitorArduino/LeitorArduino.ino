#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

// Pin definitions
#define Hall_sensor 23 // Pino digital D23 no ESP32 (GPIO 23)

// Constants definitions
const float pi = 3.14159265; // Número pi
const int period = 5000; // Tempo de medida (milissegundos)
const int radius = 105; // Ajusta o raio do anemômetro em milímetros

// Variáveis
unsigned int counter = 0; // Contador de pulsos para o sensor
unsigned int RPM = 0; // Revoluções por minuto
float windspeed = 0; // Velocidade do vento (m/s)
float speedwind = 0; // Velocidade do vento (km/h)

// Wi-Fi credentials
//const char* ssid = "Auri mayolo";    
//const char* password = "auri2019";   
//const char* ssid = "Variani404";    
//const char* password = "ap4042022rv";

const char* ssid = "TCC_Claudinei";    
const char* password = "fune3011@";

void setup() {
  pinMode(Hall_sensor, INPUT_PULLUP); // Configura o pino do sensor como entrada com pull-up
  Serial.begin(9600); // Inicia a comunicação serial
  connectToWiFi(); // Conectar ao Wi-Fi
}

void loop() {
  anemometro(); // Chama o método comprimido
}

void anemometro() {
  counter = 0; // Reinicia o contador
  RPM = 0;
  attachInterrupt(digitalPinToInterrupt(Hall_sensor), addcount, RISING); // Ativar interrupção

  unsigned long startTime = millis();
  while (millis() < startTime + period) {
    // Aguarda o período de medição
  }
  
  detachInterrupt(Hall_sensor); // Desativa a interrupção

  // Calcula as RPM (rotações por minuto)
  RPM = ((counter) * 60) / (period / 1000);

  // Calcula a velocidade do vento em m/s
  windspeed = ((4 * pi * radius * RPM) / 60) / 1000;

  // Converte de m/s para km/h
  speedwind = windspeed * 3.6;

  // Exibe as velocidades no terminal serial
  Serial.print("Velocidade do vento: ");
  Serial.print(windspeed);
  Serial.print(" [m/s] / ");
  Serial.print(speedwind);
  Serial.println(" [km/h]");

  if (speedwind > 0){
    // Envia os dados para o servidor via HTTP POST em formato JSON
    sendWindDataToServer(windspeed, speedwind);
  }
}

// Função chamada pela interrupção para contar os pulsos
void addcount() {
  counter++; // Incrementa o contador de pulsos
}

// Função para conectar ao Wi-Fi
void connectToWiFi() {
  Serial.print("Conectando-se à rede Wi-Fi ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }
  
  Serial.println("\nConectado à rede Wi-Fi");
  Serial.println(WiFi.localIP());  // Mostra o IP local do ESP32
}

// Função para enviar os dados de velocidade do vento para o servidor
void sendWindDataToServer(float windspeed, float speedwind) {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin("http://192.168.0.100:9000/aneometros"); // Endereço da API
    http.addHeader("Content-Type", "application/json"); // Tipo de conteúdo JSON

    StaticJsonDocument<200> jsonDoc;
    //jsonDoc["windspeed_mps"] = windspeed; // Velocidade em m/s
    jsonDoc["VELOCIDADE"] = speedwind; // Velocidade em km/h
    jsonDoc["chave"] = "{6F8111FF-45B9-4971-BF38-61310B11D9B5}";
    
    String jsonData;
    serializeJson(jsonDoc, jsonData);
    
    int httpResponseCode = http.POST(jsonData); // Envia a requisição POST

    if (httpResponseCode > 0) {
      String response = http.getString();
      Serial.print("HTTP Response code: ");
      Serial.println(httpResponseCode);
      Serial.println("Resposta do servidor: ");
      Serial.println(response);
    } else {
      Serial.print("Erro no envio HTTP POST, código: ");
      Serial.println(httpResponseCode);
    }

    http.end(); // Fecha a conexão
  } else {
    Serial.println("Erro na conexão Wi-Fi");
  }
}

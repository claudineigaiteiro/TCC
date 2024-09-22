#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

// Pin definitions
#define Hall_sensor 23 // Pino digital D23 no ESP32 (GPIO 23)

// Constants definitions
const float pi = 3.14159265; // Número pi
int period = 5000; // Tempo de medida (milissegundos)
int radius = 105; // Ajusta o raio do anemômetro em milímetros

// Variáveis
unsigned int counter = 0; // Contador de pulsos para o sensor
unsigned int RPM = 0; // Revoluções por minuto
float windspeed = 0; // Velocidade do vento (m/s)
float speedwind = 0; // Velocidade do vento (km/h)

// Wi-Fi credentials
const char* ssid = "Auri mayolo";     // Substitua pelo nome da sua rede Wi-Fi
const char* password = "auri2019"; // Substitua pela senha da sua rede Wi-Fi

void setup() {
  // Configura o pino do sensor como entrada com pull-up
  pinMode(Hall_sensor, INPUT_PULLUP); 

  // Inicia a comunicação serial
  Serial.begin(9600); 

  // Conectar ao Wi-Fi
  connectToWiFi();
}

void loop() {
  // Inicia a medição da velocidade do vento
  windvelocity();

  // Calcula as RPM (rotações por minuto)
  RPMcalc();

  // Exibe a velocidade em m/s
  WindSpeed();
  Serial.print("Velocidade do vento: ");
  Serial.print(windspeed);
  Serial.print(" [m/s] ");
  
  // Exibe a velocidade em km/h
  SpeedWind();
  Serial.print(" / ");
  Serial.print(speedwind);
  Serial.println(" [km/h]");

  // Envia os dados para o servidor via HTTP POST em formato JSON
  sendWindDataToServer(windspeed, speedwind);

  delay(2000); // Intervalo entre leituras
}

// Função para medir a velocidade do vento
void windvelocity() {
  counter = 0; // Reinicia o contador
  attachInterrupt(digitalPinToInterrupt(Hall_sensor), addcount, RISING); // Ativar interrupção
  
  unsigned long startTime = millis();
  while (millis() < startTime + period) {
    // Aguarda o período de medição
  }
  
  detachInterrupt(Hall_sensor); // Desativar interrupção
}

// Calcula as RPM (rotações por minuto)
void RPMcalc() {
  RPM = ((counter) * 60) / (period / 1000); // Calcula as rotações por minuto (RPM)
}

// Calcula a velocidade do vento em m/s
void WindSpeed() {
  windspeed = ((4 * pi * radius * RPM) / 60) / 1000; // Calcula a velocidade do vento em m/s
}

// Calcula a velocidade do vento em km/h
void SpeedWind() {
  speedwind = windspeed * 3.6; // Converte de m/s para km/h
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

  Serial.println("");
  Serial.println("Conectado à rede Wi-Fi");
  Serial.println(WiFi.localIP());  // Mostra o IP local do ESP32
}

// Função para enviar os dados de velocidade do vento para o servidor
void sendWindDataToServer(float windspeed, float speedwind) {
  if (WiFi.status() == WL_CONNECTED) {  // Verifica se está conectado ao Wi-Fi
    HTTPClient http;

    // Define o endereço da API
    http.begin("http://192.168.0.106:9000/aneometro");                     

    // Define o tipo de conteúdo como JSON
    http.addHeader("Content-Type", "application/json");

    // Cria o objeto JSON
    StaticJsonDocument<200> jsonDoc;
    jsonDoc["windspeed_mps"] = windspeed; // Velocidade em m/s
    jsonDoc["speedwind_kph"] = speedwind; // Velocidade em km/h

    // Converte o objeto JSON para string
    String jsonData;
    serializeJson(jsonDoc, jsonData);

    // Envia a requisição POST com o JSON
    int httpResponseCode = http.POST(jsonData);

    // Verifica o código de resposta
    if (httpResponseCode > 0) {
      String response = http.getString();  // Recebe a resposta
      Serial.print("HTTP Response code: ");
      Serial.println(httpResponseCode);
      Serial.println("Resposta do servidor: ");
      Serial.println(response);
    } else {
      Serial.print("Erro no envio HTTP POST, código: ");
      Serial.println(httpResponseCode);
    }

    // Fecha a conexão
    http.end();
  } else {
    Serial.println("Erro na conexão Wi-Fi");
  }
}

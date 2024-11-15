// PROGRAMA PARA PLUVIÔMETRO - ADAPTADO PARA ESP32 COM D22

#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

const int REED = 22; // O reed switch está conectado ao GPIO 22 (D22) no ESP32
int val = 0, old_val = 0, REEDCOUNT = 0; // Variáveis globais

// Credenciais Wi-Fi
//const char* ssid = "Auri mayolo";     
//const char* password = "auri2019";

const char* ssid = "TCC_Claudinei";     
const char* password = "fune3011@";

void setup() {
  pinMode(REED, INPUT_PULLUP); // Configura o reed switch como entrada com pull-up
  Serial.begin(9600); // Inicializa a comunicação serial
  Serial.println("Iniciando leitura do pluviômetro...");
  connectToWiFi(); 
}

void loop() {
  pluviometro(); // Chama o método comprimido
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

void pluviometro() {
  val = digitalRead(REED); // Ler o estado do reed switch

  if ((val == LOW) && (old_val == HIGH)){ 
    delay(10); // Atraso para bouncing
    old_val = val; // Atualiza o valor anterior
    Serial.print("Medida de chuva (calculado): ");
    Serial.print(0.25);
    Serial.println(" mm");
    sendWindDataToServer(0.25);
  }else{
    old_val = val;
  } 
}

void sendWindDataToServer(float speedwind) {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin("http://192.168.0.100:9000/pluviometros"); // Endereço da API
    http.addHeader("Content-Type", "application/json"); // Tipo de conteúdo JSON

    StaticJsonDocument<200> jsonDoc;
    //jsonDoc["windspeed_mps"] = windspeed; // Velocidade em m/s
    jsonDoc["MEDICAO"] = speedwind; // Velocidade em km/h
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

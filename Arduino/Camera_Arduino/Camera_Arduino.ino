#include "esp_camera.h"
#include "Arduino.h"
#include <WiFi.h>
#include <HTTPClient.h>

#define PWDN_GPIO_NUM    32
#define RESET_GPIO_NUM   -1
#define XCLK_GPIO_NUM    0
#define SIOD_GPIO_NUM    26
#define SIOC_GPIO_NUM    27

#define Y9_GPIO_NUM      35
#define Y8_GPIO_NUM      34
#define Y7_GPIO_NUM      39
#define Y6_GPIO_NUM      36
#define Y5_GPIO_NUM      21
#define Y4_GPIO_NUM      19
#define Y3_GPIO_NUM      18
#define Y2_GPIO_NUM      5
#define VSYNC_GPIO_NUM   25
#define HREF_GPIO_NUM    23
#define PCLK_GPIO_NUM    22

// Pino do flash LED
#define FLASH_GPIO_NUM   4

const char* ssid = "Variani404";
const char* password = "ap4042022rv";

void sendImageToServer() {
  // Captura uma foto
  camera_fb_t *fb = esp_camera_fb_get();
  if (!fb) {
    Serial.println("Falha ao capturar imagem");
    return;
  }

  // Converte a imagem para hexadecimal
  String imageHex = "";
  for (size_t i = 0; i < fb->len; i++) {
    char hex[3];
    sprintf(hex, "%02x", fb->buf[i]);
    imageHex += hex;
  }

  // Cria o JSON com a imagem em hexadecimal
  String json = "{\"image\": \"" + imageHex + "\"}";

  // Faz o POST para o servidor
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin("http://192.168.0.101:9000/imagem");
    http.addHeader("Content-Type", "application/json");

    int httpResponseCode = http.POST(json);

    if (httpResponseCode > 0) {
      Serial.printf("Resposta do servidor: %d\n", httpResponseCode);
    } else {
      Serial.printf("Erro ao enviar a imagem: %s\n", http.errorToString(httpResponseCode).c_str());
    }

    http.end();
  }

  // Libera o buffer da imagem
  esp_camera_fb_return(fb);
}

void setup() {
  Serial.begin(115200);

  // Configura o pino do flash como saída
  pinMode(FLASH_GPIO_NUM, OUTPUT);
  digitalWrite(FLASH_GPIO_NUM, LOW); // Flash desligado inicialmente

  // Conectando ao WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Conectando ao WiFi...");
  }
  Serial.println("WiFi conectado");

  // Configurando a câmera
  camera_config_t config;
  config.ledc_channel = LEDC_CHANNEL_0;
  config.ledc_timer = LEDC_TIMER_0;
  config.pin_d0 = Y2_GPIO_NUM;
  config.pin_d1 = Y3_GPIO_NUM;
  config.pin_d2 = Y4_GPIO_NUM;
  config.pin_d3 = Y5_GPIO_NUM;
  config.pin_d4 = Y6_GPIO_NUM;
  config.pin_d5 = Y7_GPIO_NUM;
  config.pin_d6 = Y8_GPIO_NUM;
  config.pin_d7 = Y9_GPIO_NUM;
  config.pin_xclk = XCLK_GPIO_NUM;
  config.pin_pclk = PCLK_GPIO_NUM;
  config.pin_vsync = VSYNC_GPIO_NUM;
  config.pin_href = HREF_GPIO_NUM;
  config.pin_sscb_sda = SIOD_GPIO_NUM;
  config.pin_sscb_scl = SIOC_GPIO_NUM;
  config.pin_pwdn = PWDN_GPIO_NUM;
  config.pin_reset = RESET_GPIO_NUM;
  config.xclk_freq_hz = 20000000;
  config.pixel_format = PIXFORMAT_JPEG;
  config.frame_size = FRAMESIZE_SVGA;
  config.jpeg_quality = 10;
  config.fb_count = 1;

  // Inicializa a câmera
  esp_err_t err = esp_camera_init(&config);
  if (err != ESP_OK) {
    Serial.printf("Falha ao iniciar a câmera, erro: 0x%x", err);
    return;
  }
}

void loop() {
  // Liga o flash antes de capturar a imagem
  digitalWrite(FLASH_GPIO_NUM, HIGH);
  delay(100); // Pequeno atraso para garantir que o flash esteja ligado

  // Envia a imagem para o servidor
  sendImageToServer();

  // Desliga o flash após capturar e enviar a imagem
  digitalWrite(FLASH_GPIO_NUM, LOW);

  // Espera 5 segundos antes de capturar e enviar outra imagem
  delay(5000);
}

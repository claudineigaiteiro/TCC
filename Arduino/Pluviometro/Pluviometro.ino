// PROGRAMA PARA PLUVIÔMETRO - ADAPTADO PARA ESP32 COM D22

const int REED = 22; // O reed switch está conectado ao GPIO 22 (D22) no ESP32
int val = 0, old_val = 0, REEDCOUNT = 0; // Variáveis globais

void setup() {
  pinMode(REED, INPUT_PULLUP); // Configura o reed switch como entrada com pull-up
  Serial.begin(9600); // Inicializa a comunicação serial
  Serial.println("Iniciando leitura do pluviômetro...");
}

void loop() {
  pluviometro(); // Chama o método comprimido
}

void pluviometro() {
  val = digitalRead(REED); // Ler o estado do reed switch

  if ((val == LOW) && (old_val == HIGH)) {
    delay(10); // Atraso para bouncing
    REEDCOUNT++;
    old_val = val; // Atualiza o valor anterior
    Serial.print("Medida de chuva (contagem): ");
    Serial.println(REEDCOUNT);
    Serial.print("Medida de chuva (calculado): ");
    Serial.print(REEDCOUNT * 0.25);
    Serial.println(" mm");
    REEDCOUNT = 0; // Zera a contagem após a medição
  } else {
    old_val = val; // Atualiza o valor anterior se não houver mudança
  }
}

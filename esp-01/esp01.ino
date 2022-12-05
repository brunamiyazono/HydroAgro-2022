#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <ArduinoJson.h>
#include <FirebaseArduino.h>

#define FIREBASE_AUTH "ZzUByjwbCrfk3LQubTct8ri5nAwFXkBZUvEPtMA0"
#define FIREBASE_HOST "hydroagro-d3a60-default-rtdb.firebaseio.com"
char* ssid = "BrunaMiyazono";
char* password = "boopdboo";

void setup()
{
  Serial.begin(9600);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(200);
  }

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  
}

void loop()
{
  bool luz = Firebase.getBool("/luz/controllerLuz");
  bool bombaAgua = Firebase.getBool("/Motor/controllerMotor");
  bool nutrienteA = Firebase.getBool("/nutrienteA/nutrienteA");
  bool nutrienteB = Firebase.getBool("/nutrienteB/nutrienteB");

  DynamicJsonBuffer docRequest;
  JsonVariant request = docRequest.createObject();

  request["type"] = "request";
  request["luz"] = luz;
  request["bombaAgua"] = bombaAgua;
  request["nutrienteA"] = nutrienteA;
  request["nutrienteB"] = nutrienteB;
  request.printTo(Serial);

  boolean messageReady = false;
  String message = "";

  while (messageReady == false) {
    if (Serial.available()) {
      message = Serial.readString();
      //Serial.println(message);
      messageReady = true;
    }
  }

  if (messageReady == true) {
    float t = 0.0, h = 0.0, co2 = 0.0, ph = 0.0, tempAgua = 0.0, TDS = 0;
    int TDSint = 0;
    boolean nutrienteA, nutrienteB, controlA, controlB;

    DynamicJsonBuffer docResponse;
    JsonVariant resposta = docResponse.parse(message);
    
    if (resposta["type"] == "response") {
      t = resposta["temperatura"];
      h = resposta["umidade"];
      co2 = resposta["co2"];
      ph = resposta["phAgua"];
      TDS = resposta["tdsAgua"];
      tempAgua = resposta["tempAgua"];
      nutrienteA = resposta["nutrienteA"];
      nutrienteB = resposta["nutrienteB"];
      controlA = resposta["controlNutrienteA"];
      controlB = resposta["controlNutrienteB"];
      TDSint = TDS + 0.5;

      Firebase.setFloat("/sensores/temperaturaAmbiente", t);
      delay(400);
      Firebase.setFloat("/sensores/umidadeAmbiente", h);
      delay(400);
      Firebase.setFloat("/sensores/co2Ambiente", co2);
      delay(400);
      Firebase.setFloat("/sensores/phAgua", ph);
      delay(400);
      Firebase.setInt("/sensores/tdsAgua", TDSint);
      delay(400);
      Firebase.setFloat("/sensores/temperaturaAgua", tempAgua);
      delay(400);
      if(controlA == true){
        Firebase.setBool("/nutrienteA/nutrienteA", nutrienteA);
        delay(400);
      }
      if(controlB == true){
        Firebase.setBool("/nutrienteB/nutrienteB", nutrienteB);
        delay(400);
      }
    }
  }
}
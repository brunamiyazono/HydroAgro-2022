#include <ArduinoJson.h>
#include <Wire.h>; 
#include <DHT.h>;      // Inclusão da biblioteca para o sensor DHT22 (temperatura e umidade)
#include <OneWire.h> // Biblioteca para utilizar sensor de temperatura
#include <DallasTemperature.h> // biblioteca para utilizar sensor de temperatura da agua
#include "GravityTDS.h"   //biblioteca para utilizar sensor de TDS
#include <Servo.h>
const int pinoServoA = 8; //PINO DIGITAL UTILIZADO PELO SERVO
const int pinoServoB = 7; //PINO DIGITAL UTILIZADO PELO SERVO  

unsigned long previousMillis = 0;
const long interval = 10000;

Servo s1; //OBJETO DO TIPO SERVO
Servo s2;

//Definindo objeto DHT (sensor temp e umidade ambiente)
#define DHTPIN 53
#define DHTTYPE DHT22
DHT dht (DHTPIN, DHTTYPE);

//pin sensor co2
int sensorGasPin = A8;

#define sensorTempAgua 22
//DEFINE O PINO DIGITAL UTILIZADO PELO SENSOR DE TEMPERATURA
#define phSensor A9       // DEFINE O PINO ANALOGICO UTILIZADO PELO SENSOR DE PH
#define tdsSensor A10     // DEFINE O PINO ANALOGICO UTILIZADO PELO SENSOR DE TDS7
#define pinLED 52

#define pinoBombaAgua 48
#define pinoBombaAr 49
#define sensorNivel 50

//Inicia as funções das bibliotecas para temperatura, e TDS da água
OneWire oneWire(sensorTempAgua);      //Passa o pino do sensor de temperatura para a biblioteca OneWire
GravityTDS gravityTds;                //Passa o pino do sensor TDS para a biblioteca gravityTDS
DallasTemperature sensors(&oneWire);  //Passa o resultado da biblioteca OneWire para a biblioteca DallasTemperature

boolean controlNutrienteA = false;
boolean controlNutrienteB = false;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  Serial1.begin(9600);
   
  pinMode(DHTPIN, INPUT);
  pinMode(sensorTempAgua, INPUT);
  pinMode(sensorNivel, INPUT);
  pinMode(pinLED, OUTPUT);
  pinMode(pinoBombaAgua, OUTPUT);
  pinMode(pinoBombaAr, OUTPUT);
  pinMode(pinoServoA, OUTPUT);
  pinMode(pinoServoB, OUTPUT);

  dht.begin();

  sensors.begin(); //INICIA O SENSOR
  gravityTds.setPin(tdsSensor);
  gravityTds.setAref(5.0);  //reference voltage on ADC, default 5.0V on Arduino UNO
  gravityTds.setAdcRange(1024);  //1024 for 10bit ADC;4096 for 12bit ADC
  gravityTds.begin();  //initialization

  s1.attach(pinoServoA); //ASSOCIAÇÃO DO PINO DIGITAL AO OBJETO DO TIPO SERVO
  s1.write(0);
  s2.attach(pinoServoB);
  s2.write(0);
}

void loop() {
  Serial.println("Loop!!");
  boolean messageReady = false;
  String message = "";
  
  while(messageReady == false){
    Serial.println("While message ready");
    if(Serial1.available()){
      //Serial.println("Message Ready");
      message = Serial1.readString();
      Serial.print("Message: ");
      Serial.println(message);
      messageReady = true;
    }
    if (digitalRead(sensorNivel) == HIGH){ 
      digitalWrite(pinoBombaAgua, HIGH);
      digitalWrite(pinoBombaAr, HIGH);
    }
  }

  if(messageReady == true){
    DynamicJsonBuffer docRequest;
    JsonVariant request = docRequest.parse(message);
    
    if (!request.success()){
      Serial.println("parseObject() failed");
      return;
    }
    Serial.println("JSON deserializado");

    if (request["type"] == "request"){
      bool luz = false;
      bool bombaAgua = false;
      bool nutrienteA = false;
      bool nutrienteB = false;
      
      luz = request["luz"];
      bombaAgua = request["bombaAgua"];
      nutrienteA = request["nutrienteA"];
      nutrienteB = request["nutrienteB"];
      
      controlarLuz(luz);
      controleBomba(bombaAgua);
      Serial.print("nutrienteA: ");
      Serial.println(nutrienteA);
      if (nutrienteA == true){
        Serial.print("if Nutriente A");
        servo(1);
        controlNutrienteA = true;
      }
      Serial.print("nutrienteB: ");
      Serial.println(nutrienteB);
      if (nutrienteB == true){
        Serial.print("if Nutriente B");
        servo(2);  
        controlNutrienteB = true;
      }
    }
  }
   
  sendValuesToDataBase();
    
}
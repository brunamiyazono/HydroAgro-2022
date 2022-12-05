void sendValuesToDataBase() {
  Serial.println("Send values to data Base");
  float temperatura;
  float humidity;
  tempUmidadeAmbiente(humidity, temperatura);
  float valorPh = phAgua();
  int valorTDS = getTDS();
  float tempAgua = temperaturaAgua();
  float co2 = sensorCO2();
  
  DynamicJsonBuffer resposta;
  JsonVariant respostaObj = resposta.createObject();
  
  respostaObj["type"] = "response";
  respostaObj["temperatura"] = temperatura;
  respostaObj["umidade"] = humidity;
  respostaObj["co2"] = co2;
  respostaObj["phAgua"] = valorPh;
  respostaObj["tdsAgua"] = valorTDS;
  respostaObj["tempAgua"] = tempAgua;
  Serial.print("controlNutrienteA: ");
  Serial.println(controlNutrienteA);
  if(controlNutrienteA == true){
    respostaObj["nutrienteA"] = false;
    respostaObj["controlNutrienteA"] = true;
    controlNutrienteA = false;
  } else if (controlNutrienteA   == false){
    respostaObj["controlNutrienteA"] = false;
    }
  Serial.print("controlNutrienteB: ");
  Serial.println(controlNutrienteB);  
  if(controlNutrienteB == true){ 
    respostaObj["nutrienteB"] = false;
    respostaObj["controlNutrienteB"] = true;
    controlNutrienteB = false;
  } else if (controlNutrienteB == false){
    respostaObj["controlNutrienteB"] = false;
    }

  respostaObj.printTo(Serial1);    
}
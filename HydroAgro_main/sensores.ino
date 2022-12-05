float sensorCO2 (){         // função executada quando, dentro do submenu "Sensores" o usuário clica no botão "para baixo"
  int listaValoresCo2[20];                               //Array para as leituras de CO2
  int co2Bruto = 0;                                   //INT para o valor do CO2 sem tratamento
  int co2compensado = 0;                             // INT para calcular o valor compesado do co2
  int co2ppm = 0;                                //INT para o calculo do ppm
  int media = 0;                                  //INT para a media das medicoes
  int co2calibration = 200;
  
  for (int x = 0;x<20;x++)  // obtem 10 medições do MQ-135 em dois segundos
  {                   
     listaValoresCo2[x]=analogRead(sensorGasPin);
     delay(200);
     //Serial.print(listaValoresCo2[x]);
   }
    
  for (int x = 0;x<20;x++)  // adiciona as medições na array
  {                    
    media=media + listaValoresCo2[x];
    //Serial.println(media);  
   }

    co2Bruto = media/20;                            // obtem a media das medicoes do sensor mq-135
    co2compensado = co2Bruto - co2calibration;                 // subtrai o co2 lido do valor de calibração
    co2ppm = abs(map(co2compensado,0,1023,400,5000));              //mapa para converter a leitura para PPM
    return co2ppm;
}

void tempUmidadeAmbiente(float& h, float& t){
  h = dht.readHumidity(); //Le o valor da umidade
  t = dht.readTemperature(); //Le o valor da temperatura

}

float phAgua(){

  float resolution = 1024.0;       // resolução para calculo da voltagem
  float voltagem;                  // float para armazenar a voltagem lida 
  float valorPh;                   // float para armazenar o valor da voltagem convertida para PH
  float calibragemPh = 9.8;       // valor de compensação da calibragem do sensor
  float m = 0.167;                 // constante para conversão de voltagem para valor em PH
  int x = 0;
  
  int medicao = 0;                 // variável para armazenar a medição inicial do aquecimento do sensor
                         
  for (int i = 0; i < 20; i++)     // Le o valor do sensor 20x, incrementando o valor anterior com o valor atual a cada iteração       
  {
    medicao = medicao  + analogRead(phSensor);     
    delay(10);                                  
  }
  
  voltagem = ((5 / resolution) * (medicao/20));   //calcula a voltagem da média das medições lida
                                             
  valorPh = (7 + ((2.5 - voltagem) / m) + calibragemPh ); //converte a voltagem lida para PH, compensando com a caloibragem   

  valorPh = fabs(round(valorPh*10)/10.0);
  return valorPh;                            //retorna o valor do PH compensado

}

float temperaturaAgua() {

  float temperatura;
  int x;
  
  sensors.requestTemperatures();//SOLICITA QUE A FUNÇÃO INFORME A TEMPERATURA DO SENSOR
  temperatura = sensors.getTempCByIndex(0);  //capta o valor de temperatura lido do sensor

  x = (int (temperatura*100))  ;
  temperatura = float (x)/ 100;
  return temperatura;   //retorna a temperatura lida
  
}

float getTDS(){
  float temperatura;
  float tds;
  
  sensors.requestTemperatures();
  temperatura = sensors.getTempCByIndex(0);  //capta o valor de temperatura lido do sensor

  gravityTds.setTemperature(temperatura);  // Verifica a temperatura e realiza a compensação
  gravityTds.update();  // atualiza a informação captada com a compensação 
  tds = gravityTds.getTdsValue();  // valor TDS compensado

  return tds;
}
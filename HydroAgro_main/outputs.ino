void controlarLuz(bool estado){
  if(estado == true){
    digitalWrite(pinLED, LOW);
    }
  if(estado == false){
    digitalWrite(pinLED, HIGH);
    }
  }

void controleBomba (bool estado){
if(digitalRead(sensorNivel) == LOW){
  if(estado == false){
    digitalWrite(pinoBombaAgua, HIGH);
    digitalWrite(pinoBombaAr, HIGH);
  }
  if(estado == true){
    digitalWrite(pinoBombaAgua, LOW);
    digitalWrite(pinoBombaAr, LOW);
  }
}
}


int servo_abrir(int servoMotor, int grau){
  int pos=0;
  if (servoMotor==1){
    for(pos = 0; pos <= 135; pos += 45){
      s1.write(pos);
      delay(15);
    }
  }
  if (servoMotor==2){
    for(pos = 0; pos <= 135; pos += 45){
      s2.write(pos);
      delay(15);
    }
  }
  return pos;
}

void servo_fechar(int servoMotor, int grau, int pos){
  if (servoMotor==1){
    for(pos = 135; pos >= 0; pos -= 45){
      s1.write(pos);
      delay(15);
    }
  }
  if (servoMotor==2){
    for(pos = 135; pos >= 0; pos  -= 45){
      s2.write(pos);
      delay(15);
    }
  }
}

void servo (int servoMotor){
  int pos = servo_abrir(servoMotor, 90);
  delay(800); // Espera para Fechar
  servo_fechar(servoMotor, 90, pos);
}
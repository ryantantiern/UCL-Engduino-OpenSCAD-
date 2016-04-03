#include <EngduinoLight.h>
#include <EngduinoLEDs.h>
#include <EngduinoButton.h>


int lightIntensity;
int temp;
int gate;
void setup() {
  EngduinoLEDs.begin();
  EngduinoLight.begin();
  EngduinoButton.begin();
  Serial.begin(9600);
  gate = 0;


}
void loop() { 
  lightIntensity = EngduinoLight.lightLevel();
  Serial.print(lightIntensity);
  Serial.println();
  EngduinoLEDs.setLED( 9, GREEN, 1 ); //indicates Engduino is on
  if(EngduinoButton.wasPressed()){
    gate = gate + 1;
    if(gate > 3){
      gate = 0;
    }
  }
  int number = -123;
  switch(gate){
    case 0:
      Serial.print(number);
      Serial.println();
      break;
    case 1:
      Serial.print(number-1);
      Serial.println();
      break;
    case 2:
      Serial.print(number-2);
      Serial.println();
      break;
    case 3:
      Serial.print(number-3);
      Serial.println();
      break;  
    }

}
 





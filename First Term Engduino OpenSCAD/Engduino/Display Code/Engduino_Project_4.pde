

import processing.serial.*;

Serial myPort;
int [] pastData;
int currentIndex = 0;
String screen;


int min_x = 100;
int max_x = 400;
int min_y = 50;
int max_y = 300;
int verticalLength = max_y - min_y; 
int horizontalLength = max_x - min_x; 
int len = max_x - min_x;
int width_interval;
int contrasting =20;

String inString;
int check;
int lightIntensity;

float dy;
float previousY;
float brightness;
int gate;



void setup(){
  size( 840, 400);  
  myPort = new Serial(this, Serial.list()[0], 9600);
  // Throw out the first reading in case we start reading from the middle of a string.
  myPort.readStringUntil('\n');
  myPort.bufferUntil('\n');
  frameRate(60);
  pastData = new int[len];
  pastData[len-1] = 12345;
}

void serialEvent(Serial port) {
  inString = port.readStringUntil('\n');
  inString = trim(inString);  // Get rid of extra spaces
  try {
    check = Integer.parseInt(inString); // Split data into plotable and brightness mode
    if (check > -1){
      lightIntensity = check;
    }
    else{
    int i = 0;
    for( i=0; i < 4; i++){
      if(check == -123-i){
        gate = i;
      }
    } 
    
    switch(gate){
      case 0:
        brightness = (float(255)/1000) * lightIntensity;
        screen = "Auto";
        break;
      case 1:
        brightness = 255;
        screen = "Bright";
        break;
      case 2:        
        brightness = 200;
        screen = "Medium";
        break;
      case 3 :
        brightness = 20;
        screen = "Dark";
        break;
    }
    }
    if ( currentIndex != len ){
     pastData[currentIndex] = lightIntensity;
     currentIndex++;
    }
  } catch (Exception e) { 
    println("Discarding input:");
    println(inString);
  }
}

void draw(){
  
  background(brightness + contrasting);
  if (brightness > 255/2){
    fill(0x0);
  }
  else{
    fill(0xff);
  }
  text("LIGHT SENSOR", horizontalLength/2 + 55, min_y -10);
  text("Light Intensity is: " + lightIntensity, width/2, height/2);
  text("Backlight mode: " + screen, max_x - 20, min_y -10 );
 

  renderAxes();
  renderGrids();
  plotLine();
  
  
}


void renderAxes(){  
  stroke(255-brightness);
  line(min_x, min_y, min_x, max_y); 
  line(min_x, max_y, max_x, max_y);

  text("1000", min_x - 30, min_y);
  text("0", min_x -20, max_y);
}


void renderGrids(){
  //Vertical lines
  width_interval = 10;
  int number_of_horiLines = horizontalLength / width_interval;
  int i = 1;
  while(i <= number_of_horiLines){
    stroke(255/3);
    line( min_x + width_interval - frameCount%10, min_y, min_x + width_interval- frameCount%10, max_y-1); // Constantly moves vertical grids to the left
    width_interval += 10;
    i++;
  }
  
  
  //Horizontal Lines
  width_interval = 10;
  int number_of_vertLines = verticalLength / width_interval;
  stroke((255 - brightness)/3);
  line( min_x, min_y, max_x, min_y);
  int j = 0;
  while( j < number_of_vertLines -1){
    stroke((255 - brightness)/3);
    line( min_x, min_y + width_interval, max_x, min_y + width_interval);
    width_interval += 10;
    j++;
  }
}


void plotLine(){
  if (pastData[len-1] != 12345){ // Ensure line is not plotted until array is full
    int i = 1;
    for ( i = 1; i < len ; i ++){
      previousY = ((float(verticalLength)/1000) * pastData[i-1]);// Scale light intensity 
      dy = ((float(verticalLength)/1000) * pastData[i]);         // to the graph 
      stroke(0,0,255);
      line(min_x + i, (max_y - previousY) , min_x + i + 1, (max_y -dy));
      pastData[i-1] = pastData[i];  
      pastData[len-1] = lightIntensity;
    }
  }
}
  
  

    
  
  

  
  
  

    
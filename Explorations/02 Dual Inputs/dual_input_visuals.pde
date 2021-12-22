//  PROJECT IXORA – EXPLORATIONS
//  Dual Input (Visuals) v1.0
//  Based on Exploration 01 - Dynamic Shape

import processing.serial.*;

int canvasWidth = 600;
int canvasHeight = 600;

float angleIncrement;
float blendStage;
float strokeWeight;

float minDiameter = canvasWidth/25;
float maxDiameter = canvasWidth * 0.85;
float angle = 0;

color red = #ff1454;
color yellow = #ffce14;
color black = #1f232a;

Serial serialPort;      // Create object from Serial class
String serialValue_1;   // First data to be received from the serial port
String serialValue_2;   // Second data to be received from the serial port
int serialMax = 50;     // Set maximum expected value from serial

boolean serialMode = false;
boolean outlineMode = true;
boolean overlapMode = false;

void settings() {
  size(canvasWidth, canvasHeight);
  pixelDensity(displayDensity());
}

void setup() {
  //serial port setup
  String portName = Serial.list()[1];  //change 0 to 1 or 2 to match port
  serialPort = new Serial(this, portName, 9600);
  
  background(black);
}

void draw() {
  if(!overlapMode){
    background(black);
  }
  // animate diameter based on the sine of an angle as it goes around a circle
  float animDiameter = minDiameter + (sin(angle + PI/2) * maxDiameter/2) + maxDiameter/2;
  
  if(!outlineMode){
    noStroke();
    fill(lerpColor(red, yellow, blendStage));
    ellipse(width/2, height/2, animDiameter, animDiameter);
  } else {
    noFill();
    stroke(lerpColor(red, yellow, blendStage));
    strokeWeight(strokeWeight);
    ellipse(width/2, height/2, animDiameter, animDiameter);
  }
  
  //check to see if serial port connection exists
  if(serialPort.available() > 0) {
    serialMode = true;
  }
  
  //default to mouse input when serial input is not present
  if(!serialMode){
    // remaps mouseY to a value between 0.02 and 0.05 
    angleIncrement = map(mouseY, height, 0, 0.02, 0.05);
    // remaps mouseX to a value between 0 and 1
    blendStage = map(mouseX, 0, width, 0, 1);
    // remaps mouseX to a value between 1 and 10
    strokeWeight = map(mouseX, 0, width, 1, 10);
  } else {
    //use sensor values if serial input is present
    serialValue_1 = serialPort.readStringUntil('\t');
    serialValue_2 = serialPort.readStringUntil('\n');
    
     //prevent NullPointerException
    if(serialValue_1 == null || serialValue_2 == null){
      return;
    }else{
      // remaps serialValue_1 to a value between 0.02 and 0.05 
      angleIncrement = map(float(serialValue_1), 0, serialMax, 0.02, 0.05);
      // remaps serialValue_2 to a value between 0 and 1
      blendStage = map(float(serialValue_2), 0, serialMax, 0, 1);
      // remaps mouseX to a value between 1 and 10
      strokeWeight = map(float(serialValue_2), 0, serialMax, 1, 10);
      
      delay(25);  //set to half of serial input delay
    }
  }
  
  // increase angle every frame by angle increment
  angle += angleIncrement;
}

void keyPressed(){
  //toggle outlines when 'O' key is pressed
  if(key == 'o' || key == 'O'){
    outlineMode = !outlineMode;
  }
  //toggle overlaps when 'P' key is pressed
  if(key == 'p' || key == 'P'){
    overlapMode = !overlapMode;
  }
}

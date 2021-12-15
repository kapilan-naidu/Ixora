//  PROJECT IXORA – EXPLORATIONS
//  Dynamic Shape (Visuals) v1.3

import processing.serial.*;

int canvasWidth = 600;
int canvasHeight = 600;

float shapeScale;
float cornerRadius;
float lerpTarget;

float shapeMinSize = canvasWidth/25;
float shapeMaxSize = canvasWidth * 0.9;

color red = #ff1454;
color blue = #007cff;
color black = #1f232a;

Serial serialPort;      // Create object from Serial class
String serialValue;     // Data to be received from the serial port
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
  rectMode(CENTER);
  
  if(!outlineMode){
    noStroke();
    fill(lerpColor(red, blue, shapeScale/canvasWidth));
    rect(canvasWidth/2, canvasHeight/2, shapeScale, shapeScale, cornerRadius);
  } else {
    noFill();
    stroke(255);
    strokeWeight(2);
    rect(canvasWidth/2, canvasHeight/2, shapeScale, shapeScale, cornerRadius);
  }
  
  //check to see if serial port connection exists
  if(serialPort.available() > 0) {
    serialMode = true;
  }
  
  //default to mouse input when serial input is not present
  if(!serialMode) {
    shapeScale = mouseX;
    cornerRadius = canvasWidth-shapeScale * 1.25;
  }else{
    //use sensor values if serial input is present
    serialValue = serialPort.readStringUntil('\n');
   
    //prevent NullPointerException
    if(serialValue == null){
      return;
    }else{
      lerpTarget = float(serialValue)/serialMax * canvasWidth;
      shapeScale = lerp(shapeScale, lerpTarget, 0.2);
      cornerRadius = canvasWidth-shapeScale * 1.25;
      
      delay(25);  //set to half of serial input delay
    }
  }
  
  //clamp shape size and corner radius
  if(shapeScale < shapeMinSize) {
    shapeScale = shapeMinSize;
  }
  
  if(shapeScale > shapeMaxSize) {
    shapeScale = shapeMaxSize;
  }
  
  if(cornerRadius < 0) {
    cornerRadius = 0;
  }
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

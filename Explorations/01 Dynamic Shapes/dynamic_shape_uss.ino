//  PROJECT IXORA – EXPLORATIONS
//  Dynamic Shape (Ultrasonic Sensor) v1.3

#include <Wire.h> 

// Ultrasonic sensor constants & variables

#define echoPin 3   // attach pin D3 Arduino to pin Echo of HC-SR04
#define trigPin 2   // attach pin D2 Arduino to pin Trig of HC-SR04
long duration;      // variable for the duration of sound wave travel
int distance;       // variable for the distance measurement

#define LOW_MID_THRESHOLD 30
#define MID_HIGH_THRESHOLD 100

void setup() {

  //initialize sensor
  pinMode(trigPin, OUTPUT);   // Sets the trigPin as an OUTPUT
  pinMode(echoPin, INPUT);    // Sets the echoPin as an INPUT
  Serial.begin(9600);         // Serial Communication is starting with 9600 of baudrate speed
}

void loop() {
  // Sensor distance calculation
  distance = calcDistance();
  // Caps distance value at 200
  if (distance > 50) {
    distance = 50;
  }

  // Displays the distance on the Serial Monitor
  Serial.println(distance);

  //Serial.print("Distance: ");
  //Serial.println(" cm"); 

  delay(50);
}

int calcDistance() {
  // Clears the trigPin condition
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  // Sets the trigPin HIGH (ACTIVE) for 10 microseconds
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  // Reads the echoPin, returns the sound wave travel time in microseconds
  duration = pulseIn(echoPin, HIGH);
  // Calculating the distance
  return duration * 0.034 / 2; // Speed of sound wave divided by 2 (go and back)
}

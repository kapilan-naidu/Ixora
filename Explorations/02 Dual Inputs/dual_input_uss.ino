//  PROJECT IXORA – EXPLORATIONS
//  Dual Input (Ultrasonic Sensor) v1.0
//  Based on Exploration O1 – Dynamic Shape

#include <Wire.h> 

// Ultrasonic sensor constants & variables

#define echoPin_1 3   // attach pin D3 Arduino to pin Echo of HC-SR04
#define trigPin_1 2   // attach pin D2 Arduino to pin Trig of HC-SR04

#define echoPin_2 5   // attach pin D5 Arduino to pin Echo of HC-SR04
#define trigPin_2 4   // attach pin D4 Arduino to pin Trig of HC-SR04

long duration_1;      // variable for the duration of sound wave travel
int distance_1;       // variable for the distance measurement

long duration_2;      // variable for the duration of sound wave travel
int distance_2;       // variable for the distance measurement

String distMeasurement_1;
String distMeasurement_2;

#define LOW_MID_THRESHOLD 30
#define MID_HIGH_THRESHOLD 100

void setup() {

  //initialize sensor
  pinMode(trigPin_1, OUTPUT);   // Sets the trigPin as an OUTPUT
  pinMode(echoPin_1, INPUT);    // Sets the echoPin as an INPUT

  pinMode(trigPin_2, OUTPUT);   // Sets the trigPin as an OUTPUT
  pinMode(echoPin_2, INPUT);    // Sets the echoPin as an INPUT
  
  Serial.begin(9600);         // Serial Communication is starting with 9600 of baudrate speed
}

void loop() {
  // Displays the distance on the Serial Monitor
  distMeasurement_1 = reportDistance(distance_1, trigPin_1, echoPin_1, duration_1);
  distMeasurement_2 = reportDistance(distance_2, trigPin_2, echoPin_2, duration_2);
  
  Serial.println(distMeasurement_1+"\t"+distMeasurement_2);
  
  delay(50);
}

// Helper functions to calculate distance for each sensor

int calcDistance(int trigPin, int echoPin, long duration) {
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

String reportDistance(int distance, int trigPin, int echoPin, long duration) {
  // Sensor distance calculation
  distance = calcDistance(trigPin, echoPin, duration);
  // Caps distance value at 200
  if (distance > 50) {
    distance = 50;
  }
  // Reports the current distance as string
  String distanceValue = String(distance);
  return distanceValue;
}

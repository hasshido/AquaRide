#include <Servo.h>

const int stepPinX = 15; 
const int dirPinX = 21;

const int stepPinY = 22; 
const int dirPinY = 23;

const int servoPinZ = 20; 
const int servoPinA = 19; 

const int enablePin = 14;
const int stepSpeed = 100; //ms

Servo myservo;  // create servo object to control a servo
Servo myservo2;  // create servo object to control a servo

// twelve servo objects can be created on most boards
int pos = 0;    // variable to store the servo position

 
void setup() {
  // Sets the two pins as Outputs
  pinMode(stepPinX,OUTPUT); 
  pinMode(dirPinX,OUTPUT);
  
  pinMode(stepPinY,OUTPUT); 
  pinMode(dirPinY,OUTPUT);
  
  pinMode(enablePin,OUTPUT);
  digitalWrite(enablePin,LOW); 

  myservo.attach(servoPinZ);  // attaches the servo on pin 20 to the servo object 
  myservo2.attach(servoPinA);  // attaches the servo on pin 19 to the servo object

  
}

void loop() {
  digitalWrite(dirPinX,HIGH); // Enables the motor to move in a particular direction
  digitalWrite(dirPinY,HIGH); // Enables the motor to move in a particular direction
  
  for(int x = 0; x < 2000; x++) {
    digitalWrite(stepPinX,HIGH); 
    delayMicroseconds(stepSpeed); 
    digitalWrite(stepPinX,LOW); 
    delayMicroseconds(stepSpeed); 
  }
  delay(1000); // One second delay
  
  for(int x = 0; x < 2000; x++) {
    digitalWrite(stepPinY,HIGH);
    delayMicroseconds(stepSpeed);
    digitalWrite(stepPinY,LOW);
    delayMicroseconds(stepSpeed);
  }
  delay(1000);


  for (pos = 0; pos <= 180; pos += 1) { // goes from 0 degrees to 180 degrees
    // in steps of 1 degree
    myservo.write(pos);              // tell servo to go to position in variable 'pos'
    delay(15);                       // waits 15ms for the servo to reach the position
  }
  for (pos = 180; pos >= 0; pos -= 1) { // goes from 180 degrees to 0 degrees
    myservo.write(pos);              // tell servo to go to position in variable 'pos'
    delay(15);                       // waits 15ms for the servo to reach the position
  }

  delay(1000);
  for (pos = 0; pos <= 180; pos += 1) { // goes from 0 degrees to 180 degrees
    // in steps of 1 degree
    myservo2.write(pos);              // tell servo to go to position in variable 'pos'
    delay(15);                       // waits 15ms for the servo to reach the position
  }
  for (pos = 180; pos >= 0; pos -= 1) { // goes from 180 degrees to 0 degrees
    myservo2.write(pos);              // tell servo to go to position in variable 'pos'
    delay(15);                       // waits 15ms for the servo to reach the position


    
  }




  
}
























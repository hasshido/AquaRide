#include <Servo.h>

// Endstops connections
const int endStopXSIG = A0;
const int endStopXGND = A1; 

const int endStopYSIG = A2;
const int endStopYGND = A3; 

// Stepper connections
// In Driver Pins

// To set directions
const int dirPinL = 21; 
const int dirPinR = 23;

// To set steps
const int stepPinL = 15; 
const int stepPinR = 22; 


const int enablePin = 14;
const int stepSpeed = 100; //usec


// Servo Connections
// In the Z-Stop and Y-Stop Pins
const int servoPinZ = 20; 
const int servoPinA = 19; 

Servo myservoZ;  // create servo object to control a servo
Servo myservoA;  // create servo object to control a servo
// twelve servo objects can be created on most boards
int pos = 0;    // variable to store the servo position -----------------------------------------------------------------



void setup() {

  Serial.begin(115200);
  Serial.write("AQUARIDE V1.0 \n");

  // Steppers
  // Sets the stepper pins as Outputs
  pinMode(stepPinL,OUTPUT); 
  pinMode(dirPinL,OUTPUT);
  
  pinMode(stepPinR,OUTPUT); 
  pinMode(dirPinR,OUTPUT);
  
  pinMode(enablePin,OUTPUT);
  digitalWrite(enablePin,LOW); 

  // Servos

  myservoZ.attach(servoPinZ);  // attaches the servo on pin 20 to the servo object 
  myservoA.attach(servoPinA);  // attaches the servo on pin 19 to the servo object


  // Endstops
  pinMode(endStopXSIG,INPUT_PULLUP);
  
  pinMode(endStopXGND,OUTPUT);
  digitalWrite(endStopXGND,LOW); 

  pinMode(endStopYSIG,INPUT_PULLUP);
  
  pinMode(endStopYGND,OUTPUT);
  digitalWrite(endStopYGND,LOW); 

}

void loop(){

  // Read serial Imput
  String command = "";
  command = ReadCommand();
  Serial.print("\n");
  Serial.print("Command: " + command + "\n");
  
if (command.startsWith("move")){
      Serial.println("Moving" + command.substring(4));
      moveStepper('Y', '-', 400);
      //----------------------------------------------------------------------------------------------- generar funcion MOVE
}

else if (command == "home"){
      Serial.println("Homing");
      move_home();//----------------------------------------------------------------------------------------------- generar funcion HOME
}
else if (command == "-help"){
      Serial.println("Operations Implemented:");
      Serial.println("-> home");
      Serial.println("-> move [AXIS (X,Y,Z,A)] [POSITION] ");
}
else{
    Serial.println("Unsupported operation, for help use -help");
  }

}

String ReadCommand(){
  String cmd = "";
  while (cmd == ""){  
    if(Serial.available()) {
      cmd = Serial.readStringUntil('\n');
    } 

  }
  return cmd;
}

void move_home(){

  // Steppers
  bool HomeX = false;
  bool HomeY = false;
  
  // Servos
  bool HomeZ = false;
  bool HomeA = false;

  while ((HomeX==false) || (HomeY==false)){
    if(HomeX==false){
      //-----------------------------------------------------------------------
    }
    if(HomeY==false){
       //-----------------------------------------------------------------------
     
    }
  }
  
}

void moveServo(char Axis, int Position){ // MEJORA: REDUCIR LA VELOCIDAD DE MOVIMIENTO
  
//      moveServo('Z', 1);
//      moveServo('Z', 45);
//      moveServo('Z', 120);
  

switch (Axis) {
    case 'Z':
      myservoZ.write(Position);         // tell servo to go to position in variable 'pos'
      delay(500);                       // waits 15ms for the servo to reach the position
      
      break;
    case 'A':
      myservoA.write(Position);         // tell servo to go to position in variable 'pos'
      delay(500);                       // waits 15ms for the servo to reach the position
      
      break;
    default:
    
    Serial.println("Axis not valid");
    break;
  }
}

void moveStepper(char Axis, char Direction, int Steps){

  //------------------- Establecer direcciones de movimiento según las ecuaciones de COREXY
  int DirL=HIGH; // Left Stepper Direction
  int DirR=HIGH; // Right Stepper Direction


  switch (Axis) {
    case 'X':         
      if (Direction == '+'){
        DirL=HIGH;
        DirR=HIGH;
      } else if (Direction == '-'){
        DirL=LOW;
        DirR=LOW;
      } else{
        Serial.println("Direction invalid, please use + or -");
        return;
      }
    break;
    case 'Y':
      if (Direction == '+'){
        DirL=HIGH;
        DirR=LOW;
      } else if (Direction == '-'){
        DirL=LOW;
        DirR=HIGH;
      } else{
        Serial.println("Direction invalid, please use + or -");
        return;
      }
    break;
  default:
    Serial.println("Axis not valid");
    return;
  }

  digitalWrite(dirPinL,DirL); // Enables the motor to move in a particular direction
  digitalWrite(dirPinR,DirR); // Enables the motor to move in a particular direction

  for(int x = 0; x < Steps; x++) {
    digitalWrite(stepPinL,HIGH);
    digitalWrite(stepPinR,HIGH);  
    delayMicroseconds(stepSpeed); 
    
    digitalWrite(stepPinL,LOW);
    digitalWrite(stepPinR,LOW);  
    delayMicroseconds(stepSpeed); 
  }

}



//
//
//int sensorValue = digitalRead(endStopSIG);
//Serial.println(sensorValue, DEC);
//
//if (sensorValue == 0)
//{
//  delay(1000);
//}

  

  
//  digitalWrite(dirPinX,HIGH); // Enables the motor to move in a particular direction
//  digitalWrite(dirPinY,HIGH); // Enables the motor to move in a particular direction
//  
//  for(int x = 0; x < 2000; x++) {
//    digitalWrite(stepPinX,HIGH); 
//    delayMicroseconds(stepSpeed); 
//    digitalWrite(stepPinX,LOW); 
//    delayMicroseconds(stepSpeed); 
//  }
//  delay(1000); // One second delay
//  
//  for(int x = 0; x < 2000; x++) {
//    digitalWrite(stepPinY,HIGH);
//    delayMicroseconds(stepSpeed);
//    digitalWrite(stepPinY,LOW);
//    delayMicroseconds(stepSpeed);
//  }
//  delay(1000);
//
//
//  for (pos = 0; pos <= 180; pos += 1) { // goes from 0 degrees to 180 degrees
//    // in steps of 1 degree
//    myservo.write(pos);              // tell servo to go to position in variable 'pos'
//    delay(15);                       // waits 15ms for the servo to reach the position
//  }
//  for (pos = 180; pos >= 0; pos -= 1) { // goes from 180 degrees to 0 degrees
//    myservo.write(pos);              // tell servo to go to position in variable 'pos'
//    delay(15);                       // waits 15ms for the servo to reach the position
//  }
//
//  delay(1000);
//  for (pos = 0; pos <= 180; pos += 1) { // goes from 0 degrees to 180 degrees
//    // in steps of 1 degree
//    myservo2.write(pos);              // tell servo to go to position in variable 'pos'
//    delay(15);                       // waits 15ms for the servo to reach the position
//  }
//  for (pos = 180; pos >= 0; pos -= 1) { // goes from 180 degrees to 0 degrees
//    myservo2.write(pos);              // tell servo to go to position in variable 'pos'
//    delay(15);                       // waits 15ms for the servo to reach the position
//
//
//    
//  }
//
//






















#include <Servo.h>
// Position

int CoreXY_Pos[4] = {0, 0, 0, 0}; // X(steps), Y(steps, Z(deg, 1-180), A(deg, 1-180)
const int Aquarium_stepsX = 4000;
const int Aquarium_stepsY = 4000;

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


String ReadSerialCommand() {
  String cmd = "";
  while (cmd == "") {
    if (Serial.available()) {
      cmd = Serial.readStringUntil('\n');
    }
  }
  return cmd;
}

void ParseParameters(String* parameters, String command) {
  int index = 0; int lastIndex = 0;
  int paramNum = 0;
  while ((index != -1) and (paramNum < (int)command.length())) {
    lastIndex = index;
    index =  command.indexOf(' ', index + 1);

    if (paramNum != 0) lastIndex++;
    parameters[paramNum] = command.substring(lastIndex, index);
    // Last parameter
    if (index == -1) {
      parameters[paramNum] = command.substring(lastIndex);
    }
    //    Serial.print("li:");
    //    Serial.println(lastIndex);
    //    Serial.print("i:");
    //    Serial.println(index);
    //    Serial.print("pN:");
    //    Serial.println(paramNum);
    //    Serial.print("param(paramNum):");
    //    Serial.println(parameters[paramNum]);
    paramNum++;
  }
  return;
}


bool checkEndStop(int endStopSIG)
{
  bool sensorValue;
  sensorValue = digitalRead(endStopSIG);
  if (sensorValue == false)
  {
    delay(500);
  }
  return sensorValue;
}


void moveMotor(String* parameters) {
  if ((parameters[1] == "X") or (parameters[1] == "Y")) {
    moveStepper(parameters[1].charAt(0), parameters[2].charAt(0), parameters[3].toInt(), false);
  }
  else if ((parameters[1] == "Z") or (parameters[1] == "A")) {
    moveServo(parameters[1].charAt(0), parameters[2].toInt());
  }
  return;
}

void moveServo(char Axis, int Position) {

  // MEJORA: REDUCIR LA VELOCIDAD DE MOVIMIENTO
  //      moveServo('Z', 1);
  //      moveServo('Z', 45);
  //      moveServo('Z', 120);
  Position = max(0, Position);
  Position = min(179, Position);

  switch (Axis) {
    case 'Z':
      myservoZ.write(Position);         // tell servo to go to position in variable 'pos'
      CoreXY_Pos[2] = Position;         // X(steps), Y(steps, Z(deg, 1-180), A(deg, 1-180)
      delay(500);                       // waits 15ms for the servo to reach the position

      break;
    case 'A':
      myservoA.write(Position);         // tell servo to go to position in variable 'pos'
      CoreXY_Pos[3] = Position;         // X(steps), Y(steps, Z(deg, 1-180), A(deg, 1-180)
      delay(500);                       // waits 15ms for the servo to reach the position

      break;
    default:

      Serial.println("Axis not valid");
      break;
  }

  return;
}


void moveStepper(char Axis, char Direction, int Steps, bool homing) {

  int DirL = HIGH; // Left Stepper Direction
  int DirR = HIGH; // Right Stepper Direction

  int MaxSteps = Steps; // Standard no dimension-limited case


  switch (Axis) {
    case 'X':
      if (Direction == '+') {
        DirL = LOW;
        DirR = LOW;

        if ((CoreXY_Pos[0] + Steps >= Aquarium_stepsX) and (homing == false)) { // If we try to exceed the Aquarium dimensions
          MaxSteps = Aquarium_stepsX - CoreXY_Pos[0]; // we just take the remaining steps
          Serial.println("End of X reached (max)");
        }
        CoreXY_Pos[0] = CoreXY_Pos[0] + MaxSteps;       // X(steps), Y(steps, Z(deg, 1-180), A(deg, 1-180)



      } else if (Direction == '-') {

        DirL = HIGH;
        DirR = HIGH;

        if ((CoreXY_Pos[0] - Steps <= 0) and (homing == false)) { // If we try to exceed the Aquarium dimensions
          MaxSteps = CoreXY_Pos[0];     // we just take the remaining steps
          Serial.println("End of X reached (0)");
        }
        CoreXY_Pos[0] = CoreXY_Pos[0] - MaxSteps;       // X(steps), Y(steps, Z(deg, 1-180), A(deg, 1-180)
      } else {
        Serial.println("Direction invalid, please use + or -");
        return;
      }
      break;
    case 'Y':
      if (Direction == '+') {
        DirL = LOW;
        DirR = HIGH;

        if ((CoreXY_Pos[1] + Steps >= Aquarium_stepsY) and (homing == false)) { // If we try to exceed the Aquarium dimensions
          MaxSteps = Aquarium_stepsY - CoreXY_Pos[1]; // we just take the remaining steps
          Serial.println("End of Y reached (max)");
        }
        CoreXY_Pos[1] = CoreXY_Pos[1] + MaxSteps;       // X(steps), Y(steps, Z(deg, 1-180), A(deg, 1-180)
      } else if (Direction == '-') {

        DirL = HIGH;
        DirR = LOW;

        if ((CoreXY_Pos[1] - Steps <= 0) and (homing == false)) { // If we try to exceed the Aquarium dimensions
          MaxSteps = CoreXY_Pos[1];     // we just take the remaining steps
          Serial.println("End of Y reached (0)");
        }
        CoreXY_Pos[1] = CoreXY_Pos[1] - MaxSteps;       // X(steps), Y(steps, Z(deg, 1-180), A(deg, 1-180)
      } else {
        Serial.println("Direction invalid, please use + or -");
        return;
      }
      break;
    default:
      Serial.println("Axis not valid");
      return;
  }

  digitalWrite(dirPinL, DirL); // Enables the motor to move in a particular direction
  digitalWrite(dirPinR, DirR); // Enables the motor to move in a particular direction

  for (int x = 0; x < MaxSteps; x++) {
    digitalWrite(stepPinL, HIGH);
    digitalWrite(stepPinR, HIGH);
    delayMicroseconds(stepSpeed);

    digitalWrite(stepPinL, LOW);
    digitalWrite(stepPinR, LOW);
    delayMicroseconds(stepSpeed);
  }
  return;
}

void move_home() {
  // Steppers
  bool HomeX = false;
  bool HomeY = false;


  while (HomeX == false) {
    moveStepper('X', '-', 1, true);
    if (!checkEndStop(endStopXSIG)) {
      HomeX = true;
      CoreXY_Pos[0] = 0;       // X(steps), Y(steps, Z(deg, 1-180), A(deg, 1-180)

    }
  }
  while (HomeY == false) {
    moveStepper('Y', '-', 1, true);
    if (!checkEndStop(endStopYSIG)) {
      HomeY = true;
      CoreXY_Pos[1] = 0;
    }
  }
  Serial.println("Home position reached");
  return;


}




void setup() {

  Serial.begin(115200);
  Serial.write("AQUARIDE V1.0 \n");

  // Steppers
  // Sets the stepper pins as Outputs
  pinMode(stepPinL, OUTPUT);
  pinMode(dirPinL, OUTPUT);

  pinMode(stepPinR, OUTPUT);
  pinMode(dirPinR, OUTPUT);

  pinMode(enablePin, OUTPUT);
  digitalWrite(enablePin, LOW);

  // Servos

  myservoZ.attach(servoPinZ);  // attaches the servo on pin 20 to the servo object
  myservoA.attach(servoPinA);  // attaches the servo on pin 19 to the servo object


  // Endstops
  pinMode(endStopXSIG, INPUT_PULLUP);

  pinMode(endStopXGND, OUTPUT);
  digitalWrite(endStopXGND, LOW);

  pinMode(endStopYSIG, INPUT_PULLUP);

  pinMode(endStopYGND, OUTPUT);
  digitalWrite(endStopYGND, LOW);

}

void loop() {

  String command = "";
  command = ReadSerialCommand();

  Serial.print("\n");
  Serial.print("Command:");
  Serial.println(command);

  // String array to store parameters
  String parameters[command.length()];
  for (int i = 0; i < (int)command.length(); i++) {
    parameters[i] = "";
  }

  ParseParameters(parameters, command);
  //Serial.println(parameters[i]);
  if (parameters[0] == "move") {
    Serial.println("Moving");
    moveMotor(parameters);
  }
  else if (parameters[0] == "home") {
    Serial.println("Homing");
    move_home();
  }
  else if (command == "-help") {
    Serial.println("Operations Implemented:");
    Serial.println("-> home");
    Serial.println("-> move [AXIS (X,Y)] [POSITION(0,179)] ");
    Serial.println("-> move [AXIS (Z,A)] [DIRECTION(+,-)] [STEPS] ");
  }
  else {
    Serial.println("Unsupported operation, for help use -help");
  }
}


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






















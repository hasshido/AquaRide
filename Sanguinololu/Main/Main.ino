#include <Servo.h>

// Position
long CoreXY_Pos[4] = {0, 0, 0, 90}; // X(steps), Y(steps, Z(steps), A(deg, 1-180)
const long Aquarium_stepsX = 15300;
const long Aquarium_stepsY = 13300;
const long Aquarium_stepsZ = 8300;

// Endstops connections
const int endStopXSIG = A4;
// const int endStopXGND = A1; //

const int Probe0 = A0; // Emitter 1 // Red and white
const int Probe1 = A1; // ADC 1     // brown
const int Probe2 = A2; // ADC 2     // brown and black
const int Probe3 = A3; // Emitter 2 // white

const int endStopYSIG = 10;
const int endStopYGND = 11;

const int endStopZSIG = 16; // PC0-SCL
const int endStopZGND = 17; // PC1-SDA

// Stepper connections
// In Driver Pins

const int enablePin = 14;
const int stepSpeed = 300; //usec
const int stepSpeedZ = 500; //more value means slower movement

// To set directions L=Left, R=Right, Z=Up
const int dirPinL = 21;
const int dirPinR = 23;
const int dirPinZ = 2;

// To step
const int stepPinL = 15;
const int stepPinR = 22;
const int stepPinZ = 3;

// Servo Connections
// In the Z-Stop Pins

const int servoPinA = 20;
const int ServoSpeedA = 10; //ms, more value means slower movement

Servo myservoA;

static inline int8_t sgn(int val) {
  if (val < 0) return -1;
  if (val == 0) return 0;
  return 1;
}

int AnalogReadAverage(int Pin, int Samples) {
  int i = 0;
  float average = 0;
  float Measures = 0;
  float Aux = 0;
  for (i = 0; i < Samples; i++) {
    Aux = analogRead(Pin);
    delay(1);
    Measures = Measures + Aux;
  }
  average = Measures / Samples;
  return average;
}

void GetVoltages(int Samples = 1) {
  long Vdip[5];  //Voltage in A1, A1, A2 with no voltage applied
  long V10; long V13;  //Voltage in A1, 5V in A0/A3
  long V20; long V23;  //Voltage in A2, 5V in A0/A3
  long i;
  long averageSamples = Samples;
  //for (i = 0; i < Samples; i++) {

    //A0 = 5v
    digitalWrite(Probe3, LOW);
    digitalWrite(Probe0, LOW);
    delay(1);
    //    Vdip[0]=AnalogReadAverage(Probe0, averageSamples)-AnalogReadAverage(Probe3, averageSamples);

    //A0 = 5v
    digitalWrite(Probe3, LOW);
    digitalWrite(Probe0, HIGH);
    delay(1);
    V10 = AnalogReadAverage(Probe1, averageSamples);
    V20 = AnalogReadAverage(Probe2, averageSamples);
    //    Vdip[1]=AnalogReadAverage(Probe0, averageSamples)-AnalogReadAverage(Probe3, averageSamples);

    digitalWrite(Probe3, LOW);
    digitalWrite(Probe0, LOW);
    delay(1);
    //    Vdip[2]=AnalogReadAverage(Probe0, averageSamples)-AnalogReadAverage(Probe3, averageSamples);

    //A1 = 5v
    digitalWrite(Probe3, HIGH);
    digitalWrite(Probe0, LOW);
    delay(1);
    //    Vdip[3]=AnalogReadAverage(Probe0, averageSamples)-AnalogReadAverage(Probe3, averageSamples);
    V13 = AnalogReadAverage(Probe1, averageSamples);
    V23 = AnalogReadAverage(Probe2, averageSamples);

    digitalWrite(Probe3, LOW);
    digitalWrite(Probe0, LOW);
    //    Vdip[4]=AnalogReadAverage(Probe0, averageSamples)-AnalogReadAverage(Probe3, averageSamples);

    // Send data via serial
    // Serial.print("Pos= ");
    Serial.print("DATA:\t");  Serial.print(CoreXY_Pos[0]); Serial.print("\t"); Serial.print(CoreXY_Pos[1]); Serial.print("\t");
    Serial.print(CoreXY_Pos[2]); Serial.print("\t"); Serial.print(CoreXY_Pos[3]);

    // Serial.print("V10,V20,V13,V23\t");
    Serial.print("\t"); Serial.print(V10); Serial.print("\t"); Serial.print(V20);
    Serial.print("\t"); Serial.print(V13); Serial.print("\t"); Serial.println(V23);

    //    Serial.print("Vdip:\t"); Serial.print(Vdip[0]); Serial.print("\t"); Serial.print(Vdip[1]);
    //    Serial.print("\t"); Serial.print(Vdip[2]); Serial.print("\t"); Serial.print(Vdip[3]);Serial.print("\t"); Serial.println(Vdip[4]);
  //  delay(100);
  //}
}



String ReadSerialCommand() {
  Serial.println("Please, enter any command. Check -help for instructions");
  Serial.println("IDLE");
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

  return sensorValue;
}


void moveMotor(String* parameters) {
  if ((parameters[1] == "X") or (parameters[1] == "Y") or (parameters[1] == "Z")) {
    moveStepper(parameters[1].charAt(0), parameters[2].charAt(0), parameters[3].toFloat(), false);
  }
  else if (parameters[1] == "A") {
    moveServo(parameters[1].charAt(0), parameters[2].toInt());
  }
  return;
}

void moveServo(char Axis, int Position) {

  //      moveServo('Z', 1);
  //      moveServo('Z', 45);
  //      moveServo('Z', 120);

  Position = max(0, Position);
  Position = min(179, Position);
  int pos = 0;
  int sign = 1;

  switch (Axis) {
    //    case 'Z':
    //      sign = ((Position-CoreXY_Pos[2])/abs((Position-CoreXY_Pos[2])));
    //      for (pos = CoreXY_Pos[2]; pos != Position; pos += sign) { // goes from Actual position to new one
    //        myservoZ.write(pos);
    //        delay(ServoSpeedZ);
    //      }
    //      CoreXY_Pos[2] = Position;         // X(steps), Y(steps, Z(steps), A(deg, 1-180)
    //
    //      break;
    case 'A':
      sign = ((Position - CoreXY_Pos[3]) / abs((Position - CoreXY_Pos[3])));
      for (pos = CoreXY_Pos[3]; pos != Position; pos += sign ) { // goes from Actual position to new one
        myservoA.write(pos);
        delay(ServoSpeedA);
      }
      CoreXY_Pos[3] = Position;         // X(steps), Y(steps, Z(steps), A(deg, 1-180)
      break;
    default:
      Serial.println("Error: Axis not valid");
      break;
  }

  return;
}


void moveStepper(char Axis, char Direction, long Steps, bool homing) {

  bool DirL = HIGH; // Left Stepper Direction
  bool DirR = HIGH; // Right Stepper Direction
  bool DirZ = HIGH; // Upper Stepper Direction

  long MaxSteps = Steps; // Standard no dimension-limited case


  switch (Axis) {
    case 'X':
      if (Direction == '+') {
        DirL = LOW;
        DirR = LOW;

        if ((CoreXY_Pos[0] + Steps >= Aquarium_stepsX) and (homing == false)) { // If we try to exceed the Aquarium dimensions
          MaxSteps = Aquarium_stepsX - CoreXY_Pos[0]; // we just take the remaining steps
          Serial.println("End of X reached (max)");
        }
        CoreXY_Pos[0] = CoreXY_Pos[0] + MaxSteps;

      } else if (Direction == '-') {

        DirL = HIGH;
        DirR = HIGH;

        if ((CoreXY_Pos[0] - Steps <= 0) and (homing == false)) { // If we try to exceed the Aquarium dimensions
          MaxSteps = CoreXY_Pos[0];     // we just take the remaining steps
          Serial.println("End of X reached (0)");
        }
        CoreXY_Pos[0] = CoreXY_Pos[0] - MaxSteps;       // X(steps), Y(steps, Z(steps), A(deg, 1-180)
      } else {
        Serial.println("Error: Direction invalid, please use + or -");
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
        CoreXY_Pos[1] = CoreXY_Pos[1] + MaxSteps;       // X(steps), Y(steps, Z(steps), A(deg, 1-180)
      } else if (Direction == '-') {

        DirL = HIGH;
        DirR = LOW;

        if ((CoreXY_Pos[1] - Steps <= 0) and (homing == false)) { // If we try to exceed the Aquarium dimensions
          MaxSteps = CoreXY_Pos[1];     // we just take the remaining steps
          Serial.println("End of Y reached (0)");
        }
        CoreXY_Pos[1] = CoreXY_Pos[1] - MaxSteps;       // X(steps), Y(steps, Z(steps), A(deg, 1-180)
      } else {
        Serial.println("Error: Direction invalid, please use + or -");
        return;
      }
      break;

    case 'Z':
      if (Direction == '+') {
        DirZ = HIGH;

        if ((CoreXY_Pos[2] + Steps >= Aquarium_stepsZ) and (homing == false)) { // If we try to exceed the Aquarium dimensions
          MaxSteps = Aquarium_stepsZ - CoreXY_Pos[2]; // we just take the remaining steps
          Serial.println("Top of Z reached");
        }
        CoreXY_Pos[2] = CoreXY_Pos[2] + MaxSteps;

      } else if (Direction == '-') {

        DirZ = LOW;

        if ((CoreXY_Pos[2] - Steps <= 0) and (homing == false)) { // If we try to exceed the Aquarium dimensions
          MaxSteps = CoreXY_Pos[2];     // we just take the remaining steps
          Serial.println("Bottom of Z reached");
        }
        CoreXY_Pos[2] = CoreXY_Pos[2] - MaxSteps;       // X(steps), Y(steps, Z(steps), A(deg, 1-180)
      } else {
        Serial.println("Error: Direction invalid, please use + or -");
        return;
      }
      break;

    default:
      Serial.println("Error: Axis not valid");
      return;
  }

  digitalWrite(dirPinL, DirL); // Enables the motor to move in a particular direction
  digitalWrite(dirPinR, DirR); // Enables the motor to move in a particular direction
  digitalWrite(dirPinZ, DirZ); // Enables the motor to move in a particular direction

  if ((Axis == 'X') or (Axis == 'Y')) {
    for (int x = 0; x < MaxSteps; x++) {
      digitalWrite(stepPinL, HIGH);
      digitalWrite(stepPinR, HIGH);
      delayMicroseconds(stepSpeed);

      digitalWrite(stepPinL, LOW);
      digitalWrite(stepPinR, LOW);
      delayMicroseconds(stepSpeed);
    }
  } else if (Axis == 'Z')
  {
    for (int x = 0; x < MaxSteps; x++) {
      digitalWrite(stepPinZ, HIGH);
      delayMicroseconds(stepSpeedZ);

      digitalWrite(stepPinZ, LOW);
      delayMicroseconds(stepSpeedZ);
    }
  }

  return;
}

void move_home(bool deviation = false) {
  // Steppers
  bool HomeX = false;
  bool HomeY = false;
  bool HomeZ = false;

  long Xdif = CoreXY_Pos[0];
  long Ydif = CoreXY_Pos[1];
  long Zdif = CoreXY_Pos[2];

  while (HomeY == false) {
    moveStepper('Y', '-', 1, true);
    if (checkEndStop(endStopYSIG)) {
      HomeY = true;
      CoreXY_Pos[1] = 0;
    }
    Ydif = Ydif - 1;
  }

  while (HomeX == false) {
    moveStepper('X', '-', 1, true);
    if (checkEndStop(endStopXSIG)) {
      HomeX = true;
      CoreXY_Pos[0] = 0;       // X(steps), Y(steps), Z(steps), A(deg, 1-180)
    }
    Xdif = Xdif - 1;
  }

  while (HomeZ == false) {
    moveStepper('Z', '-', 1, true);
    if (checkEndStop(endStopZSIG)) {
      HomeZ = true;
      CoreXY_Pos[2] = 0;       // X(steps), Y(steps), Z(steps), A(deg, 1-180)
    }
    Zdif = Zdif - 1;
  }

  if (deviation == true) {
    Serial.print("ΔX steps :\t"); Serial.println(Xdif);
    Serial.print("ΔY steps :\t"); Serial.println(Ydif);
    Serial.print("ΔZ steps :\t"); Serial.println(Zdif);
  } else {
    Serial.println("Home position located");
  }
  return;
}

void run_test(int cycles = 0) {
  int i = 0;
  long XtotalSteps = 0;
  long YtotalSteps = 0;
  long ZtotalSteps = 0;

  moveStepper('Z', '-', (Aquarium_stepsZ), false);
  moveStepper('Z', '+', (Aquarium_stepsZ * 0.2), false);

  moveStepper('Y', '-', (Aquarium_stepsY), false);
  moveStepper('X', '-', (Aquarium_stepsX), false);
  moveStepper('Y', '+', (Aquarium_stepsY / 8), false);
  moveStepper('X', '+', (Aquarium_stepsX / 8), false);


  Serial.print("Number of cycles for the test: "); Serial.println(cycles);
  for (i = 0; i < cycles; i++) {

    moveStepper('X', '+', ((Aquarium_stepsX * 3) / 4), false);
    moveStepper('Y', '+', ((Aquarium_stepsY * 3) / 4), false);
    moveStepper('Z', '+', (Aquarium_stepsZ * 0.6), false);

    moveStepper('X', '-', ((Aquarium_stepsX * 3) / 4), false);
    moveStepper('Y', '-', ((Aquarium_stepsY * 3) / 4), false);
    moveStepper('Z', '-', (Aquarium_stepsZ * 0.6), false);
    Serial.print("Cycle: "); Serial.println(i);
  }

  XtotalSteps = (Aquarium_stepsZ * 0.2) + (Aquarium_stepsX * 1.2) * cycles;
  YtotalSteps = (Aquarium_stepsY / 8) + (Aquarium_stepsY * 3 / 2) * cycles;
  ZtotalSteps = (Aquarium_stepsY / 8) + (Aquarium_stepsY * 3 / 2) * cycles;

  move_home(true);
  Serial.print("Total X steps:"); Serial.println(XtotalSteps);
  Serial.print("Total Y steps:"); Serial.println(YtotalSteps);
  Serial.print("Total Z steps:"); Serial.println(ZtotalSteps);

}



void setup() {

  Serial.begin(115200);
  Serial.println("AQUARIDE V1.0");

  // Steppers
  // Sets the stepper pins as Outputs
  pinMode(stepPinL, OUTPUT);
  pinMode(dirPinL, OUTPUT);

  pinMode(stepPinR, OUTPUT);
  pinMode(dirPinR, OUTPUT);

  pinMode(stepPinZ, OUTPUT);
  pinMode(dirPinZ, OUTPUT);

  pinMode(enablePin, OUTPUT);
  digitalWrite(enablePin, LOW);

  // Servo
  myservoA.attach(servoPinA);  // attaches the servo on pin 19 to the servo object


  // Endstops
  pinMode(endStopXSIG, INPUT_PULLUP);


  pinMode(endStopYSIG, INPUT_PULLUP);

  pinMode(endStopYGND, OUTPUT);
  digitalWrite(endStopYGND, LOW);

  pinMode(endStopZSIG, INPUT_PULLUP);

  pinMode(endStopZGND, OUTPUT);
  digitalWrite(endStopZGND, LOW);

  // pinMode(endStopXGND, OUTPUT);
  // digitalWrite(endStopXGND, LOW); // Connected to a GND pin


  // Signal receivers

  pinMode(Probe0, OUTPUT);
  digitalWrite(Probe0, LOW);

  pinMode(Probe1, INPUT);
  pinMode(Probe2, INPUT);

  pinMode(Probe3, OUTPUT);
  digitalWrite(Probe3, LOW);

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
    move_home(false);
  }
  else if (parameters[0] == "position") {
    Serial.print("X(steps): \t"); Serial.println(CoreXY_Pos[0]);
    Serial.print("Y(steps):\t"); Serial.println(CoreXY_Pos[1]);
    Serial.print("Z(steps):\t"); Serial.println(CoreXY_Pos[2]);
    Serial.print("A(deg):\t"); Serial.println(CoreXY_Pos[3]);
  }
  else if (parameters[0] == "test") {
    run_test(parameters[1].toInt());
  }
  else if (command == "-help") {
    Serial.println("Operations Implemented:");
    Serial.println("-> home");
    Serial.println("-> sample [Number of samples]");
    Serial.println("-> position");
    Serial.println("-> test [cycle number]");
    Serial.println("-> move [AXIS (X,Y,Z)] [DIRECTION(+,-)] [STEPS]");
    Serial.println("-> move [AXIS (A)]  [POSITION(0,179)]");
  }
  else if (parameters[0] == "sample") {
    GetVoltages(parameters[1].toInt());
  }
  else {
    Serial.println("Error: Unsupported operation, for instructions use -help");
  }
}
























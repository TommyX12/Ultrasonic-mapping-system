import processing.serial.*;
import ddf.minim.*;

Minim minim;
AudioPlayer player1;
AudioPlayer player2;

int MAX_DISTANCE = 3000;
int STAGE_WIDTH = 1024;
int STAGE_HEIGHT = 768;
float angle = 0;
int[] angleBuffer = {
  90, 90, 90, 90, 90
};
float distance1 = 0;
int[] distance1Buffer = {
  0, 0, 0, 0
};
float distance2 = 0;
int[] distance2Buffer = {
  0, 0, 0, 0
};

float point1X = 0;
float point1Y = 0;
float point2X = 0;
float point2Y = 0;

float textDist = 12;

int maxDist = 300;
float distMul = 3;
float distColorMul = 1.5;
float distAlphaMul = 1;
float dotRadius = 8;

float beat1rate = maxDist;
float beat1distMul = 1;
float beat1 = 0;
float beat2rate = maxDist;
float beat2distMul = 1;
float beat2 = 0;

color bgcolor = color (0, 0, 0);

int centerX, centerY;

String comPortString;
Serial sensorPort;
Serial servoPort;

void setup() {
  size(STAGE_WIDTH, STAGE_HEIGHT);//, P2D);
  //smooth();
  rectMode(CORNER);
  ellipseMode(RADIUS);

  centerX = STAGE_WIDTH / 2;
  centerY = STAGE_HEIGHT /2;

  point1X = centerX;
  point1Y = centerY;
  point2X = centerX;
  point2Y = centerY;

  //sensorPort = new Serial(this, loadStrings("port.txt")[0], 9600);
  //sensorPort.bufferUntil('\n'); // Trigger a SerialEvent on new line
  
  //servoPort = new Serial(this, loadStrings("port.txt")[1], 9600);
  //servoPort.bufferUntil('\n'); // Trigger a SerialEvent on new line

  minim = new Minim(this);
  player1 = minim.loadFile("beep.mp3");
  player2 = minim.loadFile("beep2.mp3");

  background(bgcolor);
}


void draw() {
  noStroke();
  if (angle/3.1415*180 < 15 || angle/3.1415*180 > 165){
    fill(0, 0, 0, 30);
    rect(0, 0, STAGE_WIDTH, STAGE_HEIGHT);
  }
  float pointc1X = centerX+distance1*distMul*cos(angle);
  float pointc1Y = centerY-distance1*distMul*sin(angle);
  float pointc2X = centerX+distance2*distMul*cos(angle-3.1415);
  float pointc2Y = centerY-distance2*distMul*sin(angle-3.1415);
  strokeWeight(8);
  stroke(255, distance1*distColorMul, distance1*distColorMul, 255-distance1*distAlphaMul);
  //line(point1X, point1Y, pointc1X, pointc1Y);
  line(centerX,centerY,pointc1X, pointc1Y);
  stroke(255, distance2*distColorMul, distance2*distColorMul, 255-distance2*distAlphaMul);
  //line(point2X, point2Y, pointc2X, pointc2Y);
  line(centerX,centerY,pointc2X, pointc2Y);
  point1X = pointc1X;
  point1Y = pointc1Y;
  point2X = pointc2X;
  point2Y = pointc2Y;
  noStroke();
  fill(0, 125, 255, 255);
  ellipse(centerX, centerY, dotRadius, dotRadius);
  //
  strokeWeight(0.7);
  stroke(200, 200, 200, 255);
  noFill();
  ellipse(centerX, centerY, 25*distMul, 25*distMul);
  ellipse(centerX, centerY, 50*distMul, 50*distMul);
  ellipse(centerX, centerY, 100*distMul, 100*distMul);
  ellipse(centerX, centerY, 200*distMul, 200*distMul);
  ellipse(centerX, centerY, 300*distMul, 300*distMul);
  noStroke();
  fill(255, 255, 255, 255);
  textAlign(CENTER);
  text("25cm", centerX, centerY + 25*distMul - textDist);
  text("50cm", centerX, centerY + 50*distMul - textDist);
  text("100cm", centerX, centerY + 100*distMul - textDist);
  text("200cm", centerX, centerY + 200*distMul - textDist);
  text("300cm", centerX, centerY + 300*distMul - textDist);
  text("25cm", centerX, centerY - 25*distMul + textDist);
  text("50cm", centerX, centerY - 50*distMul + textDist);
  text("100cm", centerX, centerY - 100*distMul + textDist);
  text("200cm", centerX, centerY - 200*distMul + textDist);
  text("300cm", centerX, centerY - 300*distMul + textDist);
  //
  fill(0, 0, 0, 255);
  rect(0, 0, STAGE_WIDTH, 50);
  fill(255, 255, 255, 255);
  textAlign(LEFT);
  text("Sensor 1 Distance: " + str(distance1) + " cm", 0, textDist * 1);
  text("Sensor 1 Angle: " + str(angle/3.1415*180), 0, textDist * 2);
  text("Sensor 2 Distance: " + str(distance2) + " cm", 0, textDist * 3);
  text("Sensor 2 Angle: " + str(angle/3.1415*180-180), 0, textDist * 4);
  beat1rate = distance1*beat1distMul;
  if (beat1 > beat1rate*0.13+6) {
    //player1.rewind();
    //player1.play();
    beat1 = 0;
  }
  if (beat1rate < maxDist) {
    beat1++;
  }
  beat2rate = distance2*beat2distMul;
  if (beat2 > beat2rate*0.13+6) {
    player2.rewind();
    player2.play();
    beat2 = 0;
  }
  if (beat2rate < maxDist) {
    beat2++;
  }
}

void serialEvent(Serial cPort) {

  comPortString = cPort.readStringUntil('\n');
  if (comPortString != null) {

    comPortString=trim(comPortString);
    String[] values = split(comPortString, ',');

    try {
      if (Integer.parseInt(values[0]) == 1){
        angleBuffer[0] = angleBuffer[1];
        angleBuffer[1] = angleBuffer[2];
        angleBuffer[2] = angleBuffer[3];
        angleBuffer[3] = angleBuffer[4];
        angleBuffer[4] = Integer.parseInt(values[1]);
        angle = float(angleBuffer[0])/180*3.1415;
      }
      else {
      int highest = 0;
      int value1 = Integer.parseInt(values[1]);
      int value2 = Integer.parseInt(values[2]);
      if (value1 == 0) {
        value1 = maxDist;
      };
      if (value2 == 0) {
        value2 = maxDist;
      };

      distance1Buffer[0] = distance1Buffer[1];
      distance1Buffer[1] = distance1Buffer[2];
      distance1Buffer[2] = distance1Buffer[3];
      distance1Buffer[3] = value1;
      highest = 0;
      if (distance1Buffer[0] > highest) {
        highest = distance1Buffer[0];
      };
      if (distance1Buffer[1] > highest) {
        highest = distance1Buffer[1];
      };
      if (distance1Buffer[2] > highest) {
        highest = distance1Buffer[2];
      };
      if (distance1Buffer[3] > highest) {
        highest = distance1Buffer[3];
      };
      distance1 = (distance1Buffer[0] + distance1Buffer[1] + distance1Buffer[2] + distance1Buffer[3] - highest) / 3;

      distance2Buffer[0] = distance2Buffer[1];
      distance2Buffer[1] = distance2Buffer[2];
      distance2Buffer[2] = distance2Buffer[3];
      distance2Buffer[3] = value2;  
      highest = 0;
      if (distance2Buffer[0] > highest) {
        highest = distance2Buffer[0];
      };
      if (distance2Buffer[1] > highest) {
        highest = distance2Buffer[1];
      };
      if (distance2Buffer[2] > highest) {
        highest = distance2Buffer[2];
      };
      if (distance2Buffer[3] > highest) {
        highest = distance2Buffer[3];
      };
      distance2 = (distance2Buffer[0] + distance2Buffer[1] + distance2Buffer[2] + distance2Buffer[3] - highest) / 3;

      //distance1 = float(values[1]);
      //distance2 = float(values[2]);
      }
    } 
    catch (Exception e) {
    }
  }
}


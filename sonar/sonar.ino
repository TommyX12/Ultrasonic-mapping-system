#include <NewPing.h>
 
int trig1Pin=5; //Sensor Trip pin connected to Arduino pin 13
int echo1Pin=4;  //Sensor Echo pin connected to Arduino pin 11
int trig2Pin=7; //Sensor Trip pin connected to Arduino pin 13
int echo2Pin=6;  //Sensor Echo pin connected to Arduino pin 11
int maxDistance=300;
float pingTime;  //time for ping to travel from sensor to target and return
int target1Distance; //Distance to Target in inches
int target2Distance; //Distance to Target in inches

float speedOfSound=776.5; //Speed of sound in miles per hour when temp is 77 degrees.
long double speedFactor = 62482625.5;
float pingTimeout = 8824;
float timeout = 0;
float timeoutLimit = 290000;
int pwm;

NewPing sensor1(trig1Pin, echo1Pin, maxDistance); 
NewPing sensor2(trig2Pin, echo2Pin, maxDistance); 
 
void setup() {
  
  Serial.begin(9600);
  //pinMode(trig1Pin, OUTPUT);
  //pinMode(echo1Pin, INPUT);
  //pinMode(trig2Pin, OUTPUT);
  //pinMode(echo2Pin, INPUT);
}
 
void loop() {
  timeout = timeoutLimit;
  
  /*
  //digitalWrite(trig1Pin, LOW); //Set trigger pin low
  //delayMicroseconds(20); //Let signal settle
  digitalWrite(trig1Pin, HIGH); //Set trigPin high
  delayMms(20); //Delay in high state
  digitalWrite(trig1Pin, LOW); //ping has now been sent
  //delayMicroseconds(10); //Delay in high state
  
  pingTime = pulseIn(echo1Pin, HIGH, pingTimeout);  //pingTime is presented in microceconds
  if (pingTime == 0){pingTime = pingTimeout;};
  timeout -= pingTime;
  pingTime=pingTime/1000000; //convert pingTime to seconds by dividing by 1000000 (microseconds in a second)
  pingTime=pingTime/3600; //convert pingtime to hourse by dividing by 3600 (seconds in an hour)
  target1Distance = pingTime * speedFactor;
  
  //digitalWrite(trig2Pin, LOW); //Set trigger pin low
  //delayMicroseconds(20); //Let signal settle
  digitalWrite(trig2Pin, HIGH); //Set trigPin high
  delayMms(20); //Delay in high state
  digitalWrite(trig2Pin, LOW); //ping has now been sent
  //delayMicroseconds(10); //Delay in high state
  
  pingTime = pulseIn(echo2Pin, HIGH, pingTimeout);  //pingTime is presented in microceconds
  if (pingTime == 0){pingTime = pingTimeout;};
  timeout -= pingTime;
  pingTime=pingTime/1000000; //convert pingTime to seconds by dividing by 1000000 (microseconds in a second)
  pingTime=pingTime/3600; //convert pingtime to hourse by dividing by 3600 (seconds in an hour)
  target2Distance = pingTime * speedFactor;
  */
  
  /*
  LCD.setCursor(0,1);  //Set cursor to first column of second row
  LCD.print("                "); //Print blanks to clear the row
  LCD.setCursor(0,1);   //Set Cursor again to first column of second row
  LCD.print(targetDistance); //Print measured distance
  LCD.print(" cm");  //Print your units.
  */
  
  delay(20); //pause to let things settle
  
  target1Distance = sensor1.ping_cm();
  target2Distance = sensor2.ping_cm();
  
  Serial.print(0, DEC);
  Serial.print(",");
  Serial.print(target1Distance, DEC);
  Serial.print(",");
  Serial.println(target2Distance, DEC);
}  

#include <Servo.h> 

int servoPin = 9;

int rotateSpeed = 3;
Servo servo;

int angle = 90;
 
void setup() {
  Serial.begin(9600);
  //pinMode(servoPin,OUTPUT);
  servo.attach(servoPin);
}
 
void loop() {
  //servoPulse(servoPin,angle);
  //servo.write(angle);
  
  delay(20); //pause to let things settle
  
  Serial.print(1, DEC);
  Serial.print(",");
  Serial.println(angle, DEC);
  
  if (angle+rotateSpeed < 10 || angle+rotateSpeed > 170){
    rotateSpeed *= -1;
  }
  angle += rotateSpeed;
  
}  
/*
void servoPulse (int servo, int angle)
{
 pwm = (angle*10.3111) + 544;    
 digitalWrite(servo, HIGH);
 delayMicroseconds(pwm);
 digitalWrite(servo, LOW);                
}
*/

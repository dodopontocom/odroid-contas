import RPi.GPIO as GPIO
import time
import sys

control = [5,5.5,6,6.5,7,7.5,8,8.5,9,9.5,10,11,12,13,14,15,16]
tempo_abertura = float(sys.argv[1])
atraso_na_girada_inicial = float(sys.argv[2])
atraso_na_girada_final = float(sys.argv[3])
pino_servo_01 = 22
pino_servo_02 = 21

GPIO.setmode(GPIO.BOARD)

GPIO.setup(pino_servo_01,GPIO.OUT)
GPIO.setup(pino_servo_02,GPIO.OUT)

p1=GPIO.PWM(pino_servo_01,50)# 50hz frequency
p2=GPIO.PWM(pino_servo_02,50)# 50hz frequency

p1.start(2.5)
p2.start(2.5)

for x in range(9,0,-1):
    p1.ChangeDutyCycle(control[x])
    p2.ChangeDutyCycle(control[x])
    time.sleep(atraso_na_girada_inicial)

time.sleep(tempo_abertura)

for x in range(len(control)): 
    p1.ChangeDutyCycle(control[x])
    p2.ChangeDutyCycle(control[x])
    time.sleep(atraso_na_girada_final)
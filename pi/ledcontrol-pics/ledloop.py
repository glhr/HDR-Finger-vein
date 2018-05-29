#!/usr/bin/python
from picamera import PiCamera
import os
import smbus
import time



## SETUP LEDS
bus = smbus.SMBus(1)    # 0 = /dev/i2c-0 (port I2C0), 1 = /dev/i2c-1 (port I2C1)

DEVICE_ADDRESS = 0x04      #7 bit address (will be left shifted to add the read write bit)

time.sleep(1)

ledstrip = [0.5, 0, 0.3, 0, 0.8, 0, 0.3, 0]

def ledsoff():
	bus.write_i2c_block_data(DEVICE_ADDRESS, 16, [0, 0]) #turn off all the LEDs
	return
	

ledsoff()

while(1):
	for dutycyle in range(0,int(1000/(max(ledstrip))),100):
		leds = [int(a*dutycyle) for a in ledstrip]

		for i in range(len(leds)):
			#print 'Setting LED ',i+1,' to ', leds[i]
			pwm = leds[i]
			byte1 = pwm >> 8
			byte2 = pwm & 255
			ledout_bytes = [byte1, byte2]
			bus.write_i2c_block_data(DEVICE_ADDRESS, i+8, ledout_bytes)
			time.sleep(0.01)
		
		ledstr = [str(a) for a in leds]
		imgpath = ','.join(ledstr)
	
		print '[', imgpath, ']'
		time.sleep(0.5)


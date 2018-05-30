#!/usr/bin/python
from picamera import PiCamera
import os
import smbus
import time

enable_preview = False

## SETUP LEDS
bus = smbus.SMBus(1)    # 0 = /dev/i2c-0 (port I2C0), 1 = /dev/i2c-1 (port I2C1)

DEVICE_ADDRESS = 0x04      #7 bit address (will be left shifted to add the read write bit)

time.sleep(1)

ledstrip = [0.5, 0, 0.3, 0, 1, 0, 0.5, 0]

def ledsoff():
	bus.write_i2c_block_data(DEVICE_ADDRESS, 16, [0, 0]) #turn off all the LEDs
	return
	
ledsoff()

## SETUP CAMERA

camera =  PiCamera()
camera.resolution = (800,600)
#camera.resolution = (1920,1080)
if(enable_preview):
	camera.start_preview()
	camera.preview.fullscreen = False
	camera.preview.window = (800,0,800,600)
camera.exposure_mode = 'off'
camera.shutter_speed = 1000000
camera.iso = 100
camera.awb_mode = 'auto'
camera.saturation = -100
camera.zoom = (0.0, 0.0, 1.0, 1.0) 
#camera.meter_mode = 'spot'
#camera.shutter_speed = 20000
#camera.shutter_speed = camera.exposure_speed
#camera.contrast = 50
#camera.brightness = 12

cap = "no"
irfilter = "no"
fingerwindow = "no"
extraledstrips = "left & right"

folder = time.strftime("%m-%d_%H-%M-%S")
if not os.path.exists(folder):
    os.makedirs(folder)

lines =[
"--------------SETUP--------------",
"illumination pattern: "+str(ledstrip),
"cap/dark housing: "+cap,
"IR filter: "+irfilter,
"finger window: "+fingerwindow,
"extra ledstrips: "+extraledstrips,
"\n",
"---------CAMERA SETTINGS---------",
"resolution: "+str(camera.resolution),
"exposure mode: "+camera.exposure_mode,
"shutter speed: "+str(camera.shutter_speed),
"ISO: "+str(camera.iso),
"AWB mode: "+camera.awb_mode,
"contrast: " + str(camera.contrast),
"brightness: " + str(camera.brightness),
"saturation: "+str(camera.saturation),
"zoom: "+str(camera.zoom)
] 

file = open(folder+"/"+folder+"-info.txt","w+")
file.writelines("%s\n" % l for l in lines)
file.close()

for dutycyle in range(0,int(2000/(max(ledstrip))),50):
	leds = [int(a*dutycyle) for a in ledstrip]

	for i in range(len(leds)):
		#print 'Setting LED ',i+1,' to ', leds[i]
		pwm = leds[i]
		if(pwm>1024):
			pwm = 1024;
		byte1 = pwm >> 8
		byte2 = pwm & 255
		ledout_bytes = [byte1, byte2]
		bus.write_i2c_block_data(DEVICE_ADDRESS, i+8, ledout_bytes)
		time.sleep(0.01)
	
	if(max(leds)>0):
		ledstr = [str(a) for a in leds]
		imgpath = ','.join(ledstr)
		
		print '[', imgpath, ']'
		timestr = time.strftime("%m-%d_%H-%M-%S")
		camera.capture(folder+"/"+timestr+'['+imgpath+'].png')
	
	if(max(leds)>=1024):
		break;
	#time.sleep(0.05)
	#

	# camera.capture(newfolder+'/cam2.'+str(i)+'.jpg')

ledsoff()

if(enable_preview):
	camera.stop_preview()



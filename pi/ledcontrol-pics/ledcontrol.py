#!/usr/bin/python
from picamera import PiCamera
import os
import smbus
import time

enable_preview = False # enable this if you want a live preview of the camera during the capture (note:slow)
enable_capture = True # enable this if you want to save captures to image files

## SETUP LEDS
bus = smbus.SMBus(1)    # 0 = /dev/i2c-0 (port I2C0), 1 = /dev/i2c-1 (port I2C1)
DEVICE_ADDRESS = 0x04      #7 bit address (will be left shifted to add the read write bit)
time.sleep(1)
 
def ledsoff():
	bus.write_i2c_block_data(DEVICE_ADDRESS, 16, [0, 0]) #turn off all the LEDs
	return

# takes an array of 8 relative led intensities as input eg. [1, 0.3, 0, 0, 1, 0.3, 0, 0.7] ([base of finger .... end of finger])
def setleds(leds):
	for i in range(len(leds)):
		#print 'Setting LED ',i+1,' to ', leds[i]
		pwm = leds[i]
		if(pwm>1024):
			pwm = 1024;
		byte1 = pwm >> 8
		byte2 = pwm & 255
		ledout_bytes = [byte1, byte2]
		bus.write_i2c_block_data(DEVICE_ADDRESS, i+8, ledout_bytes)
		time.sleep(0.001)
	return
	
ledsoff()

## SETUP CAMERA

camera =  PiCamera()
camera.resolution = (800,600) # note: resolution greatly affects capture time
#camera.resolution = (1920,1080) 
if(enable_preview):
	camera.start_preview()
	camera.preview.fullscreen = False
	camera.preview.window = (800,0,800,600)
camera.exposure_mode = 'off' #disable automatic exposure setting
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

#used for debugging different finger vein scanner configurations
cap = "yes"
irfilter = "no"
fingerwindow = "no"
extraledstrips = "no"

#ask the user for the finger number (1 to 5) and set the LED pattern accordingly
finger = str(raw_input("Which finger?"));
fingerno = int(finger[:1]);

if(fingerno == 2):
	#[base of finger .... end of finger]
	ledstrip = [1, 1, 0, 0.3, 1, 0.5, 0, 0.5]
elif(fingerno == 3):
	ledstrip = [1, 0.3, 0, 0, 1, 0.3, 0, 0.7]
else:
	ledstrip = [1, 0, 0, 0, 1, 0, 0, 0.7]
	
if(enable_capture):
	folder = time.strftime(finger+" %m-%d_%H-%M-%S")
	if not os.path.exists(folder):
	    os.makedirs(folder)

	lines =[
	"finger: " + finger,
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
	
# pwmstep: PWM duty cycle increment between captures
# pwmmax: maximum PWM duty cycle after which capture is stopped
if(enable_capture):
	pwmstep = 50
	pwmmax = 1024
else:
	pwmstep = 10
	pwmmax = 300

# progressively increase the exposure while maintaining the relative intensities defined in ledstrip
for dutycyle in range(0,int(2000/(max(ledstrip))),pwmstep):
	leds = [int(a*dutycyle) for a in ledstrip]

	setleds(leds)
	
	if(max(leds)>0):
		ledstr = [str(a) for a in leds]
		imgpath = ','.join(ledstr)
		
		print '[', imgpath, ']'
		if(enable_capture):
			timestr = time.strftime("%m-%d_%H-%M-%S")
			camera.capture(folder+"/"+timestr+'['+imgpath+'].png')
	
	if(max(leds)>=pwmmax):
		leds = [1024, 1024, 1024, 1024, 1024, 1024, 1024, 300] #make sure the PWM duty cycle stays <= 1024. Tip of the finger is set to a lower duty cycle because it is thinner
		setleds(leds)
		
		ledstr = [str(a) for a in leds]
		imgpath = ','.join(ledstr)
		
		print '[', imgpath, ']'
		if(enable_capture):
			timestr = time.strftime("%m-%d_%H-%M-%S")
			camera.capture(folder+"/"+timestr+'['+imgpath+'].png')
		break;

	if((not enable_capture) and (enable_preview)):
		time.sleep(1)
	#

	# camera.capture(newfolder+'/cam2.'+str(i)+'.jpg')

ledsoff()

if(enable_preview):
	camera.stop_preview()

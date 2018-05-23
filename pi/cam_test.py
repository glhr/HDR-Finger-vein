from picamera import PiCamera
import time
import os

# current_time = time.strftime("%Y-%m-%d_%H:%M")
# newfolder = r'/home/pi/Desktop/camera_middle_testimages_'+current_time

# if not os.path.exists(newfolder):
# 	os.makedirs(newfolder)

camera =  PiCamera()
camera.resolution = (800,600)

print camera.DRC_STRENGTHS
camera.start_preview()
camera.exposure_mode = 'off'
camera.shutter_speed = camera.exposure_speed
camera.contrast = 60
camera.brightness = 52
time.sleep(120000)
camera.capture('cam.jpg')
# camera.capture(newfolder+'/cam2.'+str(i)+'.jpg')
camera.stop_preview()


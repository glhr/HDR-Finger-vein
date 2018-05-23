#!/usr/bin/python

import smbus
import time

bus = smbus.SMBus(1)    # 0 = /dev/i2c-0 (port I2C0), 1 = /dev/i2c-1 (port I2C1)

DEVICE_ADDRESS = 0x04      #7 bit address (will be left shifted to add the read write bit)

# channel = 3
# ledout_values = [0, 140]
# bus.write_i2c_block_data(DEVICE_ADDRESS, channel+7, ledout_values)

bus.write_i2c_block_data(DEVICE_ADDRESS, 16, [0, 0])
time.sleep(1)
leds = [0, 10, 0, 0, 2, 0, 0, 10]

for i in range(len(leds)):
	print 'Setting LED ',i+1,' to ', leds[i]
	pwm = leds[i]
	byte1 = pwm << 8
	byte2 = pwm & 255
	ledout_bytes = [byte1, byte2]
	bus.write_i2c_block_data(DEVICE_ADDRESS, i+8, ledout_bytes)
	time.sleep(0.01)
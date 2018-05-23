#!/usr/bin/python

import smbus

bus = smbus.SMBus(1)    # 0 = /dev/i2c-0 (port I2C0), 1 = /dev/i2c-1 (port I2C1)

DEVICE_ADDRESS = 0x04      #7 bit address (will be left shifted to add the read write bit)

# channel = 3
# ledout_values = [0, 140]
# bus.write_i2c_block_data(DEVICE_ADDRESS, channel+7, ledout_values)


var leds = [0, 100, 0, 0, 0, 100, 0, 100]

for i in range(len(leds)):
    print(leds[i])
	byte1 = leds[i] << 8
    byte2 = leds[i] & 255
	ledout_bytes = [byte1 byte2]
	bus.write_i2c_block_data(DEVICE_ADDRESS, i+8, ledout_values)
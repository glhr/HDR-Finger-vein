#!/usr/bin/python

import smbus

bus = smbus.SMBus(1)    # 0 = /dev/i2c-0 (port I2C0), 1 = /dev/i2c-1 (port I2C1)

DEVICE_ADDRESS = 0x04      #7 bit address (will be left shifted to add the read write bit)

channel = 3
ledout_values = [0, 140]
bus.write_i2c_block_data(DEVICE_ADDRESS, channel+7, ledout_values)

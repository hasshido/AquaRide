import serial
import time
import sys
import math

baudRate = 115200
serialPort = '/dev/ttyUSB0'
arduino = serial.Serial(serialPort, baudrate=baudRate, timeout=0.2)



def cm2stepsX ( centimeters ):
	steps = floor(centimeters * 5714) #ratio steps/cm
	return steps
def cm2stepsY ( centimeters ):
	steps = floor(centimeters * 5714)
	return steps
def cm2stepsZ ( centimeters ):
	steps = floor(centimeters * 5714)
	return steps

def Read_Aquarride( arduino ):
	while True:
		data = arduino.readline()[:-2] # \n
		print data
		if data == 'IDLE':
			break
	return

def Parse_Aquarride( arduino ):

	while True:
		data = arduino.readline()[:-2] # \n
		if data:
			print data
		if data[:5]=='DATA:':
			Data_List = data.split("\t")
			print Data_List
			file.write(Data_List[1]+';'+Data_List[2]+';'+Data_List[3]+';'+Data_List[4]+';'+Data_List[5]+';'+Data_List[6]+';'+Data_List[7]+';'+Data_List[8]+'\n')
		elif data == 'IDLE':
			break
	return

# Create data file and open it to append new data
timestr = time.strftime("%Y-%m-%d %H:%M:%S")
print('Creating data file') 
name = 'Experimento1-'+timestr+'.csv'  # Name of csv file
file.write('POSX;POSY;POSZ;POSA;V10;V20;V13;V23\n')

try:
	file = open(name,'a')   # Trying to create a new file or open one

except:
	print('Something went wrong! Can\'t tell what?')
	sys.exit(0) # quit Python


# Manual Reset
arduino.setDTR(False)
time.sleep(1)
arduino.flushInput()
arduino.setDTR(True)


Read_Aquarride( arduino )

# Set home position and move to position 0
arduino.write('home')
Read_Aquarride( arduino )

arduino.write('move X - '+ cm2stepsX (45):)
Read_Aquarride( arduino )

arduino.write('move Y - '+ cm2stepsY (45))
Read_Aquarride( arduino )

arduino.write('move Z - '+ cm2stepsX (30))
Read_Aquarride( arduino )



for i in range(20):

	arduino.write('move X + '+ cm2stepsX (1))
	Read_Aquarride( arduino )
	arduino.write('sample 1000')
	Parse_Aquarride( arduino )

for i in range(20):

	arduino.write('move Y + '+ cm2stepsX (1))
	Read_Aquarride( arduino )
	arduino.write('sample 1000')
	Parse_Aquarride( arduino )

for i in range(20):

	arduino.write('move X - '+ cm2stepsX (1))
	Read_Aquarride( arduino )
	arduino.write('sample 1000')
	Parse_Aquarride( arduino )

for i in range(20):

	arduino.write('move Y - '+ cm2stepsX (1))
	Read_Aquarride( arduino )
	arduino.write('sample 1000')
	Parse_Aquarride( arduino )

file.close()
print 'Experimento finalizado'
sys.exit(0) # quit Python


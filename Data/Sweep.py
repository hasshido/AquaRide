import serial
import time
import sys
import math

baudRate = 115200
serialPort = '/dev/ttyUSB0'
arduino = serial.Serial(serialPort, baudrate=baudRate, timeout=0.2)



def cm2stepsX ( centimeters ):
	steps = math.floor(centimeters * 621.1) #ratio steps/cm
	return steps
def cm2stepsY ( centimeters ):
	steps = math.floor(centimeters * 651.46)
	return steps
def cm2stepsZ ( centimeters ):
	steps = math.floor(centimeters * 304.87)
	return steps

def Read_Aquarride( arduino ):
	while True:
		data = arduino.readline()[:-2] # \n
		if data:
			print data
		if data == 'IDLE':
			break
	return

def Parse_Aquarride( arduino, fd ):

	while True:
		data = arduino.readline()[:-2] # \n
		if data[:5]=='DATA:':
			Data_List = data.split("\t")
			if len(Data_List)==9:
				fd.write(Data_List[1]+';'+Data_List[2]+';'+Data_List[3]+';'+Data_List[4]+';'+Data_List[5]+';'+Data_List[6]+';'+Data_List[7]+';'+Data_List[8]+'\n')
			else:
				print('Warning, data error')
		elif data == 'IDLE':
			break
	return

# Create data file and open it to append new data
timestr = time.strftime("%Y-%m-%d %H:%M:%S")
print('Creating data file') 
name = 'Experimento-'+timestr+'.csv'  # Name of csv file


try:
	fd = open(name,'a')   # Trying to create a new file or open one
	fd.write('POSX;POSY;POSZ;POSA;V10;V20;V13;V23\n') #headers for the data file

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

arduino.write('move X - '+ str(cm2stepsX (45)))
Read_Aquarride( arduino )

arduino.write('move Y - '+ str(cm2stepsY (45)))
Read_Aquarride( arduino )

arduino.write('move Z - '+ str(cm2stepsZ (30)))
Read_Aquarride( arduino )

arduino.write('move A 50') #move probe to 90 degree angle
Read_Aquarride( arduino )


#Position->[0,0,0,50]
#Starting position -> lateral sweep
arduino.write('move Z + 1640')
Read_Aquarride( arduino )
arduino.write('move Y + 5100')
Read_Aquarride( arduino )

for i in range(27):

	arduino.write('move X + '+ str(cm2stepsX (1)))
	Read_Aquarride( arduino)
	arduino.write('sample 50')
	Parse_Aquarride( arduino, fd )


fd.close()
print 'Experimento finalizado'

sys.exit(0) # quit Python
4

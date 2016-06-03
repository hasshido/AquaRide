import serial
import time
import sys
import math
import numpy as np

baudRate = 115200
serialPort = '/dev/ttyUSB2'
arduino = serial.Serial(serialPort, baudrate=baudRate, timeout=0.2)

# From Calibration Phase
Aquarium_stepsX = 17300;
Aquarium_stepsY = 15200;
Aquarium_stepsZ = 8300;

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
#		if data:
#			
#			#print data
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


def SweepRead (Axis,samples,NumPositions, fd, arduino):
	# Sweeps selected axis and reads <NumPositions> positions with indicated number of samples

	if Axis == 'X':
		Aquarium_steps=	Aquarium_stepsX
	elif Axis == 'Y':
		Aquarium_steps=	Aquarium_stepsY
	elif Axis == 'Z':
		Aquarium_steps=	Aquarium_stepsZ
	else:
		print ('Warning in Sweep: axis not valid')
	
	StepJump = np.linspace(0, Aquarium_steps, NumPositions, endpoint=True)[1]
	#print ('X range'+str(np.linspace(0, Aquarium_steps, NumPositions, endpoint=True)))

	for i in np.linspace(0, Aquarium_steps, NumPositions, endpoint=True):
		print('Sampling at X:'+str(i))
		arduino.write('sample '+ str(samples))
		Parse_Aquarride( arduino, fd )
		if (i<Aquarium_steps): #Stop moving at the end of the aquarium
			arduino.write('move ' + Axis + ' + ' + str(StepJump))
			Read_Aquarride( arduino)
		else:
			arduino.write('home')
			Read_Aquarride( arduino)
	return
		

def SweepReadXY (samples,NumPositionsX,NumPositionsY, fd, arduino):
	# Sweeps plane at current Z
	
	MaxY=Aquarium_stepsY
	StepJump = np.linspace(0, MaxY, NumPositionsY, endpoint=True)[1]
	#print ('Range Y:')
	#print np.linspace(0, MaxY, NumPositionsY, endpoint=True)
	k=1;
	for j in np.linspace(0, MaxY, NumPositionsY, endpoint=True):
		print ('Sweeping X at Y:'+str(j))
		SweepRead (Axis='X',samples=samples,NumPositions=NumPositionsX, fd=fd, arduino=arduino)
		if (j<MaxY): #Stop moving at the end of the aquarium
			arduino.write('move Z + 1640')
			Read_Aquarride( arduino )
			arduino.write('move ' + 'Y' + ' + ' + str(StepJump*k))
			Read_Aquarride( arduino)
		k+=1;
	arduino.write('home')
	Read_Aquarride( arduino)
	return


# Create data file and open it to append new data
timestr = time.strftime("%Y-%m-%d %H:%M:%S")
print('Creating data file') 
name = 'csv/'+sys.argv[0]+'-'+ raw_input('Introduzca nombre para el experimento: PeceraVacia10x10_50Samp') +timestr +'.csv'  # Name of csv file

try:
	fd = open(name,'w')   # Trying to create a new file or open one
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

arduino.write('move A 125')
Read_Aquarride( arduino )

#Position->[0,0,0,50]
#Starting position -> lateral sweep
arduino.write('move Z + '+str(Aquarium_stepsZ/2))
Read_Aquarride( arduino )

SweepReadXY(samples=50,NumPositionsX=10,NumPositionsY=10, fd=fd, arduino=arduino)

fd.close()
print 'Experimento finalizado'

sys.exit(0) # quit Python

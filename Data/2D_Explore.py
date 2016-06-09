import serial
import time
import sys
import math
import numpy as np

baudRate = 115200
serialPort = '/dev/ttyUSB0'
arduino = serial.Serial(serialPort, baudrate=baudRate, timeout=0.2)

# From Calibration Phase
Aquarium_stepsX = 15300;
Aquarium_stepsY = 13300;
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
		#if data:
			
			#print data
		if data == 'IDLE':
			break
	return

def Check_Object(lineSamples):
	flag = False
	FrontFlag=True
	BackFlag=True
	objectThreshold = 8	
	if lineSamples.shape[0]>1:
		V10dif=lineSamples[-1,4]-lineSamples[-2,4]
		V20dif=lineSamples[-1,5]-lineSamples[-2,5]
		V13dif=lineSamples[-1,6]-lineSamples[-2,6]
		V23dif=lineSamples[-1,7]-lineSamples[-2,7]
		
		FrontIndicator= V10dif+V20dif-V13dif-V23dif
		BackIndicator= -V10dif-V20dif+V13dif+V23dif
		
		
		FrontFlag= FrontIndicator>objectThreshold and V10dif>0 and V20dif>0 and V13dif<0 and V23dif<0
		BackFlag= BackIndicator>objectThreshold and V10dif<0 and V20dif<0 and V13dif>0 and V23dif>0
		state=''
		if (V10dif>0 and V20dif>0 and V13dif<0 and V23dif<0):
			state='Approaching front'
		elif (V10dif<0 and V20dif<0 and V13dif>0 and V23dif>0):
			state='Approaching back'
		
		print 'FrontIndicator= '+str(FrontIndicator)+'\tFrontFlag = '+ str(FrontFlag)
		print 'BackIndicator= '+str(BackIndicator)+'\tBackFlag = '+ str(BackFlag)
		print state

		flag=FrontFlag
	return flag
	

def Parse_Aquarride( arduino, fd ):

	while True:
		data = arduino.readline()[:-2] # \n
		if data[:5]=='DATA:':
			Data_List = data.split("\t")
			if len(Data_List)==9:
				fd.write(Data_List[1]+';'+Data_List[2]+';'+Data_List[3]+';'+Data_List[4]+';'+Data_List[5]+';'+Data_List[6]+';'+Data_List[7]+';'+Data_List[8]+'\n')
				sampleData=Data_List[1:] #without "DATA:"
				sampleData = np.array(map(float, sampleData)) #conversion to float (read as string)
			else:
				print('Warning, data error')
		elif data == 'IDLE':
			break
	return sampleData


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
	lineSamples=np.empty((0,8))
	

	k=0
	
	for i in np.linspace(0, Aquarium_steps, NumPositions, endpoint=True):
		print('Sampling at X:'+str(i))
		arduino.write('sample '+ str(samples))
		Data=Parse_Aquarride( arduino, fd )
		lineSamples = np.vstack([lineSamples, Data])
		Flag_NearObject = Check_Object(lineSamples)

		
		if Flag_NearObject==True:
			arduino.write('move ' + Axis + ' - ' + str(Aquarium_steps))
			Read_Aquarride( arduino)
			break

		if (i<Aquarium_steps): #Stop moving at the end of the aquarium
			arduino.write('move ' + Axis + ' + ' + str(StepJump))
			Read_Aquarride( arduino)
		else:
#			arduino.write('home')
#			Read_Aquarride( arduino)
			arduino.write('move ' + Axis + ' - ' + str(Aquarium_steps))
			Read_Aquarride( arduino)
		k+=1
	return lineSamples
		

def SweepReadXY (samples,NumPositionsX,NumPositionsY, Z, fd, arduino):
	# Sweeps plane at current Z
	
	StepJump = np.linspace(0, Aquarium_stepsY, NumPositionsY, endpoint=True)[1]
	k=1;

	for j in np.linspace(0, Aquarium_stepsY, NumPositionsY, endpoint=True):
		#print ('Sweeping X at Y:'+str(j))
		SweepRead (Axis='X',samples=samples,NumPositions=NumPositionsX, fd=fd, arduino=arduino)
		if (j<Aquarium_stepsY): #Stop moving at the end of the aquarium
#			arduino.write('move Z + '+ str(Z))
#			Read_Aquarride( arduino )
			arduino.write('move ' + 'Y' + ' + ' + str(StepJump)) # str(StepJump*k))
			Read_Aquarride( arduino)

		k+=1;
	arduino.write('home')
	Read_Aquarride( arduino)
	return


# Create data file and open it to append new data
timestr = time.strftime("%Y-%m-%d %H:%M:%S")
print('Creating data file') 
name = 'csv/'+sys.argv[0]+'-'+ raw_input('Introduzca nombre para el experimento:')+'-' +timestr +'.csv'  # Name of csv file

try:
	fd = open(name,'w')   # Trying to create a new file or open one

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
Z=1750; #height

arduino.write('move Z + ' + str(Z))
Read_Aquarride( arduino )

NumPositionsX=20
NumPositionsY=15

fd.write('PositionsExploration:;NumX=;'+str(NumPositionsX)+';NumY=;'+str(NumPositionsY)+';MaxX=;'+str(Aquarium_stepsX)+';MaxY=;'+str(Aquarium_stepsY)+'\n') #headers for the data file
fd.write('POSX;POSY;POSZ;POSA;V10;V20;V13;V23\n') #headers for the data file

SweepReadXY(samples=300,NumPositionsX=NumPositionsX,NumPositionsY=NumPositionsY, Z=Z, fd=fd, arduino=arduino)

fd.close()
print 'Experimento finalizado'

sys.exit(0) # quit Python

import matplotlib.pyplot as plt
import numpy as np
import sys

name = sys.argv[1]  # Name of csv file
namedst ='csv_filtered/'+ sys.argv[1][4:-4] + '_filt.csv'

try:
	fd = open(name,'r')   # Trying to open

except:
	print('No se pudo abrir el archivo indicado')
	sys.exit(0) # quit Python

dataMatrix=np.loadtxt(fd,delimiter=";",skiprows=1)
fd.close()

sizeMatrix=dataMatrix.shape #(rows, colums)

# Calculates mean in each position during experiment
lastBeforeLastChange=0;
samples=1;
for j in  range(sizeMatrix[0]): #rows
	if j==sizeMatrix[0]-1:
		dataMatrix[lastBeforeLastChange+1:j+1,4:] = np.sum(dataMatrix[lastBeforeLastChange+1:j+1,4:], axis=0)/samples
	
	elif (np.array_equal(dataMatrix[j,:4],dataMatrix[j+1,:4])):
		samples=samples+1;
		continue
	else:	
		dataMatrix[lastBeforeLastChange+1:j+1,4:] = np.sum(dataMatrix[lastBeforeLastChange+1:j+1,4:], axis=0)/samples
		lastBeforeLastChange= j ;
		samples=1;
	
	
plt.plot(dataMatrix[:,4:8])
plt.title("Voltajes filtrados")
plt.xlabel("Valor")
plt.ylabel("Frecuencia")

try:
	fd = open(namedst,'a')   # Trying to open

except:
	print('No se pudo abrir el archivo indicado')
	sys.exit(0) # quit Python

np.savetxt(namedst, dataMatrix, delimiter=";")

fd.close()
plt.show()
sys.exit(0)

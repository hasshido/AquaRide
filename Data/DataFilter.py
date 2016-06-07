import matplotlib.pyplot as plt
import numpy as np
import sys



def steps2cmX ( steps ):
	cm = steps / 621.1
	return cm
def steps2cmY ( steps ):
	cm = steps / 651.46
	return cm
def steps2cmZ ( steps ):
	cm = steps / 304.87
	return cm
def unique_rows(a):
    a = np.ascontiguousarray(a)
    unique_a = np.unique(a.view([('', a.dtype)]*a.shape[1]))
    return unique_a.view(a.dtype).reshape((unique_a.shape[0], a.shape[1]))


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

Shape=(unique_rows(dataMatrix[:,:4])).shape
numChanges = Shape[0]
ResultMatrix = np.empty([numChanges, 8])



# Calculates mean in each position during experiment
lastBeforeLastChange=-1;
samples=1;
changes=0;

for j in  range(sizeMatrix[0]): #rows
	if j==sizeMatrix[0]-1:
		ResultMatrix[changes,4:]= np.sum(dataMatrix[lastBeforeLastChange+1:j+1,4:], axis=0)/samples
		#conversion to cms
		ResultMatrix[changes,0]= steps2cmX(dataMatrix[j,0])
		ResultMatrix[changes,1]= steps2cmY(dataMatrix[j,1])
		ResultMatrix[changes,2]= steps2cmZ(dataMatrix[j,2])
		ResultMatrix[changes,3]= dataMatrix[j,3]
		
	elif (np.array_equal(dataMatrix[j,:4],dataMatrix[j+1,:4])):
		samples +=1
		continue
	else:	

		ResultMatrix[changes,4:]= np.sum(dataMatrix[lastBeforeLastChange+1:j+1,4:], axis=0)/samples
		#conversion to cms
		ResultMatrix[changes,0]= steps2cmX(dataMatrix[j,0])
		ResultMatrix[changes,1]= steps2cmY(dataMatrix[j,1])
		ResultMatrix[changes,2]= steps2cmZ(dataMatrix[j,2])
		ResultMatrix[changes,3]= dataMatrix[j,3]		
		lastBeforeLastChange= j
		changes += 1
		samples = 1

		
	
	
#plt.plot(dataMatrix[:,4:8])
plt.plot(ResultMatrix[:,4:8])
plt.title("Voltajes filtrados")
plt.xlabel("Posicion")
plt.ylabel("Valor")
plt.legend(["V10","V20","V13","V23"])

try:
	fd = open(namedst,'w')   # Trying to open

except:
	print('No se pudo abrir el archivo indicado')
	sys.exit(0) # quit Python

np.savetxt(namedst, ResultMatrix, delimiter=";", fmt="%.2f")

fd.close()
plt.show()
sys.exit(0)

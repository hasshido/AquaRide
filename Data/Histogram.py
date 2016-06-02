import matplotlib.pyplot as plt
import numpy as np
import sys

name = sys.argv[1]  # Name of csv file


try:
	fd = open(name,'r')   # Trying to open

except:
	print('No se pudo abrir el archivo indicado')
	sys.exit(0) # quit Python

dataMatrix=np.loadtxt(fd,delimiter=";",skiprows=1)
fd.close()

#Full data histogram
Values = dataMatrix[:,4] #dataMatrix[:,4->7]
numValues = len(np.unique(Values))
plt.hist(Values,numValues)
plt.title("Distribucion estadistica de las medidas")
plt.xlabel("Valor")
plt.ylabel("Frecuencia")

plt.show()


sizeMatrix=dataMatrix.shape #(rows, colums)


meanValue=np.empty([sizeMatrix[0], 4])

j=0
for i in range(sizeMatrix[0]):
	meanValue[j] = np.sum(dataMatrix[:i+1,4:], axis=0)/(i+1)
	j=j+1

meanValue -= meanValue[-1,:]

plt.plot(meanValue)
plt.title("Tendencia de las medias halladas")
plt.xlabel("Muestras")
plt.ylabel("Valor")
plt.legend(["V10","V20","V13","V23"])
plt.show()
sys.exit(0)

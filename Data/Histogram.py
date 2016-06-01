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
print dataMatrix

V10 = dataMatrix[:500,5]
plt.hist(V10,20)
plt.title("Distribucion estadistica de las medidas")
plt.xlabel("Valor")
plt.ylabel("Frecuencia")

#fig = plt.gcf()

plt.show()

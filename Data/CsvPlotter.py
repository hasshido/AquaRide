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

	
plt.plot(dataMatrix[:,4:8])
plt.title("Voltajes filtrados")
plt.xlabel("Posicion")
plt.ylabel("Valor")
plt.show()
sys.exit(0)

from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter
import matplotlib.pyplot as plt
import numpy as np
import sys

name = sys.argv[1]  # Name of csv file

try:
	fd = open(name,'r')   # Trying to open

except:
	print('No se pudo abrir el archivo indicado')
	sys.exit(0) # quit Python

dataMatrix=np.loadtxt(fd,delimiter=";",skiprows=0)
fd.close()

NumPosX=len(np.unique(dataMatrix[:,0]))
NumPosY=len(np.unique(dataMatrix[:,1]))
V=np.empty([NumPosY,NumPosX,4])

for i in range(NumPosY):
	for j in range(NumPosX):

		print 'V['+str(i)+','+str(j)+']=dataMatrix['+str((NumPosX*i)+j)+',4]'
		print 'dataMatrix['+str((NumPosX*i)+j)+',4]='+str(dataMatrix[(NumPosX*i)+j,4])
		V[i,j,:]=dataMatrix[(NumPosX*i)+j,4:]
#V=np.flipud(V)

V10=V[:,:,0]
V20=V[:,:,1]
V13=V[:,:,2]
V23=V[:,:,3]
fig = plt.figure()	
plt.imshow(V13,interpolation='nearest',origin='low')

# 3D plot, gradient
X = np.unique(dataMatrix[:,0])
Y = np.unique(dataMatrix[:,1])
X, Y = np.meshgrid(X, Y)

#Vg=np.empty([NumPosY,NumPosX,4])
#print Vg.shape
#Vg[:,:,0]=
#print V[:,:,0].shape
#plt.imshow(Vg[:,:,0])

#ax = fig.gca(projection='3d')
#surf = ax.plot_surface(X, Y, np.flipud(V[:,:,0]), rstride=1, cstride=1, cmap=cm.coolwarm, linewidth=0, antialiased=False)
#ax.set_zlim(V[:,:,0].min(), V[:,:,0].max())
#ax.zaxis.set_major_locator(LinearLocator(10))
#ax.zaxis.set_major_formatter(FormatStrFormatter('%.02f'))
#fig.colorbar(surf, shrink=0.5, aspect=5)

plt.show()

sys.exit(0)

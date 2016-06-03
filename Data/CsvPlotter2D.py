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
#		print 'V['+str(i)+','+str(j)+']=dataMatrix['+str((NumPosX*i)+j)+',4]'
#		print 'dataMatrix['+str((NumPosX*i)+j)+',4]='+str(dataMatrix[(NumPosX*i)+j,4])
		V[i,j,:]=dataMatrix[(NumPosX*i)+j,4:]
V=np.flipud(V)

V10=V[:,:,0]
V20=V[:,:,1]
V13=V[:,:,2]
V23=V[:,:,3]

fig, axes = plt.subplots(nrows=2, ncols=2)
i=0
for ax in axes.flat:
	im = ax.imshow(V[:,:,i], vmin=V[:,:,i].min(), vmax=V[:,:,i].max())
	ax.set_title('V[:,:,'+str(i)+']')
	i+=1

fig.subplots_adjust(right=0.8)
cbar_ax = fig.add_axes([0.85, 0.15, 0.05, 0.7])
fig.colorbar(im, cax=cbar_ax)




## 3D plot, gradient
#X = np.unique(dataMatrix[:,0])
#Y = np.unique(dataMatrix[:,1])
#X, Y = np.meshgrid(X, Y)


#Vgy=np.empty([NumPosY,NumPosX,4])  #.......................................................
#Vgx=Vgy
#Vgx, Vgy=np.gradient(V10,X[1,1],Y[1,1])


#plt.imshow(Vgy+Vgx,cmap=cm.coolwarm,origin='low',interpolation='nearest')




#plt.imshow(Vg[:,:,0])

#ax = fig.gca(projection='3d')
#surf = ax.plot_surface(X, Y, np.flipud(V[:,:,0]), rstride=1, cstride=1, cmap=cm.coolwarm, linewidth=0, antialiased=False)
#ax.set_zlim(V[:,:,0].min(), V[:,:,0].max())
#ax.zaxis.set_major_locator(LinearLocator(10))
#ax.zaxis.set_major_formatter(FormatStrFormatter('%.02f'))
#fig.colorbar(surf, shrink=0.5, aspect=5)

plt.show()

sys.exit(0)

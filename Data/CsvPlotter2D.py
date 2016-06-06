from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter
import matplotlib.pyplot as plt
import numpy as np
import sys
from mpl_toolkits.axes_grid1 import make_axes_locatable


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
names=['V10','V20','V13','V23']



# specifies the number of rows and columns in the figure. this will create (row x column) number of subplots.
row = 2
column = 2

# fig refers to the figure that will display the subplots
# ax is an array and refers to the axis for each subplot
fig, ax = plt.subplots(row, column, facecolor='w', figsize=(15,10))

# sets the title to be displayed at the top of the figure.
fig.suptitle('Title of fig', fontsize=24)

# iterates over each axis, ax, and plots random data
for i, ax in enumerate(ax.flat, start=0):#######################################
  
  # sets the title for subplot i
  ax.set_title(names[i])
  
  # plots random data using the 'jet' colormap
  img = ax.imshow(V[:,:,i], vmin=V[:,:,i].min(), vmax=V[:,:,i].max(),interpolation='none')
  
  # creates a new axis, cax, located 0.05 inches to the right of ax, whose width is 15% of ax
  # cax is used to plot a colorbar for each subplot
  div = make_axes_locatable(ax)
  cax = div.append_axes("right", size="15%", pad=0.05)
  cbar = plt.colorbar(img, cax=cax, ticks=np.arange(V[:,:,i].min(),V[:,:,i].max(),1), format="%.2f")
  cbar.set_label('Colorbar {}'.format(i), size=10)
  
  # removes x and y ticks
  ax.xaxis.set_visible(False)
  ax.yaxis.set_visible(False)

# prevents each subplot's axes from overlapping
plt.tight_layout()

# moves subplots down slightly to make room for the figure title
plt.subplots_adjust(top=0.9)
plt.show()







#fig, axes = plt.subplots(nrows=2, ncols=2)
#i=0
#for ax in axes.flat:
#	im = ax.imshow(V[:,:,i], vmin=V[:,:,:].min(), vmax=V[:,:,:].max())
#	ax.set_title('V[:,:,'+str(i)+']')
#	i+=1
#	plt.colorbar()


#fig.colorbar(im)
#fig.subplots_adjust(right=0.8)
#cbar_ax = fig.add_axes([0.85, 0.15, 0.05, 0.7])
#fig.colorbar(im, cax=cbar_ax)




## 3D plot, gradient
#X = np.unique(dataMatrix[:,0])
#Y = np.unique(dataMatrix[:,1])
#X, Y = np.meshgrid(X, Y)

#plt.figure()
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

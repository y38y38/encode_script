import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pylab as plt
import sys

from scipy.interpolate import interp1d


args = sys.argv

if ((len(args)  - 1 )% 2):
    print("error args" )
    print(len(args))
    exit()

num_of_codec = (len(args) / 2) 

#fps =  float (30000 / 1001 )
#fps =  float (29.97002997002997 )
fps =  30
#print(fps)
gop = 30
color_list = ["b","g","r", "c"]

def average_frame_size(frames, frame):
    total_size = 0
    num_of_frame = 0
    for j in range(0, gop):
        #print(frame )
        #print(gop)
        #print(j)
        if (((frame - gop) + (j + 1)) >= 0):
            total_size += frames[(frame - gop) + j + 1]
            num_of_frame+=1

    #print(total_size),
    #print(num_of_frame),
    #print(fps)
    return (((total_size * 8)/ num_of_frame) * fps)

def get_max_value(numbers):
    size = len(numbers)
    max = 0
    for i in range(0, size):
        if (max < numbers[i]): 
            max = numbers[i]
    return max
    
def get_quality_table(path):
    table = np.loadtxt(path, dtype="float", delimiter=",");
    return table


for i in range(0, num_of_codec, 1):
    #print(args[i*2])
    #qtable = np.loadtxt(args[(i*2) + 1], dtype="float", delimiter=",");
    qtable = get_quality_table(args[(i*2) + 1])
    size = len(qtable)
    psnr = np.zeros(size, dtype="float")
    bitrate= np.zeros(size, dtype="int64")
    for j in range( 0, size) :
        psnr[j] = qtable[j][1]
        bitrate[j] = (qtable[j][2] * 8) / 10
    f = interp1d(bitrate, psnr, kind='cubic')
    xnew = np.linspace(bitrate[0] ,bitrate[size - 1], num=51)
    plt.scatter(bitrate, psnr)
    plt.plot(bitrate, psnr, "o", color=color_list[i], label = args[(i*2) + 2])
    plt.plot(xnew, f(xnew), '-',color=color_list[i])

plt.xlabel('bitrate[bps]')
plt.ylabel('PSNR[dB]')
plt.legend(loc = "lower right")
plt.ylim([0,45])
plt.savefig('frame_size.png')

exit()

#data = np.loadtxt("aa.cvs");
quality_table = np.loadtxt("result.txt", dtype="float", delimiter=",");
print(quality_table)
print(len(quality_table))
size = len(quality_table)
psnr = np.zeros(size, dtype="float")
bitrate= np.zeros(size, dtype="int64")

for i in range( 0, size) :
    psnr[i] = quality_table[i][1]
    bitrate[i] = (quality_table[i][2] * 8) / 10

print(psnr)
print(bitrate)


f = interp1d(bitrate, psnr, kind='cubic')
xnew = np.linspace(bitrate[0] ,bitrate[size - 1], num=51)
plt.scatter(bitrate, psnr)
plt.plot(bitrate, psnr, "o", color='green')
plt.plot(xnew, f(xnew), '-', color='green')
#plt.xlim([0,bitrate[size - 1]])
plt.ylim([0,45])
plt.savefig('frame_size.png')

exit()
#print(len(frame_sizes))

b = len(frame_sizes)
#data2 = np.zeros((b, 3), dtype="int64")
data2 = np.zeros(b, dtype="int64")
data3 = np.zeros(b, dtype="int64")
data4 = np.zeros(b, dtype="int64")
#print(data2)
#for i in range( 0, 1) :
for i in range( 0, b) :
    data2[i] = i
    data3[i] = average_frame_size( frame_sizes, i)
    data4[i] = 4000000

#print(data2)
#print(data3)
#print(frame_sizes)

data3_max = get_max_value(data3)
data3_max = data3_max * 1.3
frame_size_max = get_max_value(frame_sizes)
frame_size_max = frame_size_max * 1.3

#plt.plot(data2, data3)
#plt.plot(data2, data3)
#plt.savefig('frame_size.png')

#ax1 = plt.subplots()
#ax1.plot(data2, frame_sizes)
#ax1.plot(data3)
#ax2 = ax1.twinx()
#ax2.plot(data3)

#plt.savefig('frame_size.png')


fig, ax1  = plt.subplots()
ax2 = ax1.twinx()

#ax1.plot(data2, data3, linewidth=2, color="red", linestyle="solid", marker="o", markersize=4, label='bitrate')
ax1.plot(data2, data3, linewidth=2, color="red", linestyle="solid",  label='real bitrate')
ax1.plot(data2, data4, linewidth=2, color="green", linestyle="solid", label='target bitrate')
ax1.plot(data2, data4, linewidth=2, color="green", linestyle="solid", label='peak bitrate')
ax2.bar(data2,frame_sizes, label='frame size')

#range of y
#ax2.set_ylim([0,00])
#ax1.set_ylim([0,7000000])
#print (data3_max)
#print (frame_size_max)
ax1.set_ylim([0,data3_max])
ax2.set_ylim([0,frame_size_max])

ax1.set_zorder(2)
ax2.set_zorder(1)

ax1.patch.set_alpha(0)

ax1.legend(bbox_to_anchor=(0, 1), loc='upper left', borderaxespad=0.5, fontsize=10)
ax2.legend(bbox_to_anchor=(0, 0.9), loc='upper left', borderaxespad=0.5, fontsize=10)

ax1.grid(True)

plt.xlabel('frame')
ax1.set_ylabel('bitrate')
ax2.set_ylabel('frame size')

ax1.yaxis.set_major_formatter(plt.FuncFormatter(lambda x, loc: "{:,}".format(int(x))))
ax2.yaxis.set_major_formatter(plt.FuncFormatter(lambda x, loc: "{:,}".format(int(x))))


plt.subplots_adjust(left=0.16)

plt.savefig('frame_size.png')



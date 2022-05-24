import matplotlib.pyplot as plt
import numpy as np
import seaborn


temp = []

#peak performance [GFLOPS]
peak_perf =  1700
#sustainable bandwidth [GB/sec]
stream_bw =  70
#[operational intensity, gflops, color, name]
kernel = [[0.50, 20, 'red', 'kernel 1'], [10, 100, 'blue', 'kernel 2'], [40, 1000, 'green', 'kernel 3']]

plt.figure()

x = np.arange(0.01,100,0.01)
left_roof = x * stream_bw
for i in range(len(x)):
    plt.plot(kernel[i][0], kernel[i][1], 'p', color=kernel[i][2], label=kernel[i][3])

#setup
plt.xscale("log")
plt.yscale("log")
plt.grid(which="both")
plt.xlim([0.01,100])
plt.title('Roofine')
plt.xlabel('Operational intensity (flops/byte)')
plt.ylabel('Performance [Gflops/sec]')
plt.legend(loc='upper left')

plt.show()
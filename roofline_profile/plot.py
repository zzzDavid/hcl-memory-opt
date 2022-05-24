import matplotlib.pyplot as plt
import numpy as np
import seaborn

def settings(ax, title):
    # roofline
    ax.plot(index, roofline)
    # settings
    ax.legend(loc='upper left')
    ax.set_xlabel('Operational Intensity (FLOPs/Byte)')
    ax.set_ylabel('Attainable Performance (FLOPs/sec)')
    ax.set_xscale('log')
    ax.set_yscale('log')
    ax.set_title(title)
    return ax



# Platform
BW = 25.6*1e9 # Byte/s
PeakPerformance = 18*1e9 # FLOPs/sec
Imax = PeakPerformance / BW # FLOPs/Byte, Max Operational Intensity

# Kernel
# buffer_at
# [0]: gemm; [1]: gemm+buffer; [2]:gemm+acc; [3]: conv2d; [4]: conv2d+acc

MemoryAccess_buffer = np.array([2147483648, 1074790400, 1074790400, 583200, 297000]) # number of memory access
ArithOps_buffer = np.array([1073741824, 1073741824, 1073741824, 291600, 291600]) # number of arithmetic operations
Latency_buffer = np.array([25.788, 23.639, 2.156, 6.978*1e-3, 0.639*1e-3]) # seconds

I_buffer = ArithOps_buffer / (MemoryAccess_buffer * 4) # FLOPs/Byte
P_buffer = ArithOps_buffer  / Latency_buffer # FLOPs/sec

# print(f"I_buffer: {I_buffer}")
# print(f"P_buffer: {P_buffer}")

# reuse_at
# [0]: blur; [1]: blur+LB; [2]: conv2d-nchw; [3] conv2d-nchw+LB; [4]: conv2d-nchw+LB+WB; [5]: 5point; [6]: 5point+LB+WB; [7]: diag3d; [8]: diag3d+xyz

MemoryAccess_reuse = np.array([4186112, 2095104, 251136, 151296, 151296, 5400, 1924, 107520, 59520])
ArithOps_reuse = np.array([2093056, 2093056, 248832, 248832, 248832, 3600, 3600, 53760, 53760])
Latency_reuse = np.array([20.93*1e-3, 10.486*1e-3, 0.69*1e-3, 0.70*1e-3, 43.72*1e-6, 27.03*1e-6, 10.27*1e-6, 0.538*1e-3, 0.326*1e-3])

I_reuse = ArithOps_reuse / (MemoryAccess_reuse * 4) # FLOPs/Byte
P_reuse = ArithOps_reuse  / Latency_reuse # FLOPs/sec

# roofline
index = np.arange(0, 3)

roofline = np.zeros(index.shape)
for i, ind in enumerate(index):
    if ind < Imax:
        roofline[i] = BW * ind
    else:
        roofline[i] = PeakPerformance


color = ['b', 'g', 'r', 'c', 'm', 'y']

# Plot 1: Reuse Buffer + Write Buffer
fig, ax = plt.subplots(1, 2, figsize=(8, 6))
# reuse_at
ax[0].scatter(I_reuse[0:2], P_reuse[0:2], label='blur', color=color[1])
ax[0].scatter(I_reuse[2:5], P_reuse[2:5], label='conv2d', color=color[2])
ax[0].scatter(I_reuse[5:7], P_reuse[5:7], label='5point', color=color[3])
ax[0].scatter(I_reuse[7:9], P_reuse[7:9], label='diag3d', color=color[4])
ax[0] = settings(ax[0], "(a) Roofline Model: Reuse Buffer")

# buffer_at
ax[1].scatter(I_buffer[0:3], P_buffer[0:3], label="gemm", color=color[1])
ax[1].scatter(I_buffer[3:5], P_buffer[3:5], label="conv2d", color=color[2])
ax[1] = settings(ax[1], "(b) Roofline Model: Write Buffer")

plt.tight_layout()
plt.savefig("roofline_all.png")


# Plot 2: reuse_at for each applications
fig, ax = plt.subplots(2, 2, figsize=(8, 8))
# reuse_at: blur
ax[0][0].scatter(I_reuse[0], P_reuse[0], label="blur", marker='o', color=color[1])
ax[0][0].scatter(I_reuse[1], P_reuse[1], label="blur+LB", marker='x', color=color[1])
ax[0][0].plot(I_reuse[0:2], P_reuse[0:2], '--', color='orange')
ax[0][0] = settings(ax[0][0], "(a) Reuse Buffer Optimization: Blur")

# reuse_at: conv2d
ax[0][1].scatter(I_reuse[2], P_reuse[2], label="conv2d-nchw", marker='o', color=color[2])
ax[0][1].scatter(I_reuse[3], P_reuse[3], label="conv2d-nchw+LB", marker='x', color=color[2])
ax[0][1].scatter(I_reuse[4], P_reuse[4], label="conv2d-nchw+LB+WB", marker='s', color=color[2])
ax[0][1].plot(I_reuse[2:5], P_reuse[2:5], '--', color='orange')
ax[0][1] = settings(ax[0][1], "(b) Reuse Buffer Optimization: Conv2D")

# reuse_at: 5point
ax[1][0].scatter(I_reuse[5], P_reuse[5], label="5point", marker='o', color=color[3])
ax[1][0].scatter(I_reuse[6], P_reuse[6], label="5point+LB+WB", marker='x', color=color[3])
ax[1][0].plot(I_reuse[5:7], P_reuse[5:7], '--', color='orange')
ax[1][0] = settings(ax[1][0], "(c) Reuse Buffer Optimization: 5point")

# reuse_at: diag3d
ax[1][1].scatter(I_reuse[7], P_reuse[7], label="diag3d", marker='o', color=color[4])
ax[1][1].scatter(I_reuse[8], P_reuse[8], label="diag3d+LB+WB", marker='x', color=color[4])
ax[1][1].plot(I_reuse[7:9], P_reuse[7:9], '--', color='orange')
ax[1][1] = settings(ax[1][1], "(d) Reuse Buffer Optimization: Diag3D")
plt.tight_layout()
plt.savefig("roofline_reuse_at.png")



# Plot 3: buffer_at for each applications
fig, ax = plt.subplots(1, 2, figsize=(8, 6))
# buffer_at: gemm
ax[0].scatter(I_buffer[0], P_buffer[0], label="gemm", marker='o', color=color[1])
ax[0].scatter(I_buffer[1], P_buffer[1], label="gemm+buffer", marker='x', color=color[1])
ax[0].scatter(I_buffer[2], P_buffer[2], label="gemm+acc", marker='s', color=color[1])
ax[0].plot(I_buffer[0:3], P_buffer[0:3], '--', color='orange')
ax[0] = settings(ax[0], "(a) Write Buffer Optimization: GEMM")

# buffer_at: conv2d
ax[1].scatter(I_buffer[3], P_buffer[3], label="conv2d", marker='o', color=color[2])
ax[1].scatter(I_buffer[4], P_buffer[4], label="conv2d+acc", marker='x', color=color[2])
ax[1].plot(I_buffer[3:5], P_buffer[3:5], '--', color='orange')

ax[1] = settings(ax[1], "(b) Write Buffer Optimization: Conv2D")
plt.tight_layout()
plt.savefig("roofline_buffer_at.png")
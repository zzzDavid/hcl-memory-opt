import heterocl as hcl
import numpy as np
import sys

dtype = hcl.Int()

if len(sys.argv) == 1:
    target = None
else:
    target = hcl.Platform.xilinx_zc706
    target.config(compiler="vivado_hls", mode="debug", project="diag.prj")

def test_reuse_blur_x_y_z_3D():
    hcl.init(dtype)
    A = hcl.placeholder((34, 32, 30), "A")

    def blur(A):
        B = hcl.compute((32, 30, 28), lambda y, x, z: A[y, x, z] + A[y+1, x+1, z+1] + A[y+2, x+2, z+2], "B", dtype=dtype)
        return B

    s = hcl.create_schedule([A], blur)
    B = blur.B
    RB_y = s.reuse_at(A, s[B], B.axis[0], "RB_y")
    RB_x = s.reuse_at(RB_y, s[B], B.axis[1], "RB_x")
    RB_z = s.reuse_at(RB_x, s[B], B.axis[2], "RB_z")
    if target != None:  # FPGA backend
        s.partition(RB_y, dim=1)
        s.partition(RB_x, dim=1)
        s.partition(RB_x, dim=2)
        s.partition(RB_z, dim=1)
        s.partition(RB_z, dim=2)
        s.partition(RB_z, dim=3)
        s[B].pipeline(B.axis[2])

        f = hcl.build(s, target=target)
        print(s.device_module)
        f()

    else:  # CPU backend

        f = hcl.build(s, target=target)
        print(s.device_module)

        np_A = np.random.randint(0, 30, size=(34, 32, 30))
        np_B = np.zeros((32, 30, 28), dtype="int")
        np_C = np.zeros((32, 30, 28), dtype="int")

        for y in range(0, 32):
            for x in range(0, 30):
                for z in range(0, 28):
                    np_C[y][x][z] = np_A[y][x][z] + np_A[y+1][x+1][z+1] + np_A[y+2][x+2][z+2]

        hcl_A = hcl.asarray(np_A)
        hcl_B = hcl.asarray(np_B)

        f(hcl_A, hcl_B)

        np_B = hcl_B.asnumpy()

        assert np.array_equal(np_B, np_C)

if __name__ == "__main__":
    test_reuse_blur_x_y_z_3D()
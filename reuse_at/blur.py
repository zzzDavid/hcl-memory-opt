import heterocl as hcl
import numpy as np
import sys

dtype = hcl.Int()

if len(sys.argv) == 1:
    target = None
else:
    target = hcl.Platform.xilinx_zc706
    target.config(compiler="vivado_hls", mode="debug", project="blur-no-opt.prj")


def test_reuse_blur_x():
    hcl.init()
    A = hcl.placeholder((1024, 1024))

    def blur(A):
        B = hcl.compute(
            (1024, 1022),
            lambda y, x: A[y, x] + A[y, x + 1] + A[y, x + 2],
            "B",
            dtype=dtype,
        )
        return B

    s = hcl.create_schedule([A], blur)
    B = blur.B
    # RB = s.reuse_at(A, s[B], B.axis[1])

    if target != None:  # FPGA backend
        # s.partition(RB, dim=1)
        s[B].pipeline(B.axis[1])

        f = hcl.build(s, target=target)
        print(s.device_module)
        f()

    else:  # CPU backend

        f = hcl.build(s, target=target)
        print(s.device_module)

        np_A = np.random.randint(0, 1024, size=(1024, 1024))
        np_B = np.zeros((1024, 1022), dtype="int")
        np_C = np.zeros((1024, 1022), dtype="int")

        for y in range(0, 1024):
            for x in range(0, 1022):
                np_C[y][x] = np_A[y][x] + np_A[y][x + 1] + np_A[y][x + 2]

        hcl_A = hcl.asarray(np_A, dtype=hcl.Int(1024))
        hcl_B = hcl.asarray(np_B, dtype=hcl.Int(1024))

        f(hcl_A, hcl_B)

        np_B = hcl_B.asnumpy()

        assert np.array_equal(np_B, np_C)


if __name__ == "__main__":
    test_reuse_blur_x()

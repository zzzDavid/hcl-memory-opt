import heterocl as hcl
import numpy as np
import sys

width, height = 10, 10

dtype = hcl.Int()
# dtype = hcl.Float()

if len(sys.argv) == 1:
    target = None
else:
    target = hcl.Platform.xilinx_zc706
    target.config(compiler="vivado_hls", mode="debug", project="stencil.prj")


def test_stencil():
    hcl.init(dtype)
    A = hcl.placeholder((width, height))

    def stencil(A):
        B = hcl.compute(
            (width - 2, height - 2),
            lambda i, j: A[i, j + 1]
            + A[i + 1, j]
            + A[i + 1, j + 1]
            + A[i + 1, j + 2]
            + A[i + 2, j + 1],
            name="B",
            dtype=dtype,
        )
        return B

    s = hcl.create_schedule([A], stencil)
    B = stencil.B
    LB = s.reuse_at(A, s[B], B.axis[0])
    WB = s.reuse_at(LB, s[B], B.axis[1])
    if target != None:  # FPGA backend
        s.partition(LB, dim=1)
        s.partition(WB, dim=1)
        s.partition(WB, dim=2)
        s.partition(A, dim=2)
        s[B].pipeline(B.axis[1])

        f = hcl.build(s, target=target)
        print(s.device_module)
        f()

    else:  # CPU backend
        print(hcl.build(s, "vhls"))
        f = hcl.build(s, target=target)
        print(s.device_module)

        if dtype == hcl.Int():
            np_A = np.random.randint(0, 10, size=(width, height))
            np_C = np.zeros((width - 2, height - 2), dtype="int")
        else:
            np_A = np.random.rand(width, height)
            np_C = np.zeros((width - 2, height - 2), dtype="float")

        for i in range(0, width - 2):
            for j in range(0, height - 2):
                np_C[i][j] += (
                    np_A[i + 1, j]
                    + np_A[i + 1, j + 1]
                    + np_A[i + 1, j + 2]
                    + np_A[i, j + 1]
                    + np_A[i + 2, j + 1]
                )

        hcl_A = hcl.asarray(np_A, dtype=dtype)
        hcl_C = hcl.asarray(np_C, dtype=dtype)

        f(hcl_A, hcl_C)

        assert np.array_equal(np_C, hcl_C.asnumpy())


if __name__ == "__main__":
    test_stencil()

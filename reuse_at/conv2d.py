import heterocl as hcl
import numpy as np
import sys

bs = 4
ic, oc = 6, 16
ih, iw = 8, 8
kh, kw = 3, 3
oh, ow = ih - kh + 1, iw - kw + 1

# dtype = hcl.Int()
dtype = hcl.Float()

if len(sys.argv) == 1:
    target = None
else:
    target = hcl.Platform.xilinx_zc706
    target.config(compiler="vivado_hls", mode="debug", project="conv2d-lb-wb.prj")


def test_conv2D_nchw():
    hcl.init(dtype)
    A = hcl.placeholder((bs, ic, ih, iw))
    F = hcl.placeholder((oc, ic, kh, kw))

    def conv(A, F):
        rc = hcl.reduce_axis(0, ic)
        rh = hcl.reduce_axis(0, kh)
        rw = hcl.reduce_axis(0, kw)
        B = hcl.compute(
            (bs, oc, oh, ow),
            lambda n, c, h, w: hcl.sum(
                A[n, rc, h + rh, w + rw] * F[c, rc, rh, rw],
                axis=[rc, rh, rw],
                dtype=dtype,
            ),
            name="B",
            dtype=dtype,
        )
        return B

    s = hcl.create_schedule([A, F], conv)
    B = conv.B
    LB = s.reuse_at(A, s[B], B.axis[2])
    WB = s.reuse_at(LB, s[B], B.axis[3])
    if target != None:  # FPGA backend
        s.partition(LB, dim=2)
        s.partition(WB, dim=2)
        s.partition(WB, dim=3)
        s.partition(F, dim=2)
        s.partition(F, dim=3)
        s.partition(F, dim=4)
        s.partition(A, dim=2)
        s[B].pipeline(B.axis[3])

        f = hcl.build(s, target=target)
        print(s.device_module)
        f()

    else:  # CPU backend
        f = hcl.build(s, target=target)
        print(s.device_module)

        if dtype == hcl.Int():
            np_A = np.random.randint(0, 10, size=(bs, ic, ih, iw))
            np_B = np.random.randint(0, 10, size=(oc, ic, kh, kw))
            np_C = np.zeros((bs, oc, oh, ow), dtype="int")
        else:
            np_A = np.random.rand(bs, ic, ih, iw)
            np_B = np.random.rand(oc, ic, kh, kw)
            np_C = np.zeros((bs, oc, oh, ow), dtype="float")

        for n in range(0, bs):
            for c in range(0, oc):
                for y in range(0, oh):
                    for x in range(0, ow):
                        for rc in range(0, ic):
                            for rh in range(0, kh):
                                for rw in range(0, kw):
                                    np_C[n][c][y][x] += (
                                        np_A[n][rc][y + rh][x + rw]
                                        * np_B[c][rc][rh][rw]
                                    )

        hcl_A = hcl.asarray(np_A, dtype=dtype)
        hcl_B = hcl.asarray(np_B, dtype=dtype)
        hcl_C = hcl.asarray(np_C, dtype=dtype)

        f(hcl_A, hcl_B, hcl_C)

        assert np.array_equal(np_C, hcl_C.asnumpy())


if __name__ == "__main__":
    test_conv2D_nchw()

import heterocl as hcl
import numpy as np
import sys

from hcl_mlir import Module, Context, Location
from hcl_mlir.dialects import hcl as hcl_d

from utility import ProfileKernel

# Context
class GlobalContext(object):
    def __init__(self):
        self.ctx = None
        self.loc = None

    def get_context(self):
        return self.ctx

    def set_context(self):
        self.ctx = Context()
        hcl_d.register_dialect(self.ctx)
        self.loc = Location.unknown(self.ctx)

    def get_location(self):
        return self.loc

global_ctx = GlobalContext()
get_context = global_ctx.get_context
set_context = global_ctx.set_context
get_location = global_ctx.get_location




def load_mlir(filename):
    # f = open(filename, 'r')
    # print(f.read())

    set_context()

    with open(filename, 'r') as f:
        with get_context() as ctx, get_location():
            module = Module.parse(f.read(), ctx) # s.device_module
            # print(module)
            # print(module.body.operations)
            # for func in module.body.operations:
            #     print(func)
            return module


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python profile.py <filename>")
        exit(1)
    else:
        filename = sys.argv[1]

    module = load_mlir(filename)
    num_memory_access, num_arith_op = ProfileKernel(module)

    print("================ Finish Analysis ==================")
    print(f"# of Memory Access: {num_memory_access}")
    print(f"# of Arith Op: {num_arith_op}")
module {
  func @top(%arg0: memref<34x32x30xi32>) -> memref<32x30x28xi32> attributes {extra_itypes = "s", extra_otypes = "s", llvm.emit_c_interface, top} {
    %0 = memref.alloc() {name = "B"} : memref<32x30x28xi32>
    affine.for %arg1 = 0 to 32 {
      affine.for %arg2 = 0 to 30 {
        affine.for %arg3 = 0 to 28 {
          %1 = affine.load %arg0[%arg1, %arg2, %arg3] {from = "A"} : memref<34x32x30xi32>
          %2 = affine.load %arg0[%arg1 + 1, %arg2 + 1, %arg3 + 1] {from = "A"} : memref<34x32x30xi32>
          %3 = arith.addi %1, %2 : i32
          %4 = affine.load %arg0[%arg1 + 2, %arg2 + 2, %arg3 + 2] {from = "A"} : memref<34x32x30xi32>
          %5 = arith.addi %3, %4 : i32
          affine.store %5, %0[%arg1, %arg2, %arg3] {to = "B"} : memref<32x30x28xi32>
        } {loop_name = "z"}
      } {loop_name = "x"}
    } {loop_name = "y", stage_name = "B"}
    return %0 : memref<32x30x28xi32>
  }
}
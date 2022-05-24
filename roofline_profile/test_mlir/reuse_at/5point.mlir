module {
  func @top(%arg0: memref<32x32xi32>) -> memref<30x30xi32> attributes {extra_itypes = "s", extra_otypes = "s", llvm.emit_c_interface, top} {
    %0 = memref.alloc() {name = "B"} : memref<30x30xi32>
    affine.for %arg1 = 0 to 30 {
      affine.for %arg2 = 0 to 30 {
        %1 = affine.load %arg0[%arg1, %arg2 + 1] {from = "compute_0"} : memref<32x32xi32>
        %2 = affine.load %arg0[%arg1 + 1, %arg2] {from = "compute_0"} : memref<32x32xi32>
        %3 = arith.addi %1, %2 : i32
        %4 = affine.load %arg0[%arg1 + 1, %arg2 + 1] {from = "compute_0"} : memref<32x32xi32>
        %5 = arith.addi %3, %4 : i32
        %6 = affine.load %arg0[%arg1 + 1, %arg2 + 2] {from = "compute_0"} : memref<32x32xi32>
        %7 = arith.addi %5, %6 : i32
        %8 = affine.load %arg0[%arg1 + 2, %arg2 + 1] {from = "compute_0"} : memref<32x32xi32>
        %9 = arith.addi %7, %8 : i32
        affine.store %9, %0[%arg1, %arg2] {to = "B"} : memref<30x30xi32>
      } {loop_name = "j"}
    } {loop_name = "i", stage_name = "B"}
    return %0 : memref<30x30xi32>
  }
}
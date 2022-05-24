module {
  func @top(%arg0: memref<1024x1024xi32>) -> memref<1024x1022xi32> attributes {extra_itypes = "s", extra_otypes = "s", llvm.emit_c_interface, top} {
    %0 = memref.alloc() {name = "B"} : memref<1024x1022xi32>
    affine.for %arg1 = 0 to 1024 {
      affine.for %arg2 = 0 to 1022 {
        %1 = affine.load %arg0[%arg1, %arg2] {from = "compute_0"} : memref<1024x1024xi32>
        %2 = affine.load %arg0[%arg1, %arg2 + 1] {from = "compute_0"} : memref<1024x1024xi32>
        %3 = arith.addi %1, %2 : i32
        %4 = affine.load %arg0[%arg1, %arg2 + 2] {from = "compute_0"} : memref<1024x1024xi32>
        %5 = arith.addi %3, %4 : i32
        affine.store %5, %0[%arg1, %arg2] {to = "B"} : memref<1024x1022xi32>
      } {loop_name = "x"}
    } {loop_name = "y", stage_name = "B"}
    return %0 : memref<1024x1022xi32>
  }
}
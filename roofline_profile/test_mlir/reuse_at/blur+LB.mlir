#set = affine_set<(d0) : (d0 - 2 >= 0)>
module {
  func @top(%arg0: memref<1024x1024xi32>) -> memref<1024x1022xi32> attributes {extra_itypes = "s", extra_otypes = "s", llvm.emit_c_interface, top} {
    %0 = memref.alloc() {name = "B"} : memref<1024x1022xi32>
    %1 = memref.alloc() : memref<3xi32>
    affine.for %arg1 = 0 to 1024 {
      affine.for %arg2 = 0 to 1024 {
        %2 = affine.load %1[1] : memref<3xi32>
        affine.store %2, %1[0] : memref<3xi32>
        %3 = affine.load %1[2] : memref<3xi32>
        affine.store %3, %1[1] : memref<3xi32>
        %4 = affine.load %arg0[%arg1, %arg2] : memref<1024x1024xi32>
        affine.store %4, %1[2] : memref<3xi32>
        affine.if #set(%arg2) {
          %5 = affine.load %1[0] : memref<3xi32>
          %6 = affine.load %1[1] : memref<3xi32>
          %7 = arith.addi %5, %6 : i32
          %8 = affine.load %1[2] : memref<3xi32>
          %9 = arith.addi %7, %8 : i32
          affine.store %9, %0[%arg1, %arg2 - 2] : memref<1024x1022xi32>
        }
      } {loop_name = "x"}
    } {loop_name = "y", stage_name = "B"}
    return %0 : memref<1024x1022xi32>
  }
}
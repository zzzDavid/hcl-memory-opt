#set = affine_set<(d0) : (d0 - 2 >= 0)>
module {
  func @top(%arg0: memref<34x32x30xi32>) -> memref<32x30x28xi32> attributes {extra_itypes = "s", extra_otypes = "s", llvm.emit_c_interface, top} {
    %0 = memref.alloc() {name = "B"} : memref<32x30x28xi32>
    %1 = memref.alloc() : memref<3x32x30xi32>
    %2 = memref.alloc() : memref<3x3x30xi32>
    %3 = memref.alloc() : memref<3x3x3xi32>
    affine.for %arg1 = 0 to 34 {
      affine.for %arg2 = 0 to 32 {
        affine.for %arg3 = 0 to 30 {
          %4 = affine.load %1[1, %arg2, %arg3] : memref<3x32x30xi32>
          affine.store %4, %1[0, %arg2, %arg3] : memref<3x32x30xi32>
          %5 = affine.load %1[2, %arg2, %arg3] : memref<3x32x30xi32>
          affine.store %5, %1[1, %arg2, %arg3] : memref<3x32x30xi32>
          %6 = affine.load %arg0[%arg1, %arg2, %arg3] : memref<34x32x30xi32>
          affine.store %6, %1[2, %arg2, %arg3] : memref<3x32x30xi32>
        } {spatial}
        affine.if #set(%arg1) {
          affine.for %arg3 = 0 to 30 {
            affine.for %arg4 = 0 to 3 {
              %4 = affine.load %2[%arg4, 1, %arg3] : memref<3x3x30xi32>
              affine.store %4, %2[%arg4, 0, %arg3] : memref<3x3x30xi32>
              %5 = affine.load %2[%arg4, 2, %arg3] : memref<3x3x30xi32>
              affine.store %5, %2[%arg4, 1, %arg3] : memref<3x3x30xi32>
              %6 = affine.load %1[%arg4, %arg2, %arg3] : memref<3x32x30xi32>
              affine.store %6, %2[%arg4, 2, %arg3] : memref<3x3x30xi32>
            } {spatial}
          } {spatial}
          affine.if #set(%arg2) {
            affine.for %arg3 = 0 to 30 {
              affine.for %arg4 = 0 to 3 {
                affine.for %arg5 = 0 to 3 {
                  %4 = affine.load %3[%arg4, %arg5, 1] : memref<3x3x3xi32>
                  affine.store %4, %3[%arg4, %arg5, 0] : memref<3x3x3xi32>
                  %5 = affine.load %3[%arg4, %arg5, 2] : memref<3x3x3xi32>
                  affine.store %5, %3[%arg4, %arg5, 1] : memref<3x3x3xi32>
                  %6 = affine.load %2[%arg4, %arg5, %arg3] : memref<3x3x30xi32>
                  affine.store %6, %3[%arg4, %arg5, 2] : memref<3x3x3xi32>
                } {spatial}
              } {spatial}
              affine.if #set(%arg3) {
                %4 = affine.load %3[0, 0, 0] : memref<3x3x3xi32>
                %5 = affine.load %3[1, 1, 1] : memref<3x3x3xi32>
                %6 = arith.addi %4, %5 : i32
                %7 = affine.load %3[2, 2, 2] : memref<3x3x3xi32>
                %8 = arith.addi %6, %7 : i32
                affine.store %8, %0[%arg1 - 2, %arg2 - 2, %arg3 - 2] : memref<32x30x28xi32>
              }
            } {loop_name = "z"}
          }
        }
      } {loop_name = "x"}
    } {loop_name = "y", stage_name = "B"}
    return %0 : memref<32x30x28xi32>
  }
}
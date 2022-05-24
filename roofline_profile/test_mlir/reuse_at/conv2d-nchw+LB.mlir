#set = affine_set<(d0) : (d0 - 2 >= 0)>
module {
  func @top(%arg0: memref<4x6x8x8xf32>, %arg1: memref<16x6x3x3xf32>) -> memref<4x16x6x6xf32> attributes {extra_itypes = "__", extra_otypes = "_", llvm.emit_c_interface, top} {
    %0 = memref.alloc() {name = "B"} : memref<4x16x6x6xf32>
    %1 = memref.alloc() : memref<6x3x8xf32>
    affine.for %arg2 = 0 to 4 {
      affine.for %arg3 = 0 to 16 {
        affine.for %arg4 = 0 to 8 {
          affine.for %arg5 = 0 to 8 {
            affine.for %arg6 = 0 to 6 {
              %2 = affine.load %1[%arg6, 1, %arg5] : memref<6x3x8xf32>
              affine.store %2, %1[%arg6, 0, %arg5] : memref<6x3x8xf32>
              %3 = affine.load %1[%arg6, 2, %arg5] : memref<6x3x8xf32>
              affine.store %3, %1[%arg6, 1, %arg5] : memref<6x3x8xf32>
              %4 = affine.load %arg0[%arg2, %arg6, %arg4, %arg5] : memref<4x6x8x8xf32>
              affine.store %4, %1[%arg6, 2, %arg5] : memref<6x3x8xf32>
            } {spatial}
          } {spatial}
          affine.if #set(%arg4) {
            affine.for %arg5 = 0 to 6 {
              %2 = memref.alloc() {name = "sum_rv"} : memref<1xf32>
              %c0 = arith.constant 0 : index
              %cst = arith.constant 0.000000e+00 : f32
              affine.store %cst, %2[%c0] {to = "sum_rv"} : memref<1xf32>
              affine.for %arg6 = 0 to 6 {
                affine.for %arg7 = 0 to 3 {
                  affine.for %arg8 = 0 to 3 {
                    %4 = affine.load %1[%arg6, %arg7, %arg5 + %arg8] : memref<6x3x8xf32>
                    %5 = affine.load %arg1[%arg3, %arg6, %arg7, %arg8] {from = "compute_1"} : memref<16x6x3x3xf32>
                    %6 = arith.mulf %4, %5 : f32
                    %7 = affine.load %2[%c0] {from = "sum_rv"} : memref<1xf32>
                    %8 = arith.addf %6, %7 : f32
                    affine.store %8, %2[%c0] {to = "sum_rv"} : memref<1xf32>
                  } {loop_name = "rx_2", reduction}
                } {loop_name = "rx_1", reduction}
              } {loop_name = "rx_0", reduction}
              %c0_0 = arith.constant 0 : index
              %3 = affine.load %2[%c0_0] {from = "sum_rv"} : memref<1xf32>
              affine.store %3, %0[%arg2, %arg3, %arg4 - 2, %arg5] : memref<4x16x6x6xf32>
            } {loop_name = "w"}
          }
        } {loop_name = "h"}
      } {loop_name = "c"}
    } {loop_name = "n", stage_name = "B"}
    return %0 : memref<4x16x6x6xf32>
  }
}
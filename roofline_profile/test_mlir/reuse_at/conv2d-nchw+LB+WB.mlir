#set = affine_set<(d0) : (d0 - 2 >= 0)>
module {
  func @top(%arg0: memref<4x6x8x8xf32>, %arg1: memref<16x6x3x3xf32>) -> memref<4x16x6x6xf32> attributes {extra_itypes = "__", extra_otypes = "_", llvm.emit_c_interface, top} {
    %0 = memref.alloc() {name = "B"} : memref<4x16x6x6xf32>
    %1 = memref.alloc() : memref<6x3x8xf32>
    %2 = memref.alloc() : memref<6x3x3xf32>
    affine.for %arg2 = 0 to 4 {
      affine.for %arg3 = 0 to 16 {
        affine.for %arg4 = 0 to 8 {
          affine.for %arg5 = 0 to 8 {
            affine.for %arg6 = 0 to 6 {
              %3 = affine.load %1[%arg6, 1, %arg5] : memref<6x3x8xf32>
              affine.store %3, %1[%arg6, 0, %arg5] : memref<6x3x8xf32>
              %4 = affine.load %1[%arg6, 2, %arg5] : memref<6x3x8xf32>
              affine.store %4, %1[%arg6, 1, %arg5] : memref<6x3x8xf32>
              %5 = affine.load %arg0[%arg2, %arg6, %arg4, %arg5] : memref<4x6x8x8xf32>
              affine.store %5, %1[%arg6, 2, %arg5] : memref<6x3x8xf32>
            } {spatial}
            affine.if #set(%arg4) {
              affine.for %arg6 = 0 to 6 {
                affine.for %arg7 = 0 to 3 {
                  %3 = affine.load %2[%arg6, %arg7, 1] : memref<6x3x3xf32>
                  affine.store %3, %2[%arg6, %arg7, 0] : memref<6x3x3xf32>
                  %4 = affine.load %2[%arg6, %arg7, 2] : memref<6x3x3xf32>
                  affine.store %4, %2[%arg6, %arg7, 1] : memref<6x3x3xf32>
                  %5 = affine.load %1[%arg6, %arg7, %arg5] : memref<6x3x8xf32>
                  affine.store %5, %2[%arg6, %arg7, 2] : memref<6x3x3xf32>
                } {spatial}
              } {spatial}
              affine.if #set(%arg5) {
                %3 = memref.alloc() {name = "sum_rv"} : memref<1xf32>
                %c0 = arith.constant 0 : index
                %cst = arith.constant 0.000000e+00 : f32
                affine.store %cst, %3[%c0] {to = "sum_rv"} : memref<1xf32>
                affine.for %arg6 = 0 to 6 {
                  affine.for %arg7 = 0 to 3 {
                    affine.for %arg8 = 0 to 3 {
                      %5 = affine.load %2[%arg6, %arg7, %arg8] : memref<6x3x3xf32>
                      %6 = affine.load %arg1[%arg3, %arg6, %arg7, %arg8] {from = "compute_1"} : memref<16x6x3x3xf32>
                      %7 = arith.mulf %5, %6 : f32
                      %8 = affine.load %3[%c0] {from = "sum_rv"} : memref<1xf32>
                      %9 = arith.addf %7, %8 : f32
                      affine.store %9, %3[%c0] {to = "sum_rv"} : memref<1xf32>
                    } {loop_name = "rx_2", reduction}
                  } {loop_name = "rx_1", reduction}
                } {loop_name = "rx_0", reduction}
                %c0_0 = arith.constant 0 : index
                %4 = affine.load %3[%c0_0] {from = "sum_rv"} : memref<1xf32>
                affine.store %4, %0[%arg2, %arg3, %arg4 - 2, %arg5 - 2] : memref<4x16x6x6xf32>
              }
            }
          } {loop_name = "w"}
        } {loop_name = "h"}
      } {loop_name = "c"}
    } {loop_name = "n", stage_name = "B"}
    return %0 : memref<4x16x6x6xf32>
  }
}
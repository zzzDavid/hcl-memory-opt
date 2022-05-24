module {
  func @kernel(%arg0: memref<3x32x32xf32>, %arg1: memref<6x3x3x3xf32>, %arg2: memref<6x30x30xf32>) {
    affine.for %arg3 = 0 to 6 {
      affine.for %arg4 = 0 to 30 {
        affine.for %arg5 = 0 to 30 {
          affine.for %arg6 = 0 to 3 {
            affine.for %arg7 = 0 to 3 {
              affine.for %arg8 = 0 to 3 {
                %0 = affine.load %arg0[%arg6, %arg4 + %arg7, %arg5 + %arg8] : memref<3x32x32xf32>
                %1 = affine.load %arg1[%arg3, %arg6, %arg7, %arg8] : memref<6x3x3x3xf32>
                %2 = affine.load %arg2[%arg3, %arg4, %arg5] : memref<6x30x30xf32>
                %3 = arith.mulf %0, %1 : f32
                %4 = arith.addf %2, %3 : f32
                affine.store %4, %arg2[%arg3, %arg4, %arg5] : memref<6x30x30xf32>
              } {loop_name = "rx", reduction = 1 : i64}
            } {loop_name = "ry", reduction = 1 : i64}
          } {loop_name = "rc", reduction = 1 : i64}
        } {loop_name = "j"}
      } {loop_name = "i"}
    } {loop_name = "oc", stage_name = "s"}
    return
  }
}
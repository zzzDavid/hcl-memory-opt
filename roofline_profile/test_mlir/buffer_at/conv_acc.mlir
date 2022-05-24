module {
  func @kernel(%arg0: memref<3x32x32xf32>, %arg1: memref<6x3x3x3xf32>, %arg2: memref<6x30x30xf32>) {
    affine.for %arg3 = 0 to 6 {
      affine.for %arg4 = 0 to 30 {
        %0 = memref.alloc() : memref<30xf32>
        %cst = arith.constant 0.000000e+00 : f32
        affine.for %arg5 = 0 to 30 {
          affine.store %cst, %0[%arg5] : memref<30xf32>
        } {loop_name = "j_init", pipeline_ii = 1 : i32}
        affine.for %arg5 = 0 to 3 {
          affine.for %arg6 = 0 to 3 {
            affine.for %arg7 = 0 to 3 {
              affine.for %arg8 = 0 to 30 {
                %1 = affine.load %arg0[%arg5, %arg4 + %arg6, %arg8 + %arg7] : memref<3x32x32xf32>
                %2 = affine.load %arg1[%arg3, %arg5, %arg6, %arg7] : memref<6x3x3x3xf32>
                %3 = affine.load %0[%arg8] : memref<30xf32>
                %4 = arith.mulf %1, %2 : f32
                %5 = arith.addf %3, %4 : f32
                affine.store %5, %0[%arg8] : memref<30xf32>
              } {loop_name = "j", pipeline_ii = 1 : i32}
            } {loop_name = "rx", reduction = 1 : i64}
          } {loop_name = "ry", reduction = 1 : i64}
        } {loop_name = "rc", reduction = 1 : i64}
        affine.for %arg5 = 0 to 30 {
          %1 = affine.load %0[%arg5] : memref<30xf32>
          affine.store %1, %arg2[%arg3, %arg4, %arg5] : memref<6x30x30xf32>
        } {loop_name = "j_back", pipeline_ii = 1 : i32}
      } {loop_name = "i"}
    } {loop_name = "oc", stage_name = "s"}
    return
  }
}
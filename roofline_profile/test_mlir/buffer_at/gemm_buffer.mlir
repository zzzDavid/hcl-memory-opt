module {
  func @kernel(%arg0: memref<1024x512xf32>, %arg1: memref<512x1024xf32>, %arg2: memref<1024x1024xf32>) {
    affine.for %arg3 = 0 to 1024 {
      %0 = memref.alloc() : memref<1024xf32>
      %cst = arith.constant 0.000000e+00 : f32
      affine.for %arg4 = 0 to 1024 {
        affine.store %cst, %0[%arg4] : memref<1024xf32>
      } {loop_name = "j_init", pipeline_ii = 1 : i32}
      affine.for %arg4 = 0 to 1024 {
        affine.for %arg5 = 0 to 512 {
          %1 = affine.load %arg0[%arg3, %arg5] : memref<1024x512xf32>
          %2 = affine.load %arg1[%arg5, %arg4] : memref<512x1024xf32>
          %3 = affine.load %0[%arg4] : memref<1024xf32>
          %4 = arith.mulf %1, %2 : f32
          %5 = arith.addf %4, %3 : f32
          affine.store %5, %0[%arg4] : memref<1024xf32>
        } {loop_name = "k", reduction = 1 : i32}
      } {loop_name = "j"}
      affine.for %arg4 = 0 to 1024 {
        %1 = affine.load %0[%arg4] : memref<1024xf32>
        affine.store %1, %arg2[%arg3, %arg4] : memref<1024x1024xf32>
      } {loop_name = "j_back", pipeline_ii = 1 : i32}
    } {loop_name = "i", stage_name = "s"}
    return
  }
}
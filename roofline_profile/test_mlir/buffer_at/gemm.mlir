module {
  func @kernel(%arg0: memref<1024x512xf32>, %arg1: memref<512x1024xf32>, %arg2: memref<1024x1024xf32>) {
    affine.for %arg3 = 0 to 1024 {
      affine.for %arg4 = 0 to 1024 {
        affine.for %arg5 = 0 to 512 {
          %0 = affine.load %arg0[%arg3, %arg5] : memref<1024x512xf32>
          %1 = affine.load %arg1[%arg5, %arg4] : memref<512x1024xf32>
          %2 = affine.load %arg2[%arg3, %arg4] : memref<1024x1024xf32>
          %3 = arith.mulf %0, %1 : f32
          %4 = arith.addf %3, %2 : f32
          affine.store %4, %arg2[%arg3, %arg4] : memref<1024x1024xf32>
        } {loop_name = "k", reduction = 1 : i32}
      } {loop_name = "j"}
    } {loop_name = "i", stage_name = "s"}
    return
  }
}
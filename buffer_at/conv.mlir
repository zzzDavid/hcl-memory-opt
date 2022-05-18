// RUN: hcl-opt -opt %s
module {
  func @kernel(%Input: memref<3x32x32xf32>, %Kernel: memref<6x3x3x3xf32>, %Output: memref<6x30x30xf32>)
  {
    %loc = hcl.create_loop_handle "oc" : !hcl.LoopHandle
    %li = hcl.create_loop_handle "i" : !hcl.LoopHandle
    %lj = hcl.create_loop_handle "j" : !hcl.LoopHandle
    %lrc = hcl.create_loop_handle "rc" : !hcl.LoopHandle
    %lry = hcl.create_loop_handle "ry" : !hcl.LoopHandle
    %lrx = hcl.create_loop_handle "rx" : !hcl.LoopHandle
    %s = hcl.create_stage_handle "s" : !hcl.StageHandle
    affine.for %oc = 0 to 6 { // out channel
      affine.for %i = 0 to 30 {
        affine.for %j = 0 to 30 {
          affine.for %rc = 0 to 3 { // in channel
            affine.for %ry = 0 to 3 {
              affine.for %rx = 0 to 3 {
                %a = affine.load %Input[%rc, %i+%ry, %j+%rx] : memref<3x32x32xf32>
                %k = affine.load %Kernel[%oc, %rc, %ry, %rx] : memref<6x3x3x3xf32>
                %b = affine.load %Output[%oc, %i, %j] : memref<6x30x30xf32>
                %mul = arith.mulf %a, %k : f32
                %sum = arith.addf %b, %mul : f32
                affine.store %sum, %Output[%oc, %i, %j] : memref<6x30x30xf32>
              } { loop_name = "rx", reduction = 1 }
            } { loop_name = "ry", reduction = 1 }
          } { loop_name = "rc", reduction = 1 }
        } { loop_name = "j" }
      } { loop_name = "i" }
    } {loop_name = "oc", stage_name = "s" }
    return
  }
}
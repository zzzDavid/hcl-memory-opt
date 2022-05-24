#set = affine_set<(d0) : (d0 - 2 >= 0)>
module {
  func @top(%arg0: memref<32x32xi32>) -> memref<30x30xi32> attributes {extra_itypes = "s", extra_otypes = "s", llvm.emit_c_interface, top} {
    %0 = memref.alloc() {name = "B"} : memref<30x30xi32>
    %1 = memref.alloc() : memref<3x32xi32>
    %2 = memref.alloc() : memref<3x3xi32>
    affine.for %arg1 = 0 to 32 {
      affine.for %arg2 = 0 to 32 {
        %3 = affine.load %1[1, %arg2] : memref<3x32xi32>
        affine.store %3, %1[0, %arg2] : memref<3x32xi32>
        %4 = affine.load %1[2, %arg2] : memref<3x32xi32>
        affine.store %4, %1[1, %arg2] : memref<3x32xi32>
        %5 = affine.load %arg0[%arg1, %arg2] : memref<32x32xi32>
        affine.store %5, %1[2, %arg2] : memref<3x32xi32>
        affine.if #set(%arg1) {
          affine.for %arg3 = 0 to 3 {
            %6 = affine.load %2[%arg3, 1] : memref<3x3xi32>
            affine.store %6, %2[%arg3, 0] : memref<3x3xi32>
            %7 = affine.load %2[%arg3, 2] : memref<3x3xi32>
            affine.store %7, %2[%arg3, 1] : memref<3x3xi32>
            %8 = affine.load %1[%arg3, %arg2] : memref<3x32xi32>
            affine.store %8, %2[%arg3, 2] : memref<3x3xi32>
          } {spatial}
          affine.if #set(%arg2) {
            %6 = affine.load %2[1, 0] : memref<3x3xi32>
            %7 = affine.load %2[0, 1] : memref<3x3xi32>
            %8 = arith.addi %6, %7 : i32
            %9 = affine.load %2[1, 1] : memref<3x3xi32>
            %10 = arith.addi %8, %9 : i32
            %11 = affine.load %2[2, 1] : memref<3x3xi32>
            %12 = arith.addi %10, %11 : i32
            %13 = affine.load %2[1, 2] : memref<3x3xi32>
            %14 = arith.addi %12, %13 : i32
            affine.store %14, %0[%arg1 - 2, %arg2 - 2] : memref<30x30xi32>
          }
        }
      } {loop_name = "j"}
    } {loop_name = "i", stage_name = "B"}
    return %0 : memref<30x30xi32>
  }
}

//===------------------------------------------------------------*- C++ -*-===//
//
// Automatically generated file for High-level Synthesis (HLS).
//
//===----------------------------------------------------------------------===//
#include <algorithm>
#include <ap_axi_sdata.h>
#include <ap_fixed.h>
#include <ap_int.h>
#include <hls_math.h>
#include <hls_stream.h>
#include <math.h>
#include <stdint.h>
using namespace std;
void kernel(
  float v0[1024][512],
  float v1[512][1024],
  float v2[1024][1024]
) {	// L2
  l_s_i: for (int i = 0; i < 1024; i++) {	// L3
    l_j: for (int j = 0; j < 1024; j++) {	// L4
      l_k: for (int k = 0; k < 512; k++) {	// L5
        float v6 = v0[i][k];	// L6
        float v7 = v1[k][j];	// L7
        float v8 = v2[i][j];	// L8
        float v9 = v6 * v7;	// L9
        float v10 = v9 + v8;	// L10
        v2[i][j] = v10;	// L11
      }
    }
  }
}



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
    float v4[1024];	// L4
    l_j_init: for (int j_init = 0; j_init < 1024; j_init++) {	// L6
    #pragma HLS pipeline II=1
      v4[j_init] = 0.000000;	// L7
    }
    l_k: for (int k = 0; k < 512; k++) {	// L9
      l_j: for (int j = 0; j < 1024; j++) {	// L10
      #pragma HLS pipeline II=1
        float v8 = v0[i][k];	// L11
        float v9 = v1[k][j];	// L12
        float v10 = v4[j];	// L13
        float v11 = v8 * v9;	// L14
        float v12 = v11 + v10;	// L15
        v4[j] = v12;	// L16
      }
    }
    l_j_back: for (int j_back = 0; j_back < 1024; j_back++) {	// L19
    #pragma HLS pipeline II=1
      float v14 = v4[j_back];	// L20
      v2[i][j_back] = v14;	// L21
    }
  }
}


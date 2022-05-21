
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
  float v0[3][32][32],
  float v1[6][3][3][3],
  float v2[6][30][30]
) {	// L2
  l_s_oc: for (int oc = 0; oc < 6; oc++) {	// L3
    l_i: for (int i = 0; i < 30; i++) {	// L4
      float v5[30];	// L5
      l_j_init: for (int j_init = 0; j_init < 30; j_init++) {	// L7
      #pragma HLS pipeline II=1
        v5[j_init] = 0.000000;	// L8
      }
      l_rc: for (int rc = 0; rc < 3; rc++) {	// L10
        l_ry: for (int ry = 0; ry < 3; ry++) {	// L11
          l_rx: for (int rx = 0; rx < 3; rx++) {	// L12
            l_j: for (int j = 0; j < 30; j++) {	// L13
            #pragma HLS pipeline II=1
              float v11 = v0[rc][(i + ry)][(j + rx)];	// L14
              float v12 = v1[oc][rc][ry][rx];	// L15
              float v13 = v5[j];	// L16
              float v14 = v11 * v12;	// L17
              float v15 = v13 + v14;	// L18
              v5[j] = v15;	// L19
            }
          }
        }
      }
      l_j_back: for (int j_back = 0; j_back < 30; j_back++) {	// L24
      #pragma HLS pipeline II=1
        float v17 = v5[j_back];	// L25
        v2[oc][i][j_back] = v17;	// L26
      }
    }
  }
}


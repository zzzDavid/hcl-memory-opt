
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
      l_j: for (int j = 0; j < 30; j++) {	// L5
        l_rc: for (int rc = 0; rc < 3; rc++) {	// L6
          l_ry: for (int ry = 0; ry < 3; ry++) {	// L7
            l_rx: for (int rx = 0; rx < 3; rx++) {	// L8
              float v9 = v0[rc][(i + ry)][(j + rx)];	// L9
              float v10 = v1[oc][rc][ry][rx];	// L10
              float v11 = v2[oc][i][j];	// L11
              float v12 = v9 * v10;	// L12
              float v13 = v11 + v12;	// L13
              v2[oc][i][j] = v13;	// L14
            }
          }
        }
      }
    }
  }
}


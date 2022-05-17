
#include <sys/ipc.h>
#include <sys/shm.h>

// standard C/C++ headers
#include <getopt.h>
#include <sys/time.h>
#include <time.h>
#include <cassert>
#include <cstdio>
#include <cstdlib>
#include <string>

// vivado hls headers
#include <ap_int.h>
#include <ap_fixed.h>
#include <hls_stream.h>
#include "kernel.h"

#include <ap_int.h>
#include <ap_fixed.h>
#include <ap_axi_sdata.h>
#include <hls_stream.h>
#include <hls_math.h>
#include <math.h>
#include <stdint.h>

int main(int argc, char ** argv) {
  std::cout << " Initialize input...";
  float v0[1024][512],
  float v1[512][1024],
  float v2[1024][1024]
  for (size_t i = 0; i < 1024; i++) {
    for (size_t j = 0; j < 512; j++) {
      v0[i][j] = 2.0;
    }
  }
  for (size_t i = 0; i < 512; i++) {
    for (size_t j = 0; j < 1024; j++) {
      v1[i][j] = 2.0;
    }
  }
  for (size_t i = 0; i < 1024; i++) {
    for (size_t j = 0; j < 1024; j++) {
      v2[i][j] = 0.0;
    }
  }

  std::cout << " Done!" << std::endl;
  std::cout << "Calling kernel function....";
  kernel(v0, v1, v2);
  std::cout << " Done!" << std::endl;
}

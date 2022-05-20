# Memory Optimization and Profiling for MLIR-based HeteroCL 

## `buffer_at` Experiments
- no suffix: vanilla (baseline)
- `buffer`: only buffering with `buffer_at`
- `acc`: with interleaving accumulation, i.e., `reorder` and `buffer_at`
- `hls` is a template hls project folder

### To emit VHLS kernel code
```
hcl-opt --opt *.mlir | hcl-translate --emit-vivado-hls
```

### `buffer_at` FPGA (Vivado HLS) results
| Experiment | Latency | DSP | BRAM | LUT | FF |
| --- | --- | --- | --- | --- | --- | 
| gemm | 25.778 sec | 5 | 0 | 525 | 576 |
| gemm_buffer | 23.639 sec | 5 2 | 677 | 617 |
| gemm_acc | 2.156 sec | 5 | 2 | 783 | 745 |
| conv | 6.978 ms | 5 | 0 | 739 | 619 |
| conv_acc | 6.538 ms | 5 | 0 | 919 | 747 |

- Part: `xcu280-fsvh2892-2L-e`
- Clock: `create_clock -period 4`
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
<div align="center">

# 🖥️ RISC-V Pipelined Processor

### A 5-stage pipelined RV32I processor built from scratch in Verilog — complete with hazard detection and data forwarding.

<img src="https://img.shields.io/badge/Verilog-black?style=for-the-badge&logo=v&logoColor=white" alt="Verilog" />
<img src="https://img.shields.io/badge/ISA-RV32I-0e75b6?style=for-the-badge" alt="RV32I" />
<img src="https://img.shields.io/badge/Pipeline-5--Stage-36BCF7?style=for-the-badge" alt="5-Stage Pipeline" />

</div>

---

## 📖 Overview

This is a ground-up implementation of a **5-stage pipelined RISC-V (RV32I) processor**, built module-by-module in Verilog. It doesn't stop at the textbook single-cycle design — it pipelines instruction execution across five stages and handles the two problems that come with that: **hazards** and **data dependencies**, solved here with a dedicated hazard detection unit and a forwarding unit.

---

## 🏗️ Pipeline Architecture

The datapath is split into the five classic RISC pipeline stages, connected by pipeline registers that latch state every clock cycle:

```
   IF  →  ID  →  EX  →  MEM  →  WB
   │      │      │       │      │
 Fetch  Decode Execute Memory Write-back
```

| Stage | Pipeline Register | Purpose |
|:---|:---|:---|
| IF → ID | `IF_ID_stall.v` | Latches PC and fetched instruction; supports stalling |
| ID → EX | `ID_EX.v` | Latches decoded operands, control signals, and immediate |
| EX → MEM | `EX_MEM.v` | Latches ALU result and memory-access signals |
| MEM → WB | `MEM_WB.v` | Latches data to be written back to the register file |

---

## ⚡ Hazard Handling

Pipelining introduces two classic problems — this design solves both explicitly rather than ignoring them:

| Unit | File | Handles |
|:---|:---|:---|
| **Hazard Detection Unit** | `hazard_detection_unit.v` | Detects load-use hazards and stalls the pipeline (bubble insertion) when a value isn't ready yet |
| **Forwarding Unit** | `forwarding_unit.v` | Forwards ALU/memory results directly between stages, skipping unnecessary stalls when data can be bypassed |

---

## 🧩 Module Breakdown

| Module | Role |
|:---|:---|
| `program_counter.v` | Tracks and updates the current instruction address |
| `ins_mem_32.v` | Instruction memory (32-bit, byte-addressed) |
| `riscv_control.v` | Main control unit — decodes opcode into control signals |
| `alu_control.v` | Derives the exact ALU operation from `funct3`/`funct7` |
| `alu.v` | Arithmetic/logic unit — AND, OR, ADD, SUB, SLT, XOR, NOR, shifts |
| `imm_gen.v` | Sign-extends immediates for I/S/B/U/J instruction formats |
| `register_file.v` | 32×32-bit register file with dual read ports |
| `data_memory.v` | Data memory for loads and stores |
| `branch_target.v` / `adder_32bit.v` | Computes branch/jump target addresses |
| `mux_2to1.v` | Generic 2-to-1 multiplexer used throughout the datapath |
| `pipeline_datapath.v` | Top-level module wiring every stage together |
| `testbench.v` | Simulation harness with signal probes into internal pipeline state |

---

## 🔤 Supported Instructions (RV32I subset)

Based on the control and immediate-generation logic, the processor supports:

- **R-type:** `add`, `sub`, `and`, `or`, `xor`, `sll`, `srl`, `sra`, `slt`
- **I-type:** `addi`, `lw`, `jalr`
- **S-type:** `sw`
- **B-type:** `beq`, `bne`
- **U-type:** `lui`, `auipc`
- **J-type:** `jal`

---

## ▶️ Simulation

The included `testbench.v` instantiates the full pipeline, drives the clock/reset, and exposes internal signals (stall, forwarding selects, ALU inputs, pipeline register contents) for waveform inspection.

**Run with Icarus Verilog:**

```bash
iverilog -o sim Modules/*.v
vvp sim
```

**View waveforms (if a VCD dump is added to the testbench):**

```bash
gtkwave dump.vcd
```

The default instruction memory (`ins_mem_32.v`) is pre-loaded with a short test program (`addi`, `add`, `sw`, ...) so the design is simulate-ready out of the box.

---

## 🧰 Tech Stack

<p align="left">
  <img src="https://img.shields.io/badge/Verilog-black?style=for-the-badge&logo=v&logoColor=white" alt="Verilog" />
  <img src="https://img.shields.io/badge/RV32I-0e75b6?style=for-the-badge" alt="RV32I ISA" />
</p>

---

## 🧑‍💻 Author

Built as a computer architecture project to implement a real pipelined CPU from the ground up — datapath, control, hazards, and forwarding included, not just simulated on paper.

<div align="center">

**Part of my [GitHub profile](https://github.com/arfa-tayyabah)**

</div>

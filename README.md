# video_display_processor
Final Year Project Performed at Shri Mata Vaishno Devi University 
Perfect! Here’s an updated **README.md** with a concise “Quick Start” section including example instructions and waveform guidance:

````markdown
# Minimalist Instruction Set Processor (Add-Jump CPU)

## Overview

This project implements a **minimalist instruction set processor** capable of executing **add** and **jump** instructions. It is designed for educational and verification purposes, showcasing the fundamentals of processor design, instruction decoding, and execution in Verilog.

---

## Features

- 4 general-purpose registers (`R0`–`R3`), each 16 bits.
- 16 instruction memory locations (4-bit PC).
- Supports `ADD` and `JMP` instructions.
- Debug output (`w2_dbg`) for monitoring assembler-generated instructions.
- Push-button-style control signals:
  - `prog`: load instructions
  - `advance`: advance PC

---

## Quick Start

### Step 1: Signals and Inputs

| Signal   | Description                          |
|----------|--------------------------------------|
| `value`  | 16-bit immediate value                |
| `dest`   | 2-bit destination register index      |
| `src`    | 2-bit source register index           |
| `add`    | 1 → Add instruction                   |
| `jump`   | 1 → Jump instruction                  |
| `prog`   | 1 → Program memory load mode          |
| `advance`| 1 → Increment program counter         |

---

### Step 2: Example Instruction Sequence

| Step | Instruction | `value` | `src` | `dest` | `add` | `jump` |
|------|------------|---------|-------|--------|-------|--------|
| 1    | ADD R0,R1  | 10      | 1     | 0      | 1     | 0      |
| 2    | ADD R2,R0  | 20      | 0     | 2      | 1     | 0      |
| 3    | JMP addr 5 | 5       | -     | -      | 0     | 1      |

- Load instructions using `prog = 1`.
- After loading, set `prog = 0` and toggle `advance` to execute instructions sequentially.

---

### Step 3: Waveform Monitoring

- Observe these signals in your simulator:
  - `pc` → Program counter
  - `o_r0`–`o_r3` → Register outputs
  - `o_b` → Execute output
  - `w2_dbg` → Current instruction word
- Use `w2_dbg` to verify correct instruction encoding.

---

### Step 4: Simulation Tips

- Make sure **assembler outputs** (`inst` and `store_clk`) are connected to **wires in the top module**.
- `EEPROM` reads occur asynchronously; writes occur on `store_clk` rising edge.
- PC increments when `advance = 1` and jumps if `jump` instruction is active.
- Reset registers manually if needed for clean test runs.

---

## Running the Testbench

1. Compile all Verilog files:
   ```bash
   vlog *.v
````

2. Load the testbench:

   ```bash
   vsim top_tb
   ```
3. Run simulation for required cycles:

   ```bash
   run 200ns
   ```
4. Inspect waveforms for `pc`, `o_r0`–`o_r3`, `o_b`, and `w2_dbg`.

---

## Author

**Akshit Kapoor** – B.Tech ECE
2025

---

## License

Released for **educational and research purposes**. Modify and reuse with attribution.



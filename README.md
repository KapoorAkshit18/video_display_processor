## Phase-1 Core: ADD–JUMP Minimalistic Processor

Phase-1 of this project is built around a **minimalistic custom processor architecture** based on the **ADD–JUMP execution model**.

Instead of using a complex multi-instruction ISA, this processor uses a **very small instruction set** designed to prove core concepts with maximum simplicity.

---

### 🔹 What is an ADD–JUMP Processor?

An **ADD–JUMP processor** is a Von- Neumann based minimalist CPU model where computation is performed using only two fundamental operations:

- **ADD** → Performs arithmetic addition between memory/register values  
- **JUMP** → Changes the program flow by modifying the program counter  

Despite its simplicity, this model is **computationally complete**, meaning it can implement any algorithm when programmed correctly.

This makes it ideal for:

- Hardware bring-up  
- Architecture exploration  
- Teaching CPU fundamentals  
- Proving video pipeline timing without ISA complexity  

---

### 🔹 Why Use This Architecture in Phase-1?

The goal of Phase-1 is **system bring-up**, not performance.

Using an ADD–JUMP processor allows:

- Very low hardware complexity  
- Predictable timing behavior  
- Small silicon / FPGA footprint  
- Easy debug during early stages  
- Fast verification of memory and bus interfaces  

This makes it perfect for validating the **display processor startup sequence**.

---

### 🔹 How It Works in This Project

In this phase, the processor is responsible for:

- Initializing display memory regions  
- Generating simple test patterns (solid color, checkerboard, basic gradients)  
- Controlling timing loops for frame refresh  
- Executing reset → initialization → display-ready sequence  

The processor executes only simple routines composed of **ADD** and **JUMP instructions**, proving the system can move from reset to visible video output.

---

### 🔹 Instruction Model

This processor uses a tiny conceptual instruction set:

| Instruction | Function |
|------------|----------|
| `ADD A, B → A` | Adds value of B into A |
| `JUMP addr` | Sets program counter to `addr` |

All higher-level behavior such as loops, counters, and memory stepping are built from these primitives.

---

### 🔹 Role in the Full Project

This processor exists only in **Phase-1 (Jump-Up Phase)** and serves as:

✅ A bootstrap engine  
✅ Timing validator  
✅ Memory interface tester  

In later phases, this minimal processor may be:

- Extended
- Replaced
- Or wrapped by more advanced execution units

---

### 🔹 Design Philosophy

This phase follows the philosophy:

> “Make it work before making it fast.”

The ADD–JUMP processor focuses on:

- Correctness first  
- Minimal silicon footprint  
- Simple control flow  
- Maximum reliability during bring-up  

---

### 🔹 Summary

The **ADD–JUMP minimalistic processor** is the heart of Phase-1 and provides:

- A tiny but powerful execution model  
- Reliable bring-up of the display system  
- A clean foundation for future graphical and architectural expansion  

It proves that the system can execute instructions and drive a display before introducing complexity.

---

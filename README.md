# 🧠 IITK-Mini-MIPS Processor

This repository contains the implementation of **IITK-Mini-MIPS**, a custom single-cycle 32-bit processor inspired by the MIPS-32 architecture. The processor executes one instruction per clock cycle and supports a subset of R-, I-, and J-type instructions, along with floating-point register transfer instructions.

---

## 📐 Architecture Overview

- **Word Size**: 32-bit
- **Instruction Format**: 32-bit fixed-width
- **Register File**:
  - 32 General-Purpose Registers (GPRs)
  - 32 Floating-Point Registers (FPRs)
  - Access between GPRs and FPRs only via `mfc1` and `mtc1`
- **Memories**:
  - Separate **Instruction Memory** and **Data Memory**
  - Non-overlapping and independently addressable
- **Execution Model**: Single-cycle (all stages completed in 1 clock)

---

## ✅ Supported Instructions

The instruction set includes:
- **R-Type**: `add`, `sub`, `and`, `or`, `slt`, etc.
- **I-Type**: `lw`, `sw`, `beq`, `bne`, `addi`, `andi`, etc.
- **J-Type**: `j`
- **Special**: `jr`, `lui`, `mfc1`, `mtc1`


# Verilog CPU Design

**CSE 224 — Academic digital design project | Yeditepe University**

A staged Verilog HDL project exploring arithmetic logic units, a register file, a simplified CPU datapath, and a top-level interface for displaying 16-bit output on a multiplexed seven-segment display.

## Modules

| Stage | Source | Description |
| --- | --- | --- |
| 1 | [8-bit ALU](part1/alu_8bit.v) | Addition, subtraction, AND, OR, NOT, and XOR |
| 2 | [8-bit ALU with flags](part2/alu_8bit.v) | Carry, zero, and sign outputs, plus an overflow output placeholder |
| 3 | [16 × 16-bit register file](part3/reg_file.v) | Clocked write and combinational indexed read |
| 4 | [16-bit half CPU](part4/half_cpu.v) | Small instruction memory, program counter, register array, and ALU |
| 5 | [CPU top-level](part5/cpu_top.v) | Clock divider, synchronized reset input, CPU integration, and hexadecimal seven-segment multiplexing |

## Design details

The CPU example uses a 4-bit program counter to address a 16-word instruction array. Instruction bits are split into an operation code and register indices, and the arithmetic unit supports add, subtract, shifts, and bitwise operations.

The top-level design combines the CPU with four-digit seven-segment display scanning.

## Repository layout

```text
part1/alu_8bit.v
part2/alu_8bit.v
part3/reg_file.v
part4/half_cpu.v
part5/cpu_top.v
```

Each directory represents a separate project milestone. **The `alu_8bit` module name appears independently in Parts 1 and 2**, so these two variants should be compiled separately.

## Simulation

With Icarus Verilog installed, an example syntax/elaboration command for a self-contained module is:

```bash
iverilog -g2012 -s alu_8bit -o /tmp/alu.out part1/alu_8bit.v
```

For the top-level design:

```bash
iverilog -g2012 -s cpu_top -o /tmp/cpu.out part5/cpu_top.v
```

These commands are provided as a starting point and have **not been verified by running a simulator**. No testbench or initialized instruction-memory image is currently included; the CPU should not be described as having demonstrated execution of a real instruction program.

## Known limitations

- In Part 2, `overflow` is declared but held at zero rather than calculated.
- The CPU instruction-memory and register arrays are declared without an initialization mechanism in the supplied RTL.
- The Part 5 clock-divider register has no explicit initialization/reset.
- The original assignment archive also included physical-design reports and layout artifacts. This repository currently contains the **Verilog RTL source files**, not those generated reports or GDS files.

## Authorship

Developed by **Serra Pehlivanküçük** as an academic digital design project.

## Status

Original HDL sources imported from the submitted project archive. Simulation and hardware validation have not been independently performed for this public repository.

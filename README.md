# FPGA-In-place-Sorting-Using-Controller-FSM-and-Datapath
This project focuses on the concept of in-place sorting of array elements in RAM. The project uses FSM logic to generate signals for the controller that guide the memory operations in the Datapath. At the end, we receive the  sorted array in memory with the smallest number as the first element and the largest number as the last element.

🔹 Approach

Instead of writing a monolithic Verilog block, we applied a processor-style design methodology:

The datapath handles storage elements (registers, counters, memory) and operations (comparisons, data transfers).

The controller FSM generates control signals based on the current state and status flags.

The top module integrates both, connects to memory, and exposes a simple interface.

This separation makes the design modular, easier to debug, and closer to how actual hardware sorting accelerators or processors are built.

🔹 Datapath Design

The datapath (datapath.v) contains:

Registers A and B → Hold two array elements for comparison.

Counters i and j → Implement the nested loops of bubble sort (i is outer loop, j is inner loop).

Comparator → Produces the flag AgtB when A > B.

Zero-detectors → Flags zi and zj to indicate when the counters reach their loop limits.

Multiplexers → Select between i and j for addressing memory, and between A and B for writing back.

Memory Interface → Connects to the top module’s RAM.

The datapath is purely combinational + sequential logic and does not “know” about bubble sort itself; it only provides the building blocks.

🔹 Controller FSM Design

The controller (controller.v) is a finite state machine that drives the datapath.

It generates control signals like:

EA, EB → Load registers A and B.

WR → Write data back into memory.

Li, Lj → Initialize counters i and j.

Ei, Ej → Enable counter increments.

Csel, Bout → Control multiplexers for address and data paths.

The FSM sequences through the bubble sort steps:

Load A (array[i])

Load B (array[j])

Compare A and B

Swap if needed (two memory writes)

Update j counter (move inner loop)

Update i counter (move outer loop)

Repeat until sorted

Done state

🔹 Integration (sorter_top.v)

The sorter_top module integrates:

The datapath

The controller FSM

A small on-chip memory (8-element array initialized with unsorted values in the testbench)

This module connects everything so that starting the controller (s=1) triggers the sort. When sorting finishes, a done flag is raised.

🔹 Testbench

The testbench (tb_sorter.v):

Generates the clock and reset.

Instantiates the top sorter module.

Waits until the done signal is asserted.

Prints the final sorted memory contents to the console.

It also generates the waveform showing how the swap and sorting is happeing at the same time

🔹 Simulation

Run the testbench in ModelSim (or any Verilog simulator).

Inspect the waveforms for signals like A, B, i, j, current_state, and memory updates.

The memory contents evolve step-by-step until the array is sorted in ascending order.

🔹 Key Takeaways

Demonstrates hardware/software co-design principles by mimicking a CPU-like separation of datapath and control.

Shows how a high-level algorithm (bubble sort) can be mapped to FSM + datapath architecture.

Provides a reusable framework: the datapath and FSM could be adapted to other algorithms beyond bubble sort.

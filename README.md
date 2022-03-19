# COL216 Computer Architecture
## Lab Assignment 2, Stage 6: Support for all DT instructions features

The features to be supported include byte and half word transfers (signed and unsigned), auto increment/decrement with option of pre/post indexing. Word, Half-word and Byte transfers.
We need to introduce a combination circuit between the processor and memory which does the required transformation of words into half-words / bytes and vice versa. Let us call it PMconnect.
Let Adr[31-0] denote the address for memory. This is a byte address. Out of the 32 bits of address, 30 bits Adr[31-2] specify the address of a word and 2 bits Adr[1-0] specify a byte within that word or Adr[1] specifies a half-word within that word.To make it possible to write a byte or a half-word in the memory, one solution is to have 4 write enable signals for memory, one for each byte. Let these be denoted by MW[3-0]. MW[0] is for the least significant byte and MW[3] is for the most significant byte. The memory may be addressed by Adr[31-2] to select a word (for load as well as for store). For store instructions, MW controls which byte(s) get written. For load instructions, we can read an entire word and transfer selective portion to the register file.

## Implementing Auto-indexing 

Auto-indexing requires the address calculated by adding offset to the base be written back  into the base register. In case of pre-indexing, memory is accessed using the computed  address and in case of post-indexing, memory is accessed with just the base address.

The additional operation required for auto-indexing is the write back of computed address  into the base register. We need to decide in which cycle the base register is written back - whether it can be done in an existing control state or a new control state needs to be  introduced. Load instructions already have a cycle in which the data read from memory is  written into register file. The cycle for base register write back has to be a cycle different  from this cycle because only a single write port is available with register file. However, it  can be the same cycle in which memory is accessed

## Running the CPU

Simply install ghdl on your computer and run `make` to open gtWave. Replace the instructions in "data_mem.vhd" to run your own instructions.
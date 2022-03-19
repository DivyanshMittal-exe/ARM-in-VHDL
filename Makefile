all:
	ghdl -a MyTypes.vhd Processor.vhd FSM.vhd IDAB_Reg.vhd Instr.vhd Flags.vhd ALU.vhd Cond.vhd data_mem.vhd PC.vhd Register.vhd shifterbyi.vhd Rotator.vhd Shifter.vhd TB.vhd 
	ghdl -r TB --wave=wave.ghw
	gtkwave wave.ghw
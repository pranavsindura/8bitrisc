# 8 Bit RISC Processor
An attempt to build a minimal 8bit processor.
A project under the CAO course.
Made by - 
**Pranav Sindura 2018KUCP1012**
Submitted to -
**Dr. Ashok Kherodia**
## Components
The various components are - 
1.	Control Unit *(control.vhd)*
2.	Decoder *(decoder.vhd)*
3.	ALU *(alu_control.vhd)*
	1. Adder/Subtractor *(adder.vhd)* 	
		1. Full Adder *(full_adder.vhd)* 
	2. Xor *(xor_big.vhd)*
	3. And *(and_big.vhd)*
	4. Or *(or_gate.vhd)*
	5. Not *(not_big.vhd)*
	6. Left Shift *(shift_left.vhd)*
	7. Right Shift *(shift_right.vhd)*
4.	Registers *(registerbank.vhd)*
5.	Memory *(memorybank.vhd)*
6.	Program Counter *(programcounter.vhd)*

All top level components are instantiated under **test.vhd**.

## Control Unit

The control unit is essentially a 5 bit ring counter, where each bit denotes what cycle is going to be executed.
The cycles in order are -
1. Fetch
2. Decode
3. Register Read
4. ALU operation
5. Register Write

## Memory Bank
The memory bank is **2^8 x 16** bit memory.
It supports both reading and writing. At the moment only reading is utilized.
It is used to store instructions only so that execution can be automated via Program Counter.
Initial Value of all memory locations is set to NOP Instruction.

## Program Counter
This component holds the memory address of the instruction that is to be executed.
Initial Value is "0000".
It has 3 states -
1. Increment
2. Do nothing
3. Reset

## Decoder
The decoder breaks up the instruction into different parts and decides whether Destination register is to written into or not. 

## Instructions

All instructions are **16 bits** in length.
Register D is written into in all instructions except Nop.
| Opcode  | Instruction  | Implementation  | Type
|---|---|---|---|
| 0000 | Add | D = A + B | RRR
| 0001 | Subtract  | D = A - B  | RRR   
|  0010 | Xor  | D = A ^ B  |RRR
| 0011 | And | D = A & B|RRR
|0100|Or|D = A \| B |RRR
|0101|Not|D = ~A |RR
|0110|Left Shift| D = A<<1|RR
|0111|Right Shift|D = A>>1|RR
|1000|Load|D = Immediate Data|RImm
|1001|Move| D = A|RR
|1010|Nop|Do nothing|Empty     
|Rest| None | Ignored|-

### Instruction Format

**RRR Instruction**
|15|14|13|12|11|10|9|8|7|6|5|4|3|2|1|0|
|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
|Opcode|Opcode|Opcode|Opcode|RD|RD|RD|RA|RA|RA|RB|RB|RB|X|X|X|

**RR Instruction**
15|14|13|12|11|10|9|8|7|6|5|4|3|2|1|0
--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
Opcode|Opcode|Opcode|Opcode|RD|RD|RD|RA|RA|RA|X|X|X|X|X|X

**RImm Instruction**
15|14|13|12|11|10|9|8|7|6|5|4|3|2|1|0
--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
Opcode|Opcode|Opcode|Opcode|RD|RD|RD|Data|Data|Data|Data|Data|Data|Data|Data|X

**Empty Instruction**
15|14|13|12|11|10|9|8|7|6|5|4|3|2|1|0
--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
Opcode|Opcode|Opcode|Opcode|X|X|X|X|X|X|X|X|X|X|X|X


## Register Bank
There are **2^3 x 8 bit** registers. It supports both reading and writing.
The register bank can output data from 2 Registers (RA, RB) simultaneously.
Data can be written into 1 Register (RD) at a time.
The registers are numbered from 0 (000) to 7 (111)

## ALU
The ALU works on 8 bit data. It performs all the instructions on the inputs and stores them. Then, depending on the opcode the correct result is sent to the output.
ALU supports all instructions mentioned in the table above.

## Testing
Initially there is a reset bit which holds the control unit from executing anything.
To start the Control Unit the reset bit is set to 1.
After that, it will execute all instructions written in the memory.

Sample program -
| What to do | Instruction |
|--|--|
|load r0 with 26H| "1000" & "000" & x"26" & "0"|
|load r1 with 44H | "1000" & "001" & x"44" & "0"
| add r1 = r1 + r0| "0000" & "001" & "001" & "000" & "000"
| move r4 <- r1|"1001" & "100" & "001" & "000" & "000"
|move r7 <- r4|"1001" & "111" & "100" & "000" & "000"

These instructions are written to memory in order.
The Simulation wave forms and register data after each instruction is present as a screenshot in the folder.
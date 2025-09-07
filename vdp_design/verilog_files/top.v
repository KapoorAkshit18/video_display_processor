// Design and implementation of miniminalist
//instruction set processor - add-jump 

module top (
//inputs	
 
	   			input [15:0]value,
				input [1:0]dest,
				input [1:0]src,
				input add,
				input jump,
				input prog,
				input advance,
//outputs 			
				output [3:0]pc,
				output [15:0]o_b,
				output [15:0]o_r0,
				output [15:0]o_r1,
				output [15:0]o_r2,
				output [15:0]o_r3,
				output [31:0]w2_dbg
	
			);

// internal wires 

				wire w1;
				wire [31:0]w2;
				wire w3;
				wire [31:0]w4;
				wire [3:0]w5;
				wire [31:0]w6;			
				wire [15:0]w7;
				wire [1:0]w8;
				wire [1:0]w9;
				wire w10;
				wire w11;
				wire[15:0]w12;
				wire w13;         // clk to regfile
				wire w14;         // advance input port wire
				wire w15;
				wire [15:0]w18;
				wire [1:0]w17;
				wire [1:0]w16;


				assign w1 = prog;
				assign w14 = advance;
				assign w15 = w14;
				assign w13 = w14;
				
				
	// instatiations 

//Assembler Block

    assembler instance1(
				.prog(prog),
				.value(value),
				.dest(dest),
				.src(src),
				.asm_add(add),
				.asm_jump(jump),
				.inst(w2),
				.store_clk(w3));
	// assign w2 = inst;
	assign w2_dbg = w2;
	// assign w3 = store_clk;
	assign w4 = w2;    // for bypass
		
// EEPROM or Memory Block

 eeprom  instance3(
			.c(w3),
			.str(1'b1),
			.ld(1'b1),
			.d_in(w2),       // wire from asm blk o/p
			.a(w5),            // wire from counter blk o/p
			.d(w6)
			);
		

// Program Counter's Block

		counter_with_preset #(
			.bits(4)
			)
			instance2 (
			.c(w15),
			.en(1'b1),
			.dir(1'b0),
			.in(w7[3:0]),
			.ld(w10),
			.clr(1'b0),
			.out(pc)
			
			);
			
			assign w5 = pc;
			

					
// Decoder Block		
		
		decoder instance4 ( 
				.d_prog(w1),        
				.bypass(w4),        // joint wire w4 from asm blk's o/p wire
				.d_inst(w6),       // wire from decoder blk's o/p
				.d_a(w7),
				.d_rs(w8),
				.d_rd(w9),
				.d_jump(w10),
				.d_add(w11)
				);
		
		
		
		assign w17 = w8;
		assign w16 = w9;
		
		
		
// Execute Block	 
		
		execute instance5 (
				
				.exe_a(w7),
				.exe_b(w18),
				.exe_add(w11),
				.exe_result(w12)
				);

			


		regfile instance6 (
				.rs(w17),
				.rd(w16),
				.result(w12),
				.clk(w13),
				.o_b(o_b),
				.o_r0(o_r0),
				.o_r1(o_r1),
				.o_r2(o_r2),
				.o_r3(o_r3)
				);
		assign w18 = o_b;

endmodule
		
		

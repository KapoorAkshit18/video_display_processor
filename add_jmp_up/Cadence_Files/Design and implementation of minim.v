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
			.a(pc),            // wire from counter blk o/p
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
		
		


module assembler (
  input prog,
  input [15:0] value,
  input [1:0] dest,
  input [1:0] src,
  input asm_add,
  input asm_jump,
  output [31:0] inst,
  output store_clk
);
  wire [2:0] opcode;
  wire any;
  priorityencoder3 priorityencoder3_i0 (
    .in0( asm_add ),
    .in1( 1'b0 ),
    .in2( 1'b0 ),
    .in3( 1'b0 ),
    .in4( 1'b0 ),
    .in5( 1'b0 ),
    .in6( 1'b0 ),
    .in7( asm_jump ),
    .num( opcode ),
    .any( any )               // any sgn--> avoid zero confusion
  );
  assign inst[15:0] = value;
  assign inst[17:16] = dest;
  assign inst[19:18] = 2'b0;
  assign inst[21:20] = src;
  assign inst[23:22] = 2'b0;
  assign inst[26:24] = opcode;
  assign inst[31:27] = 5'b0;
  assign store_clk = (any & prog);
endmodule


// eeprom block made by Akshit
module eeprom  
    (   input c, //clock
        input str,    //write enable 
	input ld,   // read enable
        input [31:0] d_in,    //Input data to port 0.
        input [3:0] a,  //address for 
        output [31:0] d    //output data from port 0.
 
    );

//memory declaration.
reg [31:0] rom[0:15];

//writing to the RAM
always@(posedge c)
begin
    if(str)    //check enable signal and if write enable is ON
        rom[a] <= d_in;
end
// To avoid Bus Contention 
always@(posedge c)
begin
 if (str && ld)
        $display("Error: Both read and write active!");
	$stop;
end

//always reading from the ram, irrespective of clock.
assign d = ld ? rom[a] : 32'bz;    // why hi z instead of 0
 

endmodule
// decoder block made by Akshit
module decoder (
  input d_prog,
  input [31:0] bypass,
  input [31:0] d_inst,
  output [15:0] d_a,
  output [1:0] d_rs,
  output [1:0] d_rd,
  output d_jump,
  output d_add,
  output [2:0]  iw2_dbg   // <-- add this line
);
  wire [31:0] iw1;             // internal wire 1
  wire [2:0] iw2;
  mux_2x1_nbits #(
    .bits(32)
  )
  mux_2x1_nbits_i0 (
    .sel( d_prog ),
    .xin_0( d_inst ),
    .xin_1( bypass ),
    .xout( iw1 )
  );

  assign d_a = iw1[15:0];
  assign d_rd = iw1[17:16];
  assign d_rs = iw1[21:20];
  assign iw2 = iw1[26:24];
  decoder3 decoder3_i1 (
    .sel( iw2 ),
    .dout_0( d_add ),          // push button name add
    .dout_7( d_jump )
  );
endmodule








// Register File made by Akshit 

module regfile (

//inputs 

  input [1:0] rs,
  input [1:0] rd,
  input [15:0] result,
  input clk,

//outputs

  output [15:0] o_b,
  output [15:0] o_r0,
  output [15:0] o_r1,
  output [15:0] o_r2,
  output [15:0] o_r3

);

//demux signal wires i.e dx

  wire [15:0] dx0;
  wire [15:0] dx1;
  wire [15:0] dx2;
  wire [15:0] dx3;

// decoder signal wires i.e d0,d1,..

  wire d0; 
  wire d1;
  wire d2;
  wire d3;

// temporary register for clarity 

 wire [15:0] r0_temp;
 wire [15:0] r1_temp;
 wire [15:0] r2_temp;
 wire [15:0] r3_temp;

  demux_nbits #(
    .bits(16),
    .otherwise(0)
  )
  demux_bus0 (
    .sel( rd ),
    .in( result ),
    .out_0( dx0 ),
    .out_1( dx1 ),
    .out_2( dx2 ),
    .out_3( dx3 )
  );
  decoder_1x4 enabler_regs (     // it enables reg file
    .sel( rd ),
    .out_0( d0 ),
    .out_1( d1 ),
    .out_2( d2 ),
    .out_3( d3 )
  );

  // r0

  dff #(
    .bits(16)
  )
  dff_reg_bus0 (
    .d( dx0 ),
    .c( clk ),
    .en( d0 ),
    .q( r0_temp )
  );

  // r1

  dff #(
    .bits(16)
  )
  dff_reg_bus1 (
    .d( dx1 ),
    .c( clk ),
    .en( d1 ),
    .q( r1_temp )
  );

  // r2

  dff #(
    .bits(16)
  )
  dff_reg_bus2 (
    .d( dx2 ),
    .c( clk ),
    .en( d2 ),
    .q( r2_temp )
  );

  // r3

  dff #(
    .bits(16)
  )
  dff_reg_bus3 (
    .d( dx3 ),
    .c( clk ),
    .en( d3 ),
    .q( r3_temp )
  );
//mux for output register reading

  mux_4x1_nbits #(
    .bits(16)
  )
  mux_4x1_nbits_i6 (
    .s0(rs[0] ),
    .s1(rs[1]),
    .x0( r0_temp ),
    .x1( r1_temp ),
    .x2( r2_temp ),
    .x3( r3_temp ),
    .out( o_b )
  );
  assign o_r0 = r0_temp;
  assign o_r1 = r1_temp;
  assign o_r2 = r2_temp;
  assign o_r3 = r3_temp;

endmodule












module mux_2x1_nbits #(                   // 2 cross 1 mux for add or jump
    parameter bits = 2
)
(
    input [0:0] sel,		// maybe to preserve uniformity
    input [(bits - 1):0] xin_0,
    input [(bits - 1):0] xin_1,
    output reg [(bits - 1):0] xout
);
    always @ (*) begin
        case (sel)
            1'h0: xout = xin_0;
            1'h1: xout = xin_1;
            default:
                xout = 'h0;
        endcase
    end
endmodule

module priorityencoder3 (
    input in0,
    input in1,
    input in2,
    input in3,
    input in4,
    input in5,
    input in6,
    input in7,
    output reg [2:0] num,
    output any
);
    always @ (*) begin
        if (in7 == 1'b1)
            num = 3'h7;
        else if (in6 == 1'b1)
            num = 3'h6;
        else if (in5 == 1'b1)
            num = 3'h5;
        else if (in4 == 1'b1)
            num = 3'h4;
        else if (in3 == 1'b1)
            num = 3'h3;
        else if (in2 == 1'b1)
            num = 3'h2;
        else if (in1 == 1'b1)
            num = 3'h1;
        else 
            num = 3'h0;
    end

    assign any = in0 | in1 | in2 | in3 | in4 | in5 | in6 | in7;
endmodule
module adder_nbits
#(
    parameter bits = 16
)
(
    input [(bits-1):0] a,
    input [(bits-1):0] b,
    input c_i,
    output [(bits - 1):0] s,
    output c_o
);
   wire [bits:0] temp;

   assign temp = a + b + c_i;
   assign s = temp [(bits-1):0];
   assign c_o = temp[bits];
endmodule
// executer by Akshit 

module execute (                // terminals
  input [15:0] exe_a,
  input [15:0] exe_b,
  input exe_add,
  output [15:0] exe_result
);
  wire [15:0] sum;             // carries sum 
  adder_nbits #(
    .bits(16)
  )
  adder_nbits_i0 (
    .a( exe_a ),
    .b( exe_b ),
    .c_i( 1'b0 ),
    .s( sum )
  );
  mux_2x1_nbits #(
    .bits(16)
  )
  mux_2x1_nbits_i0 (
    .sel( exe_add ),
    .xin_0( exe_b ),
    .xin_1( sum ),
    .xout( exe_result )
  );
endmodule








// made by Akshit
module counter_with_preset #(             // parametrized module 
    parameter bits = 4,
    parameter maxvalue = 15
)
(
    input c,
    input en,
    input clr,
    input dir,
    input [(bits-1):0] in,
    input ld,
    output [(bits-1):0] out,
    output ovf
);

    reg [(bits-1):0] count = 'h0;        // parametrized module so leave 2'h0

    function automatic [(bits-1):0] maxval (input [(bits-1):0] maxv);
        if (maxv == 0)
            maxval = (1 << bits) - 1;
        else
            maxval = maxv;
    endfunction

    assign out = count;
    assign ovf = ((count == maxval(maxvalue) & dir == 1'b0)
                  | (count == 'b0 & dir == 1'b1))? en : 1'b0;

    always @ (posedge c) begin
        if (clr == 1'b1)
            count <= 'h0;

        else if (ld == 1'b1)
            count <= in;

        else if (en == 1'b1) begin

            if (dir == 1'b0) begin

                if (count == maxval(maxvalue))
                    count <= 'h0;

                else
                    count <= count + 1'b1;

            end

            else begin
             
		   if (count == 'h0)
                    count <= maxval(maxvalue);
                else
                    count <= count - 1;

            end
        end
    end
endmodule



// made by Akshit 

module mux_4x1_nbits #(
						parameter bits = 16
				)
			(
			input [bits - 1:0]x0,x1,x2,x3,
			input s0,s1,
			output [bits - 1:0]out
			);
	
	wire [bits-1:0]z1,z2;    // internal wires
	mux_2x1_nbits #(
				.bits(16))
	instance01 (
				.sel(s0),
				.xin_0(x0),
				.xin_1(x1),
				.xout(z1)
	
				);
				
	mux_2x1_nbits #(
				.bits(16))
	instance02 (
				.sel(s0),
				.xin_0(x2),
				.xin_1(x3),
				.xout(z2)
	
				);
	mux_2x1_nbits #(
				.bits(16))
	instance03 (
				.sel(s1),
				.xin_0(z1),
				.xin_1(z2),
				.xout(out)
	
				)	;
endmodule				
// made by Akshit

module demux_nbits
#(
    parameter bits = 2,
    parameter otherwise = 0 
)
(
    output [(bits-1):0] out_0,
    output [(bits-1):0] out_1,
    output [(bits-1):0] out_2,
    output [(bits-1):0] out_3,
    input [1:0] sel,
    input [(bits-1):0] in
);
    assign out_0 = (sel == 2'h0)? in : otherwise;
    assign out_1 = (sel == 2'h1)? in : otherwise;
    assign out_2 = (sel == 2'h2)? in : otherwise;
    assign out_3 = (sel == 2'h3)? in : otherwise;
endmodule


// made by Akshit

module dff #(
    parameter bits = 1
)
(
    input c,
    input en,
    input [(bits - 1):0]d,
    output [(bits - 1):0]q
);

    reg [(bits - 1):0] state = 'h0;   // for defining prev state
    assign q = state;
    always @ (posedge c) begin
        if (en)
            state <= d;
   end
endmodule
// made by digital tool

module decoder_1x4 (
    output out_0,
    output out_1,
    output out_2,
    output out_3,
    input [1:0] sel
);
    assign out_0 = (sel == 2'h0)? 1'b1 : 1'b0;
    assign out_1 = (sel == 2'h1)? 1'b1 : 1'b0;
    assign out_2 = (sel == 2'h2)? 1'b1 : 1'b0;
    assign out_3 = (sel == 2'h3)? 1'b1 : 1'b0;
endmodule
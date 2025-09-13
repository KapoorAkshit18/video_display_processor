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

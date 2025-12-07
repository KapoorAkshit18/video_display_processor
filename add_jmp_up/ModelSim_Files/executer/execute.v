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








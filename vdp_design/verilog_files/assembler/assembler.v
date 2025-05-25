module assembler (
  input mode,
  input [15:0] value,
  input [1:0] dest,
  input [1:0] src,
  input add,
  input jump,
  output [31:0] inst,
  output store_clk
);
  wire [2:0] s0;
  wire s1;
  priorityencoder3 priorityencoder3_i0 (
    .in0( add ),
    .in1( 1'b0 ),
    .in2( 1'b0 ),
    .in3( 1'b0 ),
    .in4( 1'b0 ),
    .in5( 1'b0 ),
    .in6( 1'b0 ),
    .in7( jump ),
    .num( s0 ),
    .any( s1 )
  );
  assign inst[15:0] = value;
  assign inst[17:16] = dest;
  assign inst[19:18] = 2'b0;
  assign inst[21:20] = src;
  assign inst[23:22] = 2'b0;
  assign inst[26:24] = s0;
  assign inst[31:27] = 5'b0;
  assign store_clk = (s1 & mode);
endmodule

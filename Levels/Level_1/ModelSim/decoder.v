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
  assign iw2_dbg = iw2;   // expose opcode for debug
  decoder3 decoder3_i1 (
    .sel( iw2 ),
    .dout_0( d_add ),          // push button name add
    .dout_7( d_jump )
  );
endmodule









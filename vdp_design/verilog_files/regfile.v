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












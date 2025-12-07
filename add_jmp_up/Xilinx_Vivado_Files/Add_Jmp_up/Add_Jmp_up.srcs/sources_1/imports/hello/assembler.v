module assembler (
  input        prog,
  input [15:0] value,
  input [1:0]  dest,
  input [1:0]  src,
  input        asm_add,
  input        asm_jump,
  output [31:0] inst,
  output        store_clk
);

  wire [2:0] opcode;
  wire any;

  // Priority encoder maps inputs -> opcode
  priorityencoder3 priorityencoder3_i0 (
    .in0(asm_add),   // ADD instruction
    .in1(1'b0),      // reserved for future
    .in2(1'b0),      // reserved
    .in3(1'b0),      // reserved
    .in4(1'b0),      // reserved
    .in5(1'b0),      // reserved
    .in6(1'b0),      // reserved
    .in7(asm_jump),  // JUMP instruction
    .num(opcode),
    .any(any)
  );

  // Build instruction word
  assign inst[15:0]  = value;
  assign inst[17:16] = dest;
  assign inst[19:18] = 2'b0;
  assign inst[21:20] = src;
  assign inst[23:22] = 2'b0;
  assign inst[26:24] = opcode;
  assign inst[31:27] = 5'b0;

  // Store clock only fires if prog=1 and any instruction active
  assign store_clk = (any & prog);

endmodule

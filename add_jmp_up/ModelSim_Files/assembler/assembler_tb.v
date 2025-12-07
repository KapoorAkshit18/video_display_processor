`timescale 1ns / 1ps

module assembler_tb;

  // Inputs
  reg prog;
  reg [15:0] value;
  reg [1:0] dest;
  reg [1:0] src;
  reg asm_add;
  reg asm_jump;

  // Outputs
  wire [31:0] inst;
  wire store_clk;

  // Instantiate the Unit Under Test (UUT)
  assembler uut (
    .prog(prog),
    .value(value),
    .dest(dest),
    .src(src),
    .asm_add(asm_add),
    .asm_jump(asm_jump),
    .inst(inst),
    .store_clk(store_clk)
  );

  initial begin
    $display("Time\tprog\tasm_add\tasm_jump\tinst\t\t\tstore_clk");
    $monitor("%0t\t%b\t%b\t%b\t%h\t%b", $time, prog, asm_add, asm_jump, inst, store_clk);

    // Initialize all inputs
    prog = 0;
    asm_add = 0;
    asm_jump = 0;
    value = 16'hABCD;
    dest = 2'b10;
    src  = 2'b01;

    #10;

    // Case 1: Add instruction, mode = 1
    prog = 1;
    asm_add = 1;
    asm_jump = 0;
    #10;

    // Case 2: Jump instruction, mode = 1
    asm_add = 0;
    asm_jump = 1;
    #10;

    // Case 3: Both add and jump low (no operation)
    asm_add = 0;
    asm_jump = 0;
    #10;

    // Case 4: mode = 0, add = 1 ? no store_clk
    prog = 0;
    asm_add = 1;
    #10;

    $finish;
  end

endmodule

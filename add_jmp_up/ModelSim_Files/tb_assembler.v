`timescale 1ns / 1ps

module tb_assembler;

  // Inputs
  reg mode;
  reg [15:0] value;
  reg [1:0] dest;
  reg [1:0] src;
  reg add;
  reg jump;

  // Outputs
  wire [31:0] inst;
  wire store_clk;

  // Instantiate the Unit Under Test (UUT)
  assembler uut (
    .mode(mode),
    .value(value),
    .dest(dest),
    .src(src),
    .add(add),
    .jump(jump),
    .inst(inst),
    .store_clk(store_clk)
  );

  initial begin
    $display("Time\tmode\tadd\tjump\tinst\t\t\tstore_clk");
    $monitor("%0t\t%b\t%b\t%b\t%h\t%b", $time, mode, add, jump, inst, store_clk);

    // Initialize all inputs
    mode = 0;
    add = 0;
    jump = 0;
    value = 16'hABCD;
    dest = 2'b10;
    src  = 2'b01;

    #10;

    // Case 1: Add instruction, mode = 1
    mode = 1;
    add = 1;
    jump = 0;
    #10;

    // Case 2: Jump instruction, mode = 1
    add = 0;
    jump = 1;
    #10;

    // Case 3: Both add and jump low (no operation)
    add = 0;
    jump = 0;
    #10;

    // Case 4: mode = 0, add = 1 ? no store_clk
    mode = 0;
    add = 1;
    #10;

    $finish;
  end

endmodule

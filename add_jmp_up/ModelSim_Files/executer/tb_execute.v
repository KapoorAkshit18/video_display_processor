module tb_execute;

  // Inputs
  reg [15:0] exe_a;
  reg [15:0] exe_b;
  reg exe_add;

  // Output
  wire [15:0] exe_result;

  // Instantiate the Unit Under Test (UUT)
  execute uut (
    .exe_a(exe_a),
    .exe_b(exe_b),
    .exe_add(exe_add),
    .exe_result(exe_result)
  );

  initial begin
    $display("Time\texe_add\texe_a\t\texe_b\t\texe_result");
    $monitor("%0t\t%b\t%h\t%h\t%h", $time, exe_add, exe_a, exe_b, exe_result);

    // Case 1: add = 0 ? result = b
    exe_a = 16'h000A;
    exe_b = 16'h0005;
    exe_add = 0;
    #10;

    // Case 2: add = 1 ? result = a + b = 0x000A + 0x0005 = 0x000F
    exe_add = 1;
    #10;

    // Case 3: add = 1 ? a + b = 0xFFFF + 0x0001 = 0x0000 with carry
    exe_a = 16'hFFFF;
    exe_b = 16'h0001;
    exe_add = 1;
    #10;

    // Case 4: add = 0 ? result = b (unchanged)
    exe_add = 0;
    #10;

    $finish;
  end

endmodule

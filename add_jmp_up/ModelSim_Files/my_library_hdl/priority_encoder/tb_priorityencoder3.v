`timescale 1ns/1ps

module tb_priorityencoder3;

    // Inputs
    reg in0, in1, in2, in3, in4, in5, in6, in7;

    // Outputs
    wire [2:0] num;
    wire any;

    // Instantiate DUT (Device Under Test)
    priorityencoder3 uut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .num(num),
        .any(any)
    );

    // Stimulus
    initial begin
        $display("=== Priority Encoder Testbench Start ===");
        $monitor("Time=%0t | Inputs = %b%b%b%b%b%b%b%b | any=%b | num=%b",
                  $time, in7,in6,in5,in4,in3,in2,in1,in0, any, num);

        // Case 0: no input high
        {in7,in6,in5,in4,in3,in2,in1,in0} = 8'b00000000; #10;

        // Case 1: only in0 high
        {in7,in6,in5,in4,in3,in2,in1,in0} = 8'b00000001; #10;

        // Case 2: in2 high
        {in7,in6,in5,in4,in3,in2,in1,in0} = 8'b00000100; #10;

        // Case 3: in4 and in1 high ? priority to in4
        {in7,in6,in5,in4,in3,in2,in1,in0} = 8'b00010010; #10;

        // Case 4: in7 and lower bits high ? priority to in7
        {in7,in6,in5,in4,in3,in2,in1,in0} = 8'b11111111; #10;

        $display("=== Testbench End ===");
        $finish;
    end

endmodule


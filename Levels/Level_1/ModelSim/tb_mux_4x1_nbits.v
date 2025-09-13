`timescale 1ns/1ps       // 1ns time delay and 1 ps smallest resolution

module tb_mux_4x1_nbits;

    // Inputs
    reg [15:0] x0, x1, x2, x3;
    reg s0, s1;

    // Output
    wire [15:0] out;

    // DUT (Device Under Test)
    mux_4x1_nbits uut (
        .x0(x0), 
        .x1(x1), 
        .x2(x2), 
        .x3(x3), 
        .s0(s0), 
        .s1(s1), 
        .out(out)
    );

    initial begin
        // Initialize inputs
        x0 = 16'hAAAA;  // 1010...
        x1 = 16'hBBBB;  // 1011...
        x2 = 16'hCCCC;  // 1100...
        x3 = 16'hDDDD;  // 1101...

        // Apply test cases
        $display("s1 s0 | out");
        $display("-------------");

        s1=0; s0=0; #10; $display("%b  %b | %h", s1, s0, out);
        s1=0; s0=1; #10; $display("%b  %b | %h", s1, s0, out);
        s1=1; s0=0; #10; $display("%b  %b | %h", s1, s0, out);
        s1=1; s0=1; #10; $display("%b  %b | %h", s1, s0, out);

        $finish;
    end

endmodule


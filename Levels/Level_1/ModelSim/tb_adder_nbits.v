`timescale 1ns/1ps

module tb_adder_nbits;

    // Parameter override for testing
    parameter bits = 16;

    // Inputs
    reg [(bits-1):0] a;
    reg [(bits-1):0] b;
    reg c_i;

    // Outputs
    wire [(bits-1):0] s;
    wire c_o;

    // Instantiate DUT (Device Under Test)
    adder_nbits #(.bits(bits)) uut (
        .a(a),
        .b(b),
        .c_i(c_i),
        .s(s),
        .c_o(c_o)
    );

    // Test stimulus
    initial begin
        $display("=== %0d-bit Adder Test Start ===", bits);
        $monitor("Time=%0t | a=%b | b=%b | c_i=%b | sum=%b | c_o=%b",
                  $time, a, b, c_i, s, c_o);

        // Case 1: 0 + 0 + 0
        a = 16'b0000; b = 4'b0000; c_i = 0; #10;

        // Case 2: 3 + 5
        a = 4'b0011; b = 4'b0101; c_i = 0; #10;

        // Case 3: 7 + 8 with carry-in
        a = 4'b0111; b = 4'b1000; c_i = 1; #10;

        // Case 4: max + 1 (overflow)
        a = 4'b1111; b = 4'b0001; c_i = 0; #10;

        // Case 5: random
        a = 4'b1010; b = 4'b1100; c_i = 1; #10;

        $display("=== Test End ===");
        $finish;
    end

endmodule

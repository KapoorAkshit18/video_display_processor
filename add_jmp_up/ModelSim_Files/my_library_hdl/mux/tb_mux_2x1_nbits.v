`timescale 1ns/1ps

module tb_mux_2x1_nbits;

    // Parameter override for testing
    parameter bits = 4;  

    // Inputs
    reg [0:0] sel;
    reg [(bits-1):0] xin_0;
    reg [(bits-1):0] xin_1;

    // Outputs
    wire [(bits-1):0] xout;

    // Instantiate DUT
    mux_2x1_nbits #(.bits(bits)) uut (
        .sel(sel),
        .xin_0(xin_0),
        .xin_1(xin_1),
        .xout(xout)
    );

    // Stimulus
    initial begin
        $display("=== 2x1 Mux Test Start ===");
        $monitor("Time=%0t | sel=%b | xin_0=%b | xin_1=%b | xout=%b",
                  $time, sel, xin_0, xin_1, xout);

        // Case 1: sel = 0 ? xout = xin_0
        xin_0 = 4'b1010; xin_1 = 4'b1100; sel = 0; #10;

        // Case 2: sel = 1 ? xout = xin_1
        sel = 1; #10;

        // Case 3: change inputs while sel=0
        xin_0 = 4'b0001; xin_1 = 4'b1110; sel = 0; #10;

        // Case 4: change inputs while sel=1
        xin_0 = 4'b0101; xin_1 = 4'b1001; sel = 1; #10;

        // Case 5: invalid sel (x) ? should drive default
        sel = 1'bx; #10;

        $display("=== 2x1 Mux Test End ===");
        $finish;
    end

endmodule

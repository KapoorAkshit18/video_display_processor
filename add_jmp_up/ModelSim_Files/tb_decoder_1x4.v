//
`timescale 1ns/1ps

module tb_decoder_1x4;

    // Inputs
    reg [1:0] sel;

    // Outputs
    wire out_0, out_1, out_2, out_3;

    // DUT (Device Under Test)
    decoder_1x4 uut (
        .sel(sel),
        .out_0(out_0),
        .out_1(out_1),
        .out_2(out_2),
        .out_3(out_3)
    );

    initial begin
        $display("Time | sel | out_0 out_1 out_2 out_3");
        $display("-------------------------------------");
	
        sel = 2'b00; #10;
        $display("%4t | %b   |   %b     %b     %b     %b", 
                 $time, sel, out_0, out_1, out_2, out_3);

        sel = 2'b01; #10;
        $display("%4t | %b   |   %b     %b     %b     %b", 
                 $time, sel, out_0, out_1, out_2, out_3);

        sel = 2'b10; #10;
        $display("%4t | %b   |   %b     %b     %b     %b", 
                 $time, sel, out_0, out_1, out_2, out_3);

        sel = 2'b11; #10;
        $display("%4t | %b   |   %b     %b     %b     %b", 
                 $time, sel, out_0, out_1, out_2, out_3);

        $finish;
    end

endmodule


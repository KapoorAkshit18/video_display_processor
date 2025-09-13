`timescale 1ns/1ps

module tb_decoder3;

    // Inputs
    reg [2:0] sel;

    // Outputs
    wire dout_0, dout_1, dout_2, dout_3, dout_4, dout_5, dout_6, dout_7;

    // Instantiate DUT
    decoder3 uut (
        .dout_0(dout_0),
        .dout_1(dout_1),
        .dout_2(dout_2),
        .dout_3(dout_3),
        .dout_4(dout_4),
        .dout_5(dout_5),
        .dout_6(dout_6),
        .dout_7(dout_7),
        .sel(sel)
    );

    // Stimulus
    initial begin
        $display("=== Decoder3 Test Start ===");
        $monitor("Time=%0t | sel=%b | dout={%b %b %b %b %b %b %b %b}",
                  $time, sel,
                  dout_7, dout_6, dout_5, dout_4, dout_3, dout_2, dout_1, dout_0);

        // Test all select values
        sel = 3'b000; #10;
        sel = 3'b001; #10;
        sel = 3'b010; #10;
        sel = 3'b011; #10;
        sel = 3'b100; #10;
        sel = 3'b101; #10;
        sel = 3'b110; #10;
        sel = 3'b111; #10;

        $display("=== decoder3 Test End ===");
        $finish;
    end

endmodule

`timescale 1ns/1ps
// updown counter with preset function in
module counter_wih_preset_tb;

    // Parameters
    parameter bits = 3;        // test with 3 bits
    parameter maxvalue = 0;    // 0 means max = 2^bits - 1

    // Testbench signals
    reg clk;
    reg en;
    reg clr;
    reg dir;
    reg ld;
    reg [(bits-1):0] in;
    wire [(bits-1):0] out;
    wire ovf;

    // Instantiate the DUT (Device Under Test)
    counter_with_preset #(bits, maxvalue) dut (
        .c(clk),
        .en(en),
        .clr(clr),
        .dir(dir),
        .in(in),
        .ld(ld),
        .out(out),
        .ovf(ovf)
    );

    // Clock generation (10ns period ? 100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus
    initial begin
        // Dump waves (for ModelSim/GTKWave)
        $dumpfile("counter_preset_tb.vcd");
        $dumpvars(0, counter_preset_tb);

        // Initialize
        en = 0; clr = 0; dir = 0; ld = 0; in = 0;

        // Reset counter
        #10 clr = 1;
        #10 clr = 0;

        // Count up
        en = 1; dir = 0;
        repeat (10) @(posedge clk);

        // Load a value
        ld = 1; in = 3;
        @(posedge clk);
        ld = 0;

        // Count up more
        repeat (5) @(posedge clk);

        // Change direction ? count down
        dir = 1;
        repeat (10) @(posedge clk);

        // Finish simulation
        #20 $finish;
    end

    // Monitor values
    initial begin
        $monitor("Time=%0t clk=%b clr=%b ld=%b in=%d en=%b dir=%b out=%d ovf=%b",
                  $time, clk, clr, ld, in, en, dir, out, ovf);
    end

endmodule


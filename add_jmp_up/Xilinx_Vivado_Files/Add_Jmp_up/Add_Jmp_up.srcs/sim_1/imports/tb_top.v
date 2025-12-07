`timescale 1ns/1ps

module tb_top;

//------------------------------------------
// Clock and reset
//------------------------------------------
reg clk;
reg rst;

//------------------------------------------
// Inputs
//------------------------------------------
reg [15:0] value_in;
reg [3:0] buttons;
reg [3:0] dip_switches;

//------------------------------------------
// Outputs
//------------------------------------------
wire [3:0] led_debug;
wire [3:0] pc;
wire [15:0] o_b, o_r0, o_r1, o_r2, o_r3;

//------------------------------------------
// Instantiate Top Module
//------------------------------------------
top uut (
    .clk(clk),
    .rst(rst),
    .value(value_in),
    .buttons(buttons),
    .dip_switches(dip_switches),
    .led_debug(led_debug),
    .o_b(o_b),
    .o_r0(o_r0),
    .o_r1(o_r1),
    .o_r2(o_r2),
    .o_r3(o_r3),
    .pc(pc)
);

//------------------------------------------
// Clock generation
//------------------------------------------
initial clk = 0;
always #5 clk = ~clk;  // 100 MHz

//------------------------------------------
// Test sequence
//------------------------------------------
initial begin
    // Initialize inputs
    rst = 1;
    buttons = 4'b0000;
    dip_switches = 4'b0000;
    value_in = 16'h0000;
    
    // Release reset
    #20 rst = 0;

    //--------------------------------------
    // Program first instruction (ADD)
    //--------------------------------------
    $display("Programming first instruction (ADD)");
    value_in = 16'h1234;
    buttons[0] = 1;  // PROG pressed
    #20 buttons[0] = 0;  // release

    buttons[1] = 1;  // ADD pressed
    #20 buttons[1] = 0;

    #40;  // wait for processor to store

    //--------------------------------------
    // Program second instruction (JUMP)
    //--------------------------------------
    $display("Programming second instruction (JUMP)");
    value_in = 16'h5678;
    buttons[0] = 1;  // PROG
    #20 buttons[0] = 0;

    buttons[2] = 1;  // JUMP
    #20 buttons[2] = 0;

    #40;

    //--------------------------------------
    // Advance clock to execute instructions
    //--------------------------------------
    $display("Advancing processor");
    repeat (5) begin
        buttons[3] = 1;  // ADVANCE
        #20 buttons[3] = 0;
        #40;
    end

    //--------------------------------------
    // Change DIP switches
    //--------------------------------------
    $display("Changing DIP switches");
    dip_switches = 4'b1010;
    #50;
    dip_switches = 4'b0101;
    #50;

    //--------------------------------------
    // Finish simulation
    //--------------------------------------
    $display("Simulation complete");
    #50 $finish;
end

//------------------------------------------
// Monitor outputs
//------------------------------------------
initial begin
    $monitor("Time=%0t | buttons=%b | value_in=%h | pc=%b | o_b=%h | LEDs=%b",
              $time, buttons, value_in, pc, o_b, led_debug);
end

endmodule

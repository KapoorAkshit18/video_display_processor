`timescale 1ns/1ps

module tb_fpga_top;

    // Inputs (board-level)
    reg  [15:0] dip_value_in;
    reg         btn_add;
    reg         btn_jump;
    reg         btn_adv;
    reg         btn_dest_msb;
    reg  [2:0]  dip_ctrl;
    reg         rst;

    // Outputs (processor-level)
    wire [3:0]  pc;
    wire [15:0] o_b;
    wire [15:0] o_r0;
    wire [15:0] o_r1;
    wire [15:0] o_r2;
    wire [15:0] o_r3;

    // Instantiate the DUT
    fpga_top dut (
        .dip_value_in(dip_value_in),
        .btn_add(btn_add),
        .btn_jump(btn_jump),
        .btn_adv(btn_adv),
        .btn_dest_msb(btn_dest_msb),
        .dip_ctrl(dip_ctrl),
        .rst(rst),
        .pc(pc),
        .o_b(o_b),
        .o_r0(o_r0),
        .o_r1(o_r1),
        .o_r2(o_r2),
        .o_r3(o_r3)
    );

    // Clock generation for btn_adv (used as system clock)
    initial btn_adv = 0;
    always #5 btn_adv = ~btn_adv; // 100 MHz simulation clock

    // Test sequence
    initial begin
        // Initialize inputs
        dip_value_in   = 16'd0;
        btn_add        = 0;
        btn_jump       = 0;
        btn_dest_msb   = 0;
        dip_ctrl       = 3'b000;
        rst            = 1;

        #20;
        rst = 0; // release reset

        // --------------------------
        // Programming phase (simulate DIP switches & buttons)
        // --------------------------
        dip_ctrl = 3'b100; // prog = 1, src[0]=0, dest[0]=0
        dip_value_in = 16'd5;
        btn_add = 1; #10; btn_add = 0; #50;

        dip_value_in = 16'd10;
        dip_ctrl = 3'b100; // prog=1
        btn_add = 1; #10; btn_add = 0; #50;

        dip_value_in = 16'd20;
        dip_ctrl = 3'b101; // prog=1, dest[0]=1
        btn_add = 1; #10; btn_add = 0; #50;

        // --------------------------
        // Execution phase
        // --------------------------
        dip_ctrl = 3'b000; // prog=0
        dip_value_in = 16'd15;

        // Trigger ADD instruction
        btn_add = 1; #10; btn_add = 0; #50;

        // Trigger JUMP instruction
        btn_jump = 1; #10; btn_jump = 0; #50;

        // Trigger dest[1] button
        btn_dest_msb = 1; #10; btn_dest_msb = 0; #50;

        // Advance clock a few cycles
        repeat (10) @(posedge btn_adv);

        // Finish simulation
        $stop;
    end

    // Monitor processor outputs
    initial begin
        $monitor("Time=%0t | PC=%0d | R0=%0d | R1=%0d | R2=%0d | R3=%0d | o_b=%0d",
                  $time, pc, o_r0, o_r1, o_r2, o_r3, o_b);
    end

endmodule

`timescale 1ns/1ps

module tb_fpga_top;

    reg         clk_fpga;
    reg  [15:0] dip_value_in;
    reg         btn_add;
    reg         btn_jump;
    reg         btn_adv;
    reg         btn_dest_msb;
    reg  [2:0]  dip_ctrl;

    wire [3:0]  pc;
    wire [15:0] o_b, o_r0, o_r1, o_r2, o_r3;
    wire [31:0] w2_dbg;
    wire        asm_store_clk_dbg;

    // Instantiate DUT
    fpga_top uut (
        .clk_fpga    (clk_fpga),
        .dip_value_in(dip_value_in),
        .btn_add     (btn_add),
        .btn_jump    (btn_jump),
        .btn_adv     (btn_adv),
        .btn_dest_msb(btn_dest_msb),
        .dip_ctrl    (dip_ctrl),
        .pc          (pc),
        .o_b         (o_b),
        .o_r0        (o_r0),
        .o_r1        (o_r1),
        .o_r2        (o_r2),
        .o_r3        (o_r3),
        .w2_dbg      (w2_dbg),
        .asm_store_clk_dbg(asm_store_clk_dbg)
    );

    // Clock
    initial clk_fpga = 0;
    always #5 clk_fpga = ~clk_fpga; // 100MHz

    // Stimulus
    initial begin
        btn_add = 0;
        btn_jump = 0;
        btn_adv = 0;
        btn_dest_msb = 0;
        dip_value_in = 16'h00A5;
        dip_ctrl = 3'b000;

        #20;
        dip_ctrl = 3'b101; // prog=1, dest[0]=1, src=0

        // ADD
        $display("[%0t] Press ADD", $time);
        btn_add = 1; #10; btn_add = 0;
        #50;

        // JUMP
        $display("[%0t] Press JUMP", $time);
        btn_jump = 1; #10; btn_jump = 0;
        #50;

        // ADV
        $display("[%0t] Advance 3 times", $time);
        repeat(3) begin
            btn_adv = 1; #10; btn_adv = 0;
            #30;
        end

        #100;
        $display("[%0t] Simulation finished", $time);
        $stop;
    end

    // Live Monitor
    initial begin
        $monitor("[%0t] pc=%0d add=%b jump=%b prog=%b store_clk=%b inst=%h",
                 $time, pc, btn_add, btn_jump, dip_ctrl[2],
                 asm_store_clk_dbg, w2_dbg);
    end

    // VCD dump
    initial begin
        $dumpfile("fpga_top_tb.vcd");
        $dumpvars(0, tb_fpga_top);
    end

    // Self-check: detect store_clk
    reg saw_store = 0;
    always @(posedge clk_fpga) begin
        if (asm_store_clk_dbg) saw_store <= 1;
    end

    initial begin
        #500;
        if (saw_store)
            $display("PASS: asm_store_clk_dbg pulsed");
        else
            $display("FAIL: asm_store_clk_dbg never pulsed");
    end

endmodule

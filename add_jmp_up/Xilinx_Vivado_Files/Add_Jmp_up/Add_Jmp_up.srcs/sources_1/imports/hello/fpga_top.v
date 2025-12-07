//=============================================================
// FPGA Top Wrapper for Minimalist Processor
// Debounce + One-Pulse for push buttons using combined module
// ILA instantiated for internal signals
//=============================================================

module fpga_top (
    // Board Inputs
    input         clk_fpga,
    input  [15:0] dip_value_in,   // DIP switches for value
    input         btn_add,        // Push button for ADD
    input         btn_jump,       // Push button for JUMP
    input         btn_adv,        // Push button for advance/clock
    input         btn_dest_msb,   // Push button for dest[1]
    input  [2:0]  dip_ctrl,       // DIP[0]=dest[0], DIP[1]=src[0], DIP[2]=prog

    // Board Outputs
    output [3:0]  pc,
    output [15:0] o_b,
    output [15:0] o_r0,
    output [15:0] o_r1,
    output [15:0] o_r2,
    output [15:0] o_r3,
    output [31:0] w2_dbg,
    output        asm_store_clk_dbg
);

    //=========================================================
    // Debounce + One-Pulse for push buttons
    //=========================================================
    wire add, jump, dest_msb, advance_pulse;
`ifdef SIM
        // Simple edge detector for simulation
        assign add         = btn_add;
        assign jump        = btn_jump;
        assign dest_msb    = btn_dest_msb;
        assign advance_pulse = btn_adv;
    `else
        // Real debounce + one-pulse for synthesis
        debounce_onepulse udb_add      (.clk(clk_fpga), .rst(1'b0), .btn_in(btn_add),      .pulse_out(add));
        debounce_onepulse udb_jump     (.clk(clk_fpga), .rst(1'b0), .btn_in(btn_jump),     .pulse_out(jump));
        debounce_onepulse udb_dest_msb (.clk(clk_fpga), .rst(1'b0), .btn_in(btn_dest_msb), .pulse_out(dest_msb));
        debounce_onepulse udb_adv      (.clk(clk_fpga), .rst(1'b0), .btn_in(btn_adv),      .pulse_out(advance_pulse));
    `endif

  /*  debounce_onepulse udb_add      (.clk(clk_fpga), .rst(1'b0), .btn_in(btn_add),      .pulse_out(add));
    debounce_onepulse udb_jump     (.clk(clk_fpga), .rst(1'b0), .btn_in(btn_jump),     .pulse_out(jump));
    debounce_onepulse udb_dest_msb (.clk(clk_fpga), .rst(1'b0), .btn_in(btn_dest_msb), .pulse_out(dest_msb));
    debounce_onepulse udb_adv      (.clk(clk_fpga), .rst(1'b0), .btn_in(btn_adv),      .pulse_out(advance_pulse));
    
    assign add = btn_add;   // direct pass-through for sim
    assign jump = btn_jump;
    assign dest_msb = btn_dest_msb;
    assign advance_pulse = btn_adv;*/

    //=========================================================
    // Map DIP switches and buttons to processor signals
    //=========================================================
    wire [15:0] value   = dip_value_in;
    wire [1:0]  dest    = {dest_msb, dip_ctrl[0]};
    wire [1:0]  src     = {1'b0, dip_ctrl[1]};
    wire        prog    = dip_ctrl[2];
    wire        advance = advance_pulse; // processor clocked by one-pulse advance

    //=========================================================
    // Instantiate Processor Core
    //=========================================================
    add_jump_cpu u_core (
        .value   (value),
        .dest    (dest),
        .src     (src),
        .add     (add),
        .jump    (jump),
        .prog    (prog),
        .advance (advance),
        .pc      (pc),
        .o_b     (o_b),
        .o_r0    (o_r0),
        .o_r1    (o_r1),
        .o_r2    (o_r2),
        .o_r3    (o_r3),
        .w2_dbg  (w2_dbg),
        .asm_store_clk_dbg(asm_store_clk_dbg)
    );

    //=========================================================
    // Instantiate ILA (optional debug)
    //=========================================================
     u_ila probe_regs(
        .clk(clk_fpga),   // <<< FIXED: use system clock
        .probe_pc(pc),
        .probe_r0(o_r0),
        .probe_r1(o_r1),
        .probe_r2(o_r2),
        .probe_r3(o_r3),
        .probe_b(o_b)
    );

endmodule

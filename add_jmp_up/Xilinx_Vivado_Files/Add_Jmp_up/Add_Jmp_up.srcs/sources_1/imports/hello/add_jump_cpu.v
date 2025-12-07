//=============================================================
// Minimalist Instruction Set Processor (ADD + JUMP)
// Top-Level Module
//=============================================================

module add_jump_cpu (
    // Inputs
    input        [15:0] value,
    input        [1:0]  dest,
    input        [1:0]  src,
    input               add,
    input               jump,
    input               prog,
    input               advance,

    // Outputs (must be reg if driven by always blocks or initialized)
    output   [3:0]  pc,
    output   [15:0] o_b,
    output   [15:0] o_r0,
    output   [15:0] o_r1,
    output   [15:0] o_r2,
    output   [15:0] o_r3,
    output   [31:0] w2_dbg,
    output    asm_store_clk_dbg
);

//=============================================================
// Internal Signals
//=============================================================

    // Assembler <-> Memory
    wire [31:0] asm_inst;
    wire        asm_store_clk;

    // Memory <-> Decoder
    wire [31:0] mem_data;

    // Program Counter
    wire [3:0]  pc_internal;

    // Decoder Outputs
    wire [15:0] dec_imm;
    wire [1:0]  dec_rs;
    wire [1:0]  dec_rd;
    wire        dec_jump;
    wire        dec_add;

    // Execute
    wire [15:0] exe_result;
    wire [15:0] exe_b;

    // Control Signals
    wire clk_regfile = advance;
    

//=============================================================
// Assembler
//=============================================================
    assembler u_assembler (
        .prog     (prog),
        .value    (value),
        .dest     (dest),
        .src      (src),
        .asm_add  (add),
        .asm_jump (jump),
        .inst     (asm_inst),
        .store_clk(asm_store_clk)
    );

    assign w2_dbg = asm_inst;  // Debug output
    assign asm_store_clk_dbg = asm_store_clk;

//=============================================================
// EEPROM / Instruction Memory
//=============================================================
    eeprom u_eeprom (
        .c    (asm_store_clk),
        .str  (1'b1),
        .ld   (1'b1),
        .d_in (asm_inst),        // Instruction from assembler
        .a    (pc_internal),     // Program Counter Address
        .d    (mem_data)         // Instruction to decoder
    );

//=============================================================
// Program Counter
//=============================================================
    counter_with_preset #(.bits(4)) u_pc (
        .c    (advance),
        .en   (1'b1),
        .dir  (1'b0),
        .in   (dec_imm[3:0]),
        .ld   (dec_jump),
        .clr  (1'b0),
        .out  (pc_internal)
    );

    assign pc = pc_internal;

//=============================================================
// Decoder
//=============================================================
    decoder u_decoder (
        .d_prog (prog),
        .bypass (asm_inst),    // Direct assembler bypass
        .d_inst (mem_data),    // Instruction from memory
        .d_a    (dec_imm),
        .d_rs   (dec_rs),
        .d_rd   (dec_rd),
        .d_jump (dec_jump),
        .d_add  (dec_add)
    );

//=============================================================
// Execute
//=============================================================
    execute u_execute (
        .exe_a      (dec_imm),
        .exe_b      (exe_b),
        .exe_add    (dec_add),
        .exe_result (exe_result)
    );

//=============================================================
// Register File
//=============================================================
    regfile u_regfile (
        .rs     (dec_rs),
        .rd     (dec_rd),
        .result (exe_result),
        .clk    (clk_regfile),
        .o_b    (o_b),
        .o_r0   (o_r0),
        .o_r1   (o_r1),
        .o_r2   (o_r2),
        .o_r3   (o_r3)
    );

    assign exe_b = o_b;

endmodule

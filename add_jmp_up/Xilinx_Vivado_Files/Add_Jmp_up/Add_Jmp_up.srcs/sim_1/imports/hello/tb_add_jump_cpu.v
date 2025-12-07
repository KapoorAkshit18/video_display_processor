//=============================================================
// Testbench for Minimalist Instruction Set Processor (ADD + JUMP)
//=============================================================
module tb_add_jump_cpu;

    //=========================================================
    // Inputs to DUT
    //=========================================================
    reg [15:0] value;
    reg [1:0]  dest;
    reg [1:0]  src;
    reg        add;
    reg        jump;
    reg        prog;
    reg        advance;

    //=========================================================
    // Outputs from DUT
    //=========================================================
    wire [3:0]  pc;
    wire [15:0] o_b;
    wire [15:0] o_r0, o_r1, o_r2, o_r3;
    wire [31:0] w2_dbg;   // assembler instruction (debug)

    //=========================================================
    // DUT Instantiation
    //=========================================================
    add_jump_cpu uut (
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
        .w2_dbg  (w2_dbg)
    );

    //=========================================================
    // Clock Generation (using advance as clock)
    //=========================================================
    initial advance = 0;
    always #5 advance = ~advance; // 10 ns period

    //=========================================================
    // Simulation
    //=========================================================
    initial begin
        // Setup waveform dump
        $dumpfile("tb_top.vcd");
        $dumpvars(0, tb_top);

        // Initialize Inputs
        value = 0;
        dest  = 0;
        src   = 0;
        add   = 0;
        jump  = 0;
        prog  = 0;

        #10; // Wait for global reset

        //--------------------------
        // Programming Phase
        //--------------------------
        prog = 1; 
        add  = 1; 
        jump = 0;

        // Add 5 to R0
        value = 16'd5;  dest = 2'b00; src = 2'b00; #10;
        // Add 10 to R1
        value = 16'd10; dest = 2'b01; src = 2'b01; #10;
        // Add 20 to R2
        value = 16'd20; dest = 2'b10; src = 2'b10; #10;
        // Add 30 to R3
        value = 16'd30; dest = 2'b11; src = 2'b11; #10;

        // Jump to address 2
        add = 0; jump = 1;
        value = 16'd2; dest = 2'b00; src = 2'b00; #10;
        jump = 0;

        // Disable programming mode for execution
        prog = 0; add = 1; jump = 0;

        //--------------------------
        // Execution Phase
        //--------------------------
        // Step 1: Add 15 to R0
        value = 16'd15; dest = 2'b00; src = 2'b00; #10;
        // Step 2: R1 = R1 + R2
        value = 16'd0;  dest = 2'b01; src = 2'b10; #10;
        // Step 3: R3 = R3 + R0
        value = 16'd0;  dest = 2'b11; src = 2'b00; #10;
        // Step 4: R2 = R2 + 50
        value = 16'd50; dest = 2'b10; src = 2'b10; #10;

        // Observe PC & Registers
        repeat (10) begin
            #10;
            $display("T=%0t | PC=%0d | o_b=%0d | R0=%0d | R1=%0d | R2=%0d | R3=%0d",
                     $time, pc, o_b, o_r0, o_r1, o_r2, o_r3);
        end

        $stop;
    end

endmodule

`timescale 1ps / 1ps

module tb_top;

    // Inputs
    reg [15:0] value;
    reg [1:0] dest;
    reg [1:0] src;
    reg add;
    reg jump;
    reg prog;
    reg advance;

    // Outputs
    wire [3:0] pc;
    wire [15:0] o_b;
    wire [15:0] o_r0;
    wire [15:0] o_r1;
    wire [15:0] o_r2;
    wire [15:0] o_r3;
    wire [31:0] w2_dbg;
//eeprom op
    wire [31:0] d ;
    wire [31:0] d_in ;
    wire store_clk;
    wire c;
    wire [3:0]a;
    // Instantiate the Unit Under Test
    top uut (
        .value(value),
        .dest(dest),
        .src(src),
        .add(add),
        .jump(jump),
        .prog(prog),
        .advance(advance),
        .pc(pc),
        .o_b(o_b),
        .o_r0(o_r0),
        .o_r1(o_r1),
        .o_r2(o_r2),
        .o_r3(o_r3),
        .w2_dbg(w2_dbg)
    );
    assign d = uut.w6;
    assign d_in = uut.w2;
    assign store_clk = uut.w3;
    assign c =  uut.w3;
    assign a = uut.w5;
    // Clock generation using advance signal
    initial advance = 0;
    always #5 advance = ~advance; // 10ns period

    initial begin
        // Initialize Inputs
        value = 0;
        dest = 0;
        src = 0;
        add = 0;
        jump = 0;
        prog = 0;

        #10; // Wait for global reset

        // --------------------------
        // Programming Phase: Load Instructions
        // --------------------------
        prog = 1; 
        add = 1;   // Enable add for assembler
        jump = 0;

        // Add 5 to R0
        value = 16'd5; dest = 2'b00; src = 2'b00;
        #10;

        // Add 10 to R1
        value = 16'd10; dest = 2'b01; src = 2'b01;
        #10;

        // Add 20 to R2
        value = 16'd20; dest = 2'b10; src = 2'b10;
        #10;

        // Add 30 to R3
        value = 16'd30; dest = 2'b11; src = 2'b11;
        #10;

        // Jump to address 2 (loop test)
        add = 0; jump = 1;
        value = 16'd2; dest = 2'b00; src = 2'b00;
        #10;
        jump = 0;

        // Disable programming mode for execution
        prog = 0;
        add = 1; // test ADD during execution
        jump = 0;

        // --------------------------
        // Execution Phase
        // --------------------------
        // Add more test cases: modify registers while executing
        // Step 1: Add 15 to R0
        value = 16'd15; dest = 2'b00; src = 2'b00;
        #10;

        // Step 2: Add R1 + R2 ? R1 (using src as R2)
        value = 16'd0; dest = 2'b01; src = 2'b10;
        #10;

        // Step 3: Add R3 + R0 ? R3
        value = 16'd0; dest = 2'b11; src = 2'b00;
        #10;

        // Step 4: Add immediate 50 ? R2
        value = 16'd50; dest = 2'b10; src = 2'b10;
        #10;

        // Repeat a few cycles to see PC advance
        repeat (10) begin
            #10;
            $display("Time=%0t | PC=%0d | o_b=%0d | R0=%0d | R1=%0d | R2=%0d | R3=%0d",
                      $time, pc, o_b, o_r0, o_r1, o_r2, o_r3);
        end

        
    end

endmodule


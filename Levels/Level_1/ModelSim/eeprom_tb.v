`timescale 1ns/1ps
module eeprom_tb;

    // Inputs
    reg c;
    reg str, ld;
    reg [31:0] d_in;
    reg [3:0] a;

    // Outputs
    wire [31:0] d;
    integer i;

    // Instantiate the Unit Under Test (UUT)
    eeprom uut (
        .c(c),
        .str(str),
        .ld(ld),
        .d_in(d_in),
        .a(a),
        .d(d)
    );

    // Clock generation
    initial begin
        c = 0;
        forever #5 c = ~c;
    end

    initial begin
        // Initialize Inputs
        str = 0;
        ld = 0;
        a = 0;
        d_in = 0;
        #20;

        // Write all locations
        str = 1;
        for(i = 0; i < 16; i = i + 1) begin
            a = i;
            d_in = i + 1;
            @(posedge c);
            str = 0;
            @(posedge c);
            $display("Writing %0h to addr %0d", d_in, a);
            str = 1;
        end
        str = 0;

        // Read all locations
        #10;
        
        for(i = 0; i < 16; i = i + 1) begin
	    ld = 1;
            a = i;
            @(posedge c);
            $display("Read addr %0d = %0h", a, d);
        end
        ld = 0;

        #10;
        $finish;
    end

endmodule


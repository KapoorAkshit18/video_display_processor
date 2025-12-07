module tb_regfile;

    // Inputs
    reg [1:0] rs;
    reg [1:0] rd;
    reg [15:0] result;
    reg clk;

    // Outputs
    wire [15:0] b;
    wire [15:0] r0, r1, r2, r3;

    // Instantiate the regfile module
    regfile uut (
        .rs(rs),
        .rd(rd),
        .result(result),
        .clk(clk),
        .b(b),
        .r0(r0),
        .r1(r1),
        .r2(r2),
        .r3(r3)
    );

    // Clock generator
    always #5 clk = ~clk;

    initial begin
        $monitor("Time=%0t | rs=%b rd=%b result=%h | r0=%h r1=%h r2=%h r3=%h | b=%h",
                  $time, rs, rd, result, r0, r1, r2, r3, b);

        // Initialize signals
        clk = 0;
        rs = 2'b00;
        rd = 2'b00;
        result = 16'h0000;

        // Write to r0
        #10 rd = 2'b00; result = 16'hAAAA;
        #10;

        // Write to r1
        rd = 2'b01; result = 16'hBBBB;
        #10;

        // Write to r2
        rd = 2'b10; result = 16'hCCCC;
        #10;

        // Write to r3
        rd = 2'b11; result = 16'hDDDD;
        #10;

        // Now test reads (b output)
        rs = 2'b00; #10;
        rs = 2'b01; #10;
        rs = 2'b10; #10;
        rs = 2'b11; #10;

        $finish;
    end

endmodule

module tb;

    // Inputs
    reg c;
    reg str,ld;
    reg [31:0] d_in;
    reg [3:0] a;

    // Outputs
    wire [31:0] d;       
    integer i;

    // Instantiate the Unit Under Test (UUT)
    program3 uut (
        .c(c), 
        .str(str), 
	.ld(ld),
        .d_in(d_in), 
        .a(a), 
        .d(d)
    );
    
    always
        #5 c = ~c;   // creating clock signal

initial begin
    // Initialize 
    c = 0;
    str = 0;
    ld = 0;
    d_in = 0;
    a = 0;
    #20;

    // Write to RoM (sync)
	str = 1;
    for(i=1; i <= 16; i = i + 1) begin
        @(negedge c);
        d_in = i;
        a = i - 1;
        str = 1;
	$display("Writing %0h to addr %0d", d_in, a);  // Confirm what's being written
        @(posedge c);  // sync write on posedge
    end
    str = 0;

    // Read from RoM (async)
    ld = 1; 
    for(i=1; i <= 16; i = i + 1) begin
        a = i - 1;
        #1 $display("Read addr %0d = %0h", a, d);
        #9;
    end
    ld = 0;

end
endmodule
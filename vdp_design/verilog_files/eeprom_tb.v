module eeprom_tb;

    // Inputs
    reg c;
    reg str,ld;
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
    
    always
        #5 c = ~c;   // creating clock signal

    initial begin
        // Initialize Inputs
  	c=0;
        a = 0;
        str = 0;
	ld = 0;
        d_in = 0; 
        #20;
        //Write all the locations of RoM
        str = 1;  
      for(i=1; i <= 16; i = i + 1) begin
            a = i-1;
	    d_in = i;
	    @(posedge c);
	    $display("Writing %0h to addr %0d", d_in, a);  // Confirm what's being written
	   
        end
#10; str=0; ld = 1;
        for(i=1; i <= 16; i = i + 1) begin
            a = i-1;
	    @(posedge c);
	    $display("Read addr %0d = %0h", a, d);  // Confirm what's being written
	   
        end
#10;
        str = 1;
        ld = 1;  
	a= 0;
	d_in=0;
        //Read and write from all the locations of RoM.
       
        for(i=1; i <= 16; i = i + 1) begin
            a = i-1;
	    d_in = i;
	@(posedge c);
	       $display("Read addr %0d = %0h", a, d);
               $display("Writing %0h to addr %0d", d_in, a);
               $display("WRITE: addr=%0d data_in=%0h", a, d_in);
        end
#10;
        c=0;
        a = 0;
        str = 0;
	ld = 0;
        d_in = 0;
        a = 0; 
 end     
endmodule








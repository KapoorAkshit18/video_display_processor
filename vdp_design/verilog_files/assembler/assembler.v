module program3 
    (   input c, //clock
        input str,    //write enable 
	input ld,   // read enable
        input [31:0] d_in,    //Input data to port 0.
        input [3:0] a,  //address for 
        output [31:0] d    //output data from port 0.
 
    );

//memory declaration.
reg [31:0] rom[0:15];

//writing to the RAM
always@(posedge c)
begin
    if(str)    //check enable signal and if write enable is ON
        rom[a] <= d_in;
end

//always reading from the ram, irrespective of clock.
assign d = ld ? rom[a] : 32'bz;   
  

endmodule

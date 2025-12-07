`timescale 1ns/1ps

module tb_demux_nbits;

parameter bits = 16;
parameter otherwise = 0;

wire [bits-1:0]out_0,out_1,out_2,out_3;
reg [bits-1:0] in;
reg [1:0] sel;

demux_nbits #(.bits(16),.otherwise(0))
dut
(.out_0(out_0),
 .out_1(out_1),
 .out_2(out_2),
 .out_3(out_3),
 .sel(sel),
 .in(in)

);
initial begin
 $display("Time | in  | sel | out_0 out_1 out_2 out_3");
 $display("-------------------------------------");

 in = 16'h0000_abcd;
 sel = 2'b00; 
#10;
        $display("%4t | %h   | %h   |   %h     %h     %h     %b", 
                 $time, sel, in, out_0, out_1, out_2, out_3);

        sel = 2'b01; #10;
        $display("%4t | %h   |   %h     %h     %h     %h", 
                 $time, sel, in, out_0, out_1, out_2, out_3);

        sel = 2'b10; #10;
        $display("%4t | %h   |   %h     %h     %h     %h", 
                 $time, sel, in, out_0, out_1, out_2, out_3);

        sel = 2'b11; #10;
        $display("%4t | %h   |   %h     %h     %h     %h", 
                 $time, sel, in, out_0, out_1, out_2, out_3);

        $finish;
    end
endmodule

// made by Akshit

module demux_nbits
#(
    parameter bits = 2,
    parameter otherwise = 0 
)
(
    output [(bits-1):0] out_0,
    output [(bits-1):0] out_1,
    output [(bits-1):0] out_2,
    output [(bits-1):0] out_3,
    input [1:0] sel,
    input [(bits-1):0] in
);
    assign out_0 = (sel == 2'h0)? in : otherwise;
    assign out_1 = (sel == 2'h1)? in : otherwise;
    assign out_2 = (sel == 2'h2)? in : otherwise;
    assign out_3 = (sel == 2'h3)? in : otherwise;
endmodule



module DemuxBus2
#(
    parameter Bits = 2,
    parameter Default = 0 
)
(
    output [(Bits-1):0] out_0,
    output [(Bits-1):0] out_1,
    output [(Bits-1):0] out_2,
    output [(Bits-1):0] out_3,
    input [1:0] sel,
    input [(Bits-1):0] in
);
    assign out_0 = (sel == 2'h0)? in : Default;
    assign out_1 = (sel == 2'h1)? in : Default;
    assign out_2 = (sel == 2'h2)? in : Default;
    assign out_3 = (sel == 2'h3)? in : Default;
endmodule

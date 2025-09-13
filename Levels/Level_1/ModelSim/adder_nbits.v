module adder_nbits
#(
    parameter bits = 16
)
(
    input [(bits-1):0] a,
    input [(bits-1):0] b,
    input c_i,
    output [(bits - 1):0] s,
    output c_o
);
   wire [bits:0] temp;

   assign temp = a + b + c_i;
   assign s = temp [(bits-1):0];
   assign c_o = temp[bits];
endmodule

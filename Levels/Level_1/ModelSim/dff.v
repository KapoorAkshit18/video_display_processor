// made by Akshit

module dff #(
    parameter bits = 1
)
(
    input c,
    input en,
    input [(bits - 1):0]d,
    output [(bits - 1):0]q
);

    reg [(bits - 1):0] state = 'h0;   // for defining prev state
    assign q = state;
    always @ (posedge c) begin
        if (en)
            state <= d;
   end
endmodule


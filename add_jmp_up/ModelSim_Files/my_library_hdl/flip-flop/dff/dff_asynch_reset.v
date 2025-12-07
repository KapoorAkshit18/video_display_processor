// made by Akshit

module dff #(
    parameter bits = 1
)
(
    input c,                          // clock
    input en,                         // enable
    input rst_n,                      // async active-low reset
    input [(bits - 1):0] d,           // data input
    output [(bits - 1):0] q           // data output
);

    reg [(bits - 1):0] state;

    assign q = state;

    // Async reset: clears state immediately when rst_n=0
    always @ (posedge c or negedge rst_n) begin
        if (!rst_n)
            state <= {bits{1'b0}};    // reset to 0
        else if (en)
            state <= d;
    end

endmodule

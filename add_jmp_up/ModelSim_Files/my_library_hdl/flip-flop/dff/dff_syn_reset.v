// made by Akshit

module dff_sync_reset #(
    parameter bits = 1
)
(
    input c,                          // clock
    input en,                         // enable
    input rst,                        // sync active-high reset
    input [(bits - 1):0] d,           // data input
    output [(bits - 1):0] q           // data output
);

    reg [(bits - 1):0] state;

    assign q = state;

    // Sync reset: checked only at posedge of clock
    always @ (posedge c) begin
        if (rst)
            state <= {bits{1'b0}};
        else if (en)
            state <= d;
    end

endmodule

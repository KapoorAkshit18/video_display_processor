module mux_2x1_nbits #(                   // 2 cross 1 mux for add or jump
    parameter bits = 2
)
(
    input [0:0] sel,		// maybe to preserve uniformity
    input [(bits - 1):0] xin_0,
    input [(bits - 1):0] xin_1,
    output reg [(bits - 1):0] xout
);
    always @ (*) begin
        case (sel)
            1'h0: xout = xin_0;
            1'h1: xout = xin_1;
            default:
                xout = 'h0;
        endcase
    end
endmodule
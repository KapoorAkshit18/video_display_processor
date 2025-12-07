module priorityencoder3 (
    input  in0, in1, in2, in3, in4, in5, in6, in7,
    output reg [2:0] num,
    output           any
);
    // "any" is high if ANY input is high
    assign any = in0 | in1 | in2 | in3 | in4 | in5 | in6 | in7;

    // Priority encoding: in7 highest, in0 lowest
    always @(*) begin
        casex ({in7,in6,in5,in4,in3,in2,in1,in0})
            8'b1xxxxxxx: num = 3'd7;
            8'b01xxxxxx: num = 3'd6;
            8'b001xxxxx: num = 3'd5;
            8'b0001xxxx: num = 3'd4;
            8'b00001xxx: num = 3'd3;
            8'b000001xx: num = 3'd2;
            8'b0000001x: num = 3'd1;
            8'b00000001: num = 3'd0;
            default:     num = 3'd0; // default NOP
        endcase
    end
endmodule

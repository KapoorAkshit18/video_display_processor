module decoder3 (     // 8 cross 1 decoder 
    output dout_0,
    output dout_1,
    output dout_2,
    output dout_3,
    output dout_4,
    output dout_5,
    output dout_6,
    output dout_7,
    input [2:0] sel
    
);
    assign dout_0 = (sel == 3'h0)? 1'b1 : 1'b0;
    assign dout_1 = (sel == 3'h1)? 1'b1 : 1'b0;
    assign dout_2 = (sel == 3'h2)? 1'b1 : 1'b0;
    assign dout_3 = (sel == 3'h3)? 1'b1 : 1'b0;
    assign dout_4 = (sel == 3'h4)? 1'b1 : 1'b0;
    assign dout_5 = (sel == 3'h5)? 1'b1 : 1'b0;
    assign dout_6 = (sel == 3'h6)? 1'b1 : 1'b0;
    assign dout_7 = (sel == 3'h7)? 1'b1 : 1'b0;
endmodule


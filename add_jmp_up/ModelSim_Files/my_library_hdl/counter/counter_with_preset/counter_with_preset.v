module counter_with_preset #(             // parametrized module 
    parameter bits = 4,
    parameter maxvalue = 15
)
(
    input c,
    input en,
    input clr,
    input dir,
    input [(bits-1):0] in,
    input ld,
    output [(bits-1):0] out,
    output ovf
);

    reg [(bits-1):0] count = 'h0;        // parametrized module so leave 2'h0

    function automatic [(bits-1):0] maxval (input [(bits-1):0] maxv);
        if (maxv == 0)
            maxval = (1 << bits) - 1;
        else
            maxval = maxv;
    endfunction

    assign out = count;
    assign ovf = ((count == maxval(maxvalue) & dir == 1'b0)
                  | (count == 'b0 & dir == 1'b1))? en : 1'b0;

    always @ (posedge c) begin
        if (clr == 1'b1)
            count <= 'h0;

        else if (ld == 1'b1)
            count <= in;

        else if (en == 1'b1) begin

            if (dir == 1'b0) begin

                if (count == maxval(maxvalue))
                    count <= 'h0;

                else
                    count <= count + 1'b1;

            end

            else begin
             
		   if (count == 'h0)
                    count <= maxval(maxvalue);
                else
                    count <= count - 1;

            end
        end
    end
endmodule




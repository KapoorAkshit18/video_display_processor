module tb_dff_nbits;

  parameter bits = 16;

  reg c,en;
  reg [(bits-1):0]d;
  wire [(bits-1):0]q;

// dff instance

  dff  #(
	.bits(16)
	)
  instance01(
	.c(c),
	.en(en),
	.d(d),
	.q(q)
	);
	initial begin
	forever #10 c = ~c;
	end

	initial begin
	
	$display("Time , c, en ,   d    ,  q");
	$display("--------------------------");

// Test Cases

  	 
	 c  = 0;
         en = 0;
         d  = 16'haaaa_aaaa;
	$display("%4t , %1b, %1b , %4h , %4h", 
	$time,  c , en, d , q );
#10;
	 en = 1;
	 d  = 16'haaaa_aaaa;
        $display("%4t , %1b, %1b , %4h , %4h", 
	$time, c , en, d , q );
#10;
	 en = 1;
	 d = 16'habcd_abcd;
        $display("%4t , %1b, %1b , %4h , %4h", 
	$time,  c , en, d , q );
#10;
	 en= 1;
	 d = 16'hffff_ffff;
        $display("%4t , %1b, %1b , %4h , %4h", 
	$time, c , en, d , q );
#10;
	 en = 0;
	 d = 16'hffff_0000;
        $display("%4t , %1b, %1b , %4h , %4h", 
	$time, c , en, d , q );
#10;
$finish;

end
endmodule



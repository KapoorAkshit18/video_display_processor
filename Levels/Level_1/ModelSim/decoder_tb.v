module decoder_tb;

  // Inputs
  reg d_prog;
  reg [31:0] bypass;
  reg [31:0] d_inst;

  // Outputs
  wire [15:0] d_a;
  wire [1:0]  d_rs;
  wire [1:0]  d_rd;
  wire        d_jump;
  wire        d_add;
  wire [2:0] iw2_dbg;   // <-- new debug signal


  // Instantiate the Unit Under Test (UUT)
  decoder uut (
    .d_prog(d_prog),
    .bypass(bypass),
    .d_inst(d_inst),
    .d_a(d_a),
    .d_rs(d_rs),
    .d_rd(d_rd),
    .d_jump(d_jump),
    .d_add(d_add),
    .iw2_dbg(iw2_dbg)

  );

  initial begin
$monitor("%4t   %1b    %03b   %2b  %2b  %04h    %1b    %1b",
         $time, d_prog, iw2_dbg, d_rs, d_rd, d_a, d_add, d_jump);



    // ============================
    // Case 1: prog=0 ? instruction selected
    // ADD operation (iw2 = 000)
    // ============================
    d_prog = 0;
    d_inst = {5'b00000, 3'b000, 2'b00, 2'b01, 2'b00, 2'b10, 16'h000A};
    bypass      = 32'hFFFFFFFF; // dummy
    #10;

    // ============================
    // Case 2: prog=1 ? bypass selected
    // JUMP operation (iw2 = 111)
    // ============================
    d_prog = 1;
    d_inst = 32'h0000000A; // ignored
    bypass      = {5'b00000, 3'b111, 2'b00, 2'b11, 2'b00, 2'b01, 16'h0003};
     #10;

    // ============================
    // Case 3: prog=1 ? bypass selected
    // Other operation (iw2 = 010)
    // ============================
    d_prog = 1;
    bypass      = {5'b00000, 3'b010, 2'b00, 2'b11, 2'b00, 2'b01, 16'h0003};
    #10;

    $finish;
  end

endmodule


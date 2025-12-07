// probe_registers.v
module probe_registers(
    input  wire clk,
    input  wire [15:0] o_b,
    input  wire [15:0] o_r0,
    input  wire [15:0] o_r1,
    input  wire [15:0] o_r2,
    input  wire [15:0] o_r3,
    output reg [3:0] pc,
    output reg [3:0] probe_pc,
    output reg  [15:0] probe_b,
    output reg  [15:0] probe_r0,
    output reg  [15:0] probe_r1,
    output reg  [15:0] probe_r2,
    output reg  [15:0] probe_r3
);

    always @(posedge clk) begin
        probe_pc <= pc;
        probe_b  <= o_b;
        probe_r0 <= o_r0;
        probe_r1 <= o_r1;
        probe_r2 <= o_r2;
        probe_r3 <= o_r3;
    end
endmodule

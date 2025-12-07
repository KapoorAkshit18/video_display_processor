// gpio.v
module gpio (
    input  wire        clk,        // system clock
    input  wire [3:0]  btn_raw,    // raw button inputs
    output reg  [3:0]  btn_pulse   // clean one-cycle pulses
);

    reg [3:0] sync0, sync1;  // synchronizers
    reg [3:0] btn_prev;

    always @(posedge clk) begin
        // Synchronize
        sync0 <= btn_raw;
        sync1 <= sync0;

        // Edge detection (pulse on rising edge)
        btn_pulse <= sync1 & ~btn_prev;

        // Remember previous state
        btn_prev <= sync1;
    end

endmodule

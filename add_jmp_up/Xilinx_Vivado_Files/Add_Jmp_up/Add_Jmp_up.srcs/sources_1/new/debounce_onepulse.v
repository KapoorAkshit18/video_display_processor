module debounce_onepulse (
    input  wire clk,        // System clock
    input  wire rst,        // Active-high reset
    input  wire btn_in,     // Raw noisy push button input
    output reg  pulse_out   // Clean 1-clock pulse on button press
);

`ifdef SIM
    // ------------------------------
    // Simulation-friendly version
    // ------------------------------
    reg btn_in_d;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            btn_in_d   <= 0;
            pulse_out  <= 0;
        end else begin
            btn_in_d   <= btn_in;
            pulse_out  <= (btn_in & ~btn_in_d); // rising edge ? 1-cycle pulse
        end
    end

`else
    // ------------------------------
    // FPGA-friendly debounce version
    // ------------------------------
    parameter integer DEBOUNCE_CYCLES = 20_000;  
    // e.g. for 100 MHz clock ? 200 ?s debounce

    reg btn_sync_0, btn_sync_1;
    reg btn_stable;
    reg [$clog2(DEBOUNCE_CYCLES):0] counter;
    reg btn_stable_d;

    // Sync
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            btn_sync_0 <= 0;
            btn_sync_1 <= 0;
        end else begin
            btn_sync_0 <= btn_in;
            btn_sync_1 <= btn_sync_0;
        end
    end

    // Debounce
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter    <= 0;
            btn_stable <= 0;
        end else if (btn_sync_1 == btn_stable) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
            if (counter >= DEBOUNCE_CYCLES) begin
                btn_stable <= btn_sync_1;
                counter    <= 0;
            end
        end
    end

    // One-pulse
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            btn_stable_d <= 0;
            pulse_out    <= 0;
        end else begin
            btn_stable_d <= btn_stable;
            pulse_out    <= (btn_stable & ~btn_stable_d);
        end
    end
`endif

endmodule

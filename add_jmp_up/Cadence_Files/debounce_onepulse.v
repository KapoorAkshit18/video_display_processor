module debounce_onepulse (
    input  wire clk,        // System clock
    input  wire rst,        // Active-high reset
    input  wire btn_in,     // Raw noisy push button input
    output reg  pulse_out   // Clean 1-clock pulse on button press
);

    parameter integer DEBOUNCE_CYCLES = 5;

    // ------------------------------------------
    // Synchronizer (to avoid metastability)
    // ------------------------------------------
    reg btn_sync0, btn_sync1;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            btn_sync0 <= 0;
            btn_sync1 <= 0;
        end else begin
            btn_sync0 <= btn_in;
            btn_sync1 <= btn_sync0;
        end
    end

    // ------------------------------------------
    // Edge-first debounce
    // ------------------------------------------
    reg btn_state;   // last stable state
    reg [$clog2(DEBOUNCE_CYCLES):0] counter;
    reg lock;        // blocks new edges until debounce ends

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            btn_state <= 0;
            pulse_out <= 0;
            counter   <= 0;
            lock      <= 0;
        end else begin
            pulse_out <= 0;  // default

            if (!lock) begin
                // check for rising edge
                if (btn_state == 0 && btn_sync1 == 1) begin
                    pulse_out <= 1;   // immediate pulse
                    btn_state <= 1;
                    lock      <= 1;   // enter debounce lockout
                    counter   <= 0;
                end else if (btn_state == 1 && btn_sync1 == 0) begin
                    // release detected (no pulse, just update state)
                    btn_state <= 0;
                    lock      <= 1;   // debounce release too
                    counter   <= 0;
                end
            end else begin
                // in debounce lockout, wait for stability
                counter <= counter + 1;
                if (counter >= DEBOUNCE_CYCLES) begin
                    lock    <= 0;  // re-enable edge detection
                    counter <= 0;
                end
            end
        end
    end

endmodule

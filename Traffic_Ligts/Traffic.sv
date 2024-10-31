module Traffic (
    input logic clk,
    input logic rst,
    input logic TAORB, // 1 if traffic on A, 0 if traffic on B
    output logic [5:0] led // LED output representing traffic lights
);

    // State definitions
    typedef enum logic [1:0] {
        S0_GREENRED = 2'b00,   // Main road green, side road red
        S1_YELLOWRED = 2'b01,  // Main road yellow, side road red
        S2_REDGREEN = 2'b10,   // Main road red, side road green
        S3_REDYELLOW = 2'b11   // Main road red, side road yellow
    } state_t;

    state_t state_reg, state_next;
    logic [3:0] TIMER; // 4-bit counter for timing

    // Sequential block for state transitions
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state_reg <= S0_GREENRED;
            TIMER <= 0;
        end else begin
            state_reg <= state_next;

            if (state_reg == S1_YELLOWRED || state_reg == S3_REDYELLOW) begin
                TIMER <= TIMER + 1;
            end else begin
                TIMER <= 0; // Reset TIMER in other states
            end
        end
    end

    // Combinational logic block for state transitions and output
    always_comb begin
        // Default state assignment
        state_next = state_reg;
        led = 6'b000000;

        case (state_reg)
            S0_GREENRED: begin
                led = 6'b001100; // Main green, side red
                if (~TAORB) state_next = S1_YELLOWRED;
            end

            S1_YELLOWRED: begin
                led = 6'b010100; // Main yellow, side red
                if (TIMER == 5) state_next = S2_REDGREEN;
            end

            S2_REDGREEN: begin
                led = 6'b100001; // Main red, side green
                if (TAORB) state_next = S3_REDYELLOW;
            end

            S3_REDYELLOW: begin
                led = 6'b100010; // Main red, side yellow
                if (TIMER == 5) state_next = S0_GREENRED;
            end
        endcase
    end
endmodule

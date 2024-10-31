module Traffic_Top (
    input logic clk_100MHz,
    input logic reset,
    input logic TAORB, // Traffic signal indicating which road has traffic
    output logic [5:0] led // LED output for traffic light states
);

    // Signal for 1Hz clock
    logic clk_1Hz;

    // Half-second clock divider instance
    halfsecond clk_div (
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .clk_halfsec(clk_1Hz)
    );

    // Traffic light FSM instance
    Traffic traffic_controller (
        .clk(clk_1Hz),
        .rst(reset),
        .TAORB(TAORB),
        .led(led)
    );

endmodule

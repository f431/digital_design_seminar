`timescale 1ns / 1ps

module Traffic_Top_tb;

    // Declare inputs and outputs for Traffic_Top
    logic clk_100MHz;
    logic reset;
    logic TAORB; // Input for traffic indication on A or B
    logic [5:0] led; // Output for traffic light states

    // Instantiate the Traffic_Top module
    Traffic_Top dut (
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .TAORB(TAORB),
        .led(led)
    );

    // Clock generation (100 MHz)
    always #5 clk_100MHz = ~clk_100MHz;

    // Test sequence
    initial begin
        // Initialize inputs
        clk_100MHz = 0;
        reset = 1;
        TAORB = 1; // Start with traffic on A

        // Hold reset for a few cycles, then release
        #20 reset = 0;

        // Test traffic patterns by toggling TAORB at intervals
        // This will allow the FSM to move through its states

        // Simulate traffic on A for a while, then switch to B
        repeat (5) begin
            TAORB = 1; // Traffic on A
            #1000000000; // Wait 1 second (equivalent to 1 Hz clock cycle)
        end

        // Change to traffic on B
        TAORB = 0;
        repeat (5) begin
            #1000000000; // Wait 1 second
        end

        // Repeat traffic on A and B with different timing
        TAORB = 1;
        #1000000000; // Wait 1 second
        TAORB = 0;
        #500000000;  // Wait half a second
        TAORB = 1;
        #500000000;  // Wait half a second

        // Finish the simulation
        $stop;
    end

    // Monitor the LED output for debugging
    initial begin
        $monitor("Time: %0t | Reset: %0b | TAORB: %0b | LED: %0b", $time, reset, TAORB, led);
    end
endmodule

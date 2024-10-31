`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2024 16:01:39
// Design Name: 
// Module Name: seconds
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Second (
    input clk_100MHz,
    input reset,
    output clk_1Hz,
    output clk_halfsecond
);

    reg [25:0] count_1Hz = 0;
    reg [25:0] count_halfsecond = 0;
    
    reg r_1Hz = 0;
    reg r_halfsecond = 0;
    
    // 1 Hz clock divider
    always @(posedge clk_100MHz or posedge reset)
        if (reset) begin
            count_1Hz <= 26'b0;
            r_1Hz <= 1'b0;
        end else begin
            if (count_1Hz == 26'd49_999_999) begin
                count_1Hz <= 26'b0;
                r_1Hz <= ~r_1Hz; // Toggle output to create 1 Hz clock
            end else begin 
                count_1Hz <= count_1Hz + 1;
            end
        end

    // Half-second (2 Hz) clock divider
    always @(posedge clk_100MHz or posedge reset)
        if (reset) begin
            count_halfsecond <= 26'b0;
            r_halfsecond <= 1'b0;
        end else begin
            if (count_halfsecond == 26'd12_499_999) begin
                count_halfsecond <= 26'b0;
                r_halfsecond <= ~r_halfsecond; // Toggle output to create half-second clock
            end else begin 
                count_halfsecond <= count_halfsecond + 1;
            end
        end

    // Assign outputs
    assign clk_1Hz = r_1Hz;
    assign clk_halfsecond = r_halfsecond;

endmodule

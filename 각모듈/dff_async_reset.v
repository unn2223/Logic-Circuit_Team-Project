`timescale 1ns/1ps

module dff_async_reset #(
    parameter RESET_VALUE = 1'b0
)(
    input  wire clk,
    input  wire reset,
    input  wire d,
    output reg  q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= RESET_VALUE;
        end else begin
            q <= d;
        end
    end
endmodule

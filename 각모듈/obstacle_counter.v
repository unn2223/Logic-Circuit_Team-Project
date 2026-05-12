`timescale 1ns/1ps

module obstacle_counter(
    input  wire       clk,
    input  wire       reset,
    input  wire       start_event,
    input  wire       safe_event,
    output wire [1:0] pattern,
    output wire       last_pattern,
    output wire       pattern_inc_event
);
    supply0 gnd;

    wire n_last_pattern;
    wire n_pattern0;
    wire inc1;
    wire [1:0] after_inc;
    wire [1:0] d;

    and u_and_last_pattern(last_pattern, pattern[1], pattern[0]);
    not u_not_last_pattern(n_last_pattern, last_pattern);
    and u_and_pattern_inc_event(pattern_inc_event, safe_event, n_last_pattern);

    not u_not_pattern0(n_pattern0, pattern[0]);
    xor u_xor_inc1(inc1, pattern[1], pattern[0]);

    mux2_1 u_inc_mux0(.in0(pattern[0]), .in1(n_pattern0), .sel(pattern_inc_event), .y(after_inc[0]));
    mux2_1 u_inc_mux1(.in0(pattern[1]), .in1(inc1), .sel(pattern_inc_event), .y(after_inc[1]));

    mux2_1 u_start_mux0(.in0(after_inc[0]), .in1(gnd), .sel(start_event), .y(d[0]));
    mux2_1 u_start_mux1(.in0(after_inc[1]), .in1(gnd), .sel(start_event), .y(d[1]));

    dff_async_reset #(.RESET_VALUE(1'b0)) u_pattern_ff0(.clk(clk), .reset(reset), .d(d[0]), .q(pattern[0]));
    dff_async_reset #(.RESET_VALUE(1'b0)) u_pattern_ff1(.clk(clk), .reset(reset), .d(d[1]), .q(pattern[1]));
endmodule

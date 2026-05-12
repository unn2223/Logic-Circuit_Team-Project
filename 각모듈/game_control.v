`timescale 1ns/1ps

module game_control(
    input  wire clk,
    input  wire reset,
    input  wire start_event,
    input  wire hit_event,
    input  wire clear_event,
    output wire running,
    output wire clear,
    output wire game_over
);
    supply0 gnd;
    supply1 vdd;

    wire running_after_clear;
    wire clear_after_clear;
    wire game_over_after_clear;
    wire running_after_hit;
    wire clear_after_hit;
    wire game_over_after_hit;
    wire running_d;
    wire clear_d;
    wire game_over_d;

    mux2_1 u_clear_mux_running(.in0(running), .in1(gnd), .sel(clear_event), .y(running_after_clear));
    mux2_1 u_clear_mux_clear(.in0(clear), .in1(vdd), .sel(clear_event), .y(clear_after_clear));
    mux2_1 u_clear_mux_game_over(.in0(game_over), .in1(gnd), .sel(clear_event), .y(game_over_after_clear));

    mux2_1 u_hit_mux_running(.in0(running_after_clear), .in1(gnd), .sel(hit_event), .y(running_after_hit));
    mux2_1 u_hit_mux_clear(.in0(clear_after_clear), .in1(gnd), .sel(hit_event), .y(clear_after_hit));
    mux2_1 u_hit_mux_game_over(.in0(game_over_after_clear), .in1(vdd), .sel(hit_event), .y(game_over_after_hit));

    mux2_1 u_start_mux_running(.in0(running_after_hit), .in1(vdd), .sel(start_event), .y(running_d));
    mux2_1 u_start_mux_clear(.in0(clear_after_hit), .in1(gnd), .sel(start_event), .y(clear_d));
    mux2_1 u_start_mux_game_over(.in0(game_over_after_hit), .in1(gnd), .sel(start_event), .y(game_over_d));

    dff_async_reset #(.RESET_VALUE(1'b0)) u_running_ff(.clk(clk), .reset(reset), .d(running_d), .q(running));
    dff_async_reset #(.RESET_VALUE(1'b0)) u_clear_ff(.clk(clk), .reset(reset), .d(clear_d), .q(clear));
    dff_async_reset #(.RESET_VALUE(1'b0)) u_game_over_ff(.clk(clk), .reset(reset), .d(game_over_d), .q(game_over));
endmodule

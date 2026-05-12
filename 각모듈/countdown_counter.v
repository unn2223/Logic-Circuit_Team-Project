`timescale 1ns/1ps

module countdown_counter(
    input  wire       clk,
    input  wire       reset,
    input  wire       start_event,
    input  wire       tick_event,
    input  wire       safe_event,
    input  wire       count_is_1,
    output wire [1:0] count
);
    supply1 vdd;

    wire n_count0;
    wire n_count_is_1;
    wire decrement_event;
    wire reload_event;
    wire dec1;
    wire [1:0] after_tick;
    wire [1:0] d;

    not u_not_count0(n_count0, count[0]);
    not u_not_count_is_1(n_count_is_1, count_is_1);
    and u_and_decrement_event(decrement_event, tick_event, n_count_is_1);
    or  u_or_reload_event(reload_event, start_event, safe_event);

    xor u_xor_dec1(dec1, count[1], n_count0);

    mux2_1 u_tick_mux0(.in0(count[0]), .in1(n_count0), .sel(decrement_event), .y(after_tick[0]));
    mux2_1 u_tick_mux1(.in0(count[1]), .in1(dec1), .sel(decrement_event), .y(after_tick[1]));

    mux2_1 u_reload_mux0(.in0(after_tick[0]), .in1(vdd), .sel(reload_event), .y(d[0]));
    mux2_1 u_reload_mux1(.in0(after_tick[1]), .in1(vdd), .sel(reload_event), .y(d[1]));

    dff_async_reset #(.RESET_VALUE(1'b1)) u_count_ff0(.clk(clk), .reset(reset), .d(d[0]), .q(count[0]));
    dff_async_reset #(.RESET_VALUE(1'b1)) u_count_ff1(.clk(clk), .reset(reset), .d(d[1]), .q(count[1]));
endmodule

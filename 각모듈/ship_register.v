`timescale 1ns/1ps

module ship_register(
    input  wire       clk,
    input  wire       reset,
    input  wire       start_event,
    input  wire       move_event,
    input  wire [2:0] next_ship,
    output wire [2:0] ship
);
    supply0 gnd;
    supply1 vdd;

    wire [2:0] after_move;
    wire [2:0] d;

    mux2_1 u_move_mux0(.in0(ship[0]), .in1(next_ship[0]), .sel(move_event), .y(after_move[0]));
    mux2_1 u_move_mux1(.in0(ship[1]), .in1(next_ship[1]), .sel(move_event), .y(after_move[1]));
    mux2_1 u_move_mux2(.in0(ship[2]), .in1(next_ship[2]), .sel(move_event), .y(after_move[2]));

    mux2_1 u_start_mux0(.in0(after_move[0]), .in1(gnd), .sel(start_event), .y(d[0]));
    mux2_1 u_start_mux1(.in0(after_move[1]), .in1(vdd), .sel(start_event), .y(d[1]));
    mux2_1 u_start_mux2(.in0(after_move[2]), .in1(gnd), .sel(start_event), .y(d[2]));

    dff_async_reset #(.RESET_VALUE(1'b0)) u_ship_ff0(.clk(clk), .reset(reset), .d(d[0]), .q(ship[0]));
    dff_async_reset #(.RESET_VALUE(1'b1)) u_ship_ff1(.clk(clk), .reset(reset), .d(d[1]), .q(ship[1]));
    dff_async_reset #(.RESET_VALUE(1'b0)) u_ship_ff2(.clk(clk), .reset(reset), .d(d[2]), .q(ship[2]));
endmodule

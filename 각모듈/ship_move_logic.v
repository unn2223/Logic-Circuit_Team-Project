`timescale 1ns/1ps

module ship_move_logic(
    input  wire [2:0] ship,
    input  wire [1:0] cmd,
    output wire [2:0] next_ship,
    output wire [2:0] stay_next,
    output wire [2:0] left_next,
    output wire [2:0] right_next
);
    supply0 gnd;

    buf u_buf_stay0(stay_next[0], ship[0]);
    buf u_buf_stay1(stay_next[1], ship[1]);
    buf u_buf_stay2(stay_next[2], ship[2]);

    or  u_or_left0(left_next[0], ship[0], ship[1]);
    buf u_buf_left1(left_next[1], ship[2]);
    buf u_buf_left2(left_next[2], gnd);

    buf u_buf_right0(right_next[0], gnd);
    buf u_buf_right1(right_next[1], ship[0]);
    or  u_or_right2(right_next[2], ship[1], ship[2]);

    mux3_3 u_ship_move_mux(
        .in0(stay_next),
        .in1(left_next),
        .in2(right_next),
        .sel(cmd),
        .y(next_ship)
    );
endmodule

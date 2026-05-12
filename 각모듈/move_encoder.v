`timescale 1ns/1ps

// ------------------------------------------------------------
// Encoder: LEFT/RIGHT input -> movement command
// cmd = 00: STAY, 01: LEFT, 10: RIGHT, 11: treated as STAY
// ------------------------------------------------------------
module move_encoder(
    input  wire left,
    input  wire right,
    output wire move_left,
    output wire move_right,
    output wire move_stay,
    output wire [1:0] cmd
);
    wire n_left;
    wire n_right;
    wire n_move_left;
    wire n_move_right;

    not u_not_left(n_left, left);
    not u_not_right(n_right, right);

    and u_and_move_left(move_left, left, n_right);
    and u_and_move_right(move_right, n_left, right);

    not u_not_move_left(n_move_left, move_left);
    not u_not_move_right(n_move_right, move_right);
    and u_and_move_stay(move_stay, n_move_left, n_move_right);

    buf u_buf_cmd0(cmd[0], move_left);
    buf u_buf_cmd1(cmd[1], move_right);
endmodule

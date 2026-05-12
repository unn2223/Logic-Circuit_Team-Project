`timescale 1ns/1ps

module mux2_1(
    input  wire in0,
    input  wire in1,
    input  wire sel,
    output wire y
);
    wire n_sel;
    wire a0;
    wire a1;

    not u_not_sel(n_sel, sel);
    and u_and_0(a0, in0, n_sel);
    and u_and_1(a1, in1, sel);
    or  u_or_y(y, a0, a1);
endmodule

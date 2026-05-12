`timescale 1ns/1ps

// ------------------------------------------------------------
// 3-bit 3-way MUX
// sel = 00: in0, 01: in1, 10: in2, 11: in0
// ------------------------------------------------------------
module mux3_3(
    input  wire [2:0] in0,
    input  wire [2:0] in1,
    input  wire [2:0] in2,
    input  wire [1:0] sel,
    output wire [2:0] y
);
    wire n_sel0;
    wire n_sel1;
    wire sel_in0_00;
    wire sel_in0_11;
    wire sel_in0;
    wire sel_in1;
    wire sel_in2;
    wire a0_0;
    wire a1_0;
    wire a2_0;
    wire o01_0;
    wire a0_1;
    wire a1_1;
    wire a2_1;
    wire o01_1;
    wire a0_2;
    wire a1_2;
    wire a2_2;
    wire o01_2;

    not u_not_sel0(n_sel0, sel[0]);
    not u_not_sel1(n_sel1, sel[1]);

    and u_and_sel_in0_00(sel_in0_00, n_sel1, n_sel0);
    and u_and_sel_in0_11(sel_in0_11, sel[1], sel[0]);
    or  u_or_sel_in0(sel_in0, sel_in0_00, sel_in0_11);
    and u_and_sel_in1(sel_in1, n_sel1, sel[0]);
    and u_and_sel_in2(sel_in2, sel[1], n_sel0);

    and u_and_in0_0(a0_0, in0[0], sel_in0);
    and u_and_in1_0(a1_0, in1[0], sel_in1);
    and u_and_in2_0(a2_0, in2[0], sel_in2);
    or  u_or_01_0(o01_0, a0_0, a1_0);
    or  u_or_y_0(y[0], o01_0, a2_0);

    and u_and_in0_1(a0_1, in0[1], sel_in0);
    and u_and_in1_1(a1_1, in1[1], sel_in1);
    and u_and_in2_1(a2_1, in2[1], sel_in2);
    or  u_or_01_1(o01_1, a0_1, a1_1);
    or  u_or_y_1(y[1], o01_1, a2_1);

    and u_and_in0_2(a0_2, in0[2], sel_in0);
    and u_and_in1_2(a1_2, in1[2], sel_in1);
    and u_and_in2_2(a2_2, in2[2], sel_in2);
    or  u_or_01_2(o01_2, a0_2, a1_2);
    or  u_or_y_2(y[2], o01_2, a2_2);
endmodule

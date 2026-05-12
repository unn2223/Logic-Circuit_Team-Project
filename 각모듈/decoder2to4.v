`timescale 1ns/1ps

module decoder2to4(
    input  wire [1:0] in,
    output wire [3:0] d
);
    wire n_in0;
    wire n_in1;

    not u_not_in0(n_in0, in[0]);
    not u_not_in1(n_in1, in[1]);

    and u_and_d0(d[0], n_in1, n_in0);
    and u_and_d1(d[1], n_in1, in[0]);
    and u_and_d2(d[2], in[1], n_in0);
    and u_and_d3(d[3], in[1], in[0]);
endmodule

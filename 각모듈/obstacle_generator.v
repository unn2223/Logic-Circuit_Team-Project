`timescale 1ns/1ps

module obstacle_generator(
    input  wire [1:0] pattern,
    output wire [2:0] obs,
    output wire [3:0] dec
);
    decoder2to4 u_decoder(.in(pattern), .d(dec));

    or  u_or_obs0(obs[0], dec[0], dec[3]);
    buf u_buf_obs1(obs[1], dec[2]);
    buf u_buf_obs2(obs[2], dec[1]);
endmodule

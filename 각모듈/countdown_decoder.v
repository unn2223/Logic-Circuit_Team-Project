`timescale 1ns/1ps

module countdown_decoder(
    input  wire [1:0] count,
    output wire       count_3,
    output wire       count_2,
    output wire       count_1,
    output wire       count_is_1
);
    wire n_count0;
    wire n_count1;

    not u_not_count0(n_count0, count[0]);
    not u_not_count1(n_count1, count[1]);

    and u_and_count3(count_3, count[1], count[0]);
    and u_and_count2(count_2, count[1], n_count0);
    and u_and_count1(count_1, n_count1, count[0]);
    buf u_buf_count_is_1(count_is_1, count_1);
endmodule

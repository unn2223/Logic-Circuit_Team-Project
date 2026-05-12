`timescale 1ns/1ps

module collision_detector(
    input  wire       running,
    input  wire       eval_event,
    input  wire [2:0] ship,
    input  wire [2:0] obs,
    output wire       hit_raw,
    output wire       hit_event
);
    wire hit0;
    wire hit1;
    wire hit2;
    wire hit01;

    and u_and_hit0(hit0, ship[0], obs[0]);
    and u_and_hit1(hit1, ship[1], obs[1]);
    and u_and_hit2(hit2, ship[2], obs[2]);
    or  u_or_hit01(hit01, hit0, hit1);
    or  u_or_hit_raw(hit_raw, hit01, hit2);

    and u_and_hit_event(hit_event, running, eval_event, hit_raw);
endmodule

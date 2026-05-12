`timescale 1ns/1ps

module hormuz_game_top(
    input  wire clk,
    input  wire reset,
    input  wire start,
    input  wire left,
    input  wire right,
    input  wire tick,

    output wire       running,
    output wire       clear,
    output wire       game_over,

    output wire [2:0] ship,
    output wire [2:0] obs,
    output wire [1:0] pattern,
    output wire [1:0] count,

    output wire       count_3,
    output wire       count_2,
    output wire       count_1,

    output wire       hit_raw,
    output wire       hit_event,
    output wire       safe_event,
    output wire       eval_event,

    output wire       move_left,
    output wire       move_right,
    output wire       move_stay,

    output wire       last_pattern,
    output wire [3:0] obstacle_decoder_out
);
    wire [1:0] cmd;
    wire [2:0] next_ship;
    wire [2:0] stay_next;
    wire [2:0] left_next;
    wire [2:0] right_next;

    wire n_running;
    wire n_hit_raw;
    wire start_event;
    wire move_event;
    wire tick_event;
    wire count_is_1;
    wire clear_event;

    wire move_any;
    wire pattern_inc_event;

    not u_not_running(n_running, running);
    and u_and_start_event(start_event, start, n_running);

    move_encoder u_move_encoder(
        .left(left),
        .right(right),
        .move_left(move_left),
        .move_right(move_right),
        .move_stay(move_stay),
        .cmd(cmd)
    );

    and u_and_tick_event(tick_event, running, tick);
    or  u_or_move_any(move_any, move_left, move_right);
    and u_and_move_event(move_event, running, move_any);

    and u_and_eval_event(eval_event, tick_event, count_is_1);

    ship_move_logic u_ship_move_logic(
        .ship(ship),
        .cmd(cmd),
        .next_ship(next_ship),
        .stay_next(stay_next),
        .left_next(left_next),
        .right_next(right_next)
    );

    ship_register u_ship_register(
        .clk(clk),
        .reset(reset),
        .start_event(start_event),
        .move_event(move_event),
        .next_ship(next_ship),
        .ship(ship)
    );

    obstacle_generator u_obstacle_generator(
        .pattern(pattern),
        .obs(obs),
        .dec(obstacle_decoder_out)
    );

    collision_detector u_collision_detector(
        .running(running),
        .eval_event(eval_event),
        .ship(ship),
        .obs(obs),
        .hit_raw(hit_raw),
        .hit_event(hit_event)
    );

    not u_not_hit_raw(n_hit_raw, hit_raw);
    and u_and_safe_event(safe_event, eval_event, n_hit_raw);
    and u_and_clear_event(clear_event, safe_event, last_pattern);

    countdown_decoder u_countdown_decoder(
        .count(count),
        .count_3(count_3),
        .count_2(count_2),
        .count_1(count_1),
        .count_is_1(count_is_1)
    );

    countdown_counter u_countdown_counter(
        .clk(clk),
        .reset(reset),
        .start_event(start_event),
        .tick_event(tick_event),
        .safe_event(safe_event),
        .count_is_1(count_is_1),
        .count(count)
    );

    obstacle_counter u_obstacle_counter(
        .clk(clk),
        .reset(reset),
        .start_event(start_event),
        .safe_event(safe_event),
        .pattern(pattern),
        .last_pattern(last_pattern),
        .pattern_inc_event(pattern_inc_event)
    );

    game_control u_game_control(
        .clk(clk),
        .reset(reset),
        .start_event(start_event),
        .hit_event(hit_event),
        .clear_event(clear_event),
        .running(running),
        .clear(clear),
        .game_over(game_over)
    );
endmodule

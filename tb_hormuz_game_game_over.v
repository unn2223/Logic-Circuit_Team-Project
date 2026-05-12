`timescale 1ns/1ps

module tb_hormuz_game_game_over;
    reg clk;
    reg reset;
    reg start;
    reg left;
    reg right;

    wire       running;
    wire       clear;
    wire       game_over;
    wire [2:0] ship;
    wire [2:0] obs;
    wire [1:0] pattern;
    wire [1:0] count;
    wire       count_3;
    wire       count_2;
    wire       count_1;
    wire       hit_raw;
    wire       hit_event;
    wire       safe_event;
    wire       eval_event;
    wire       move_left;
    wire       move_right;
    wire       move_stay;
    wire       last_pattern;
    wire [3:0] obstacle_decoder_out;

    hormuz_game_top dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .left(left),
        .right(right),
        .running(running),
        .clear(clear),
        .game_over(game_over),
        .ship(ship),
        .obs(obs),
        .pattern(pattern),
        .count(count),
        .count_3(count_3),
        .count_2(count_2),
        .count_1(count_1),
        .hit_raw(hit_raw),
        .hit_event(hit_event),
        .safe_event(safe_event),
        .eval_event(eval_event),
        .move_left(move_left),
        .move_right(move_right),
        .move_stay(move_stay),
        .last_pattern(last_pattern),
        .obstacle_decoder_out(obstacle_decoder_out)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task check;
        input condition;
        input [8*128-1:0] message;
        begin
            if (!condition) begin
                $display("[FAIL] %0s", message);
                $display("       t=%0t running=%0b clear=%0b game_over=%0b pattern=%0d count=%0d ship=%03b obs=%03b hit_raw=%0b hit_event=%0b eval_event=%0b",
                         $time, running, clear, game_over, pattern, count, ship, obs,
                         hit_raw, hit_event, eval_event);
                $finish;
            end
        end
    endtask

    task clear_inputs;
        begin
            start = 1'b0;
            left  = 1'b0;
            right = 1'b0;
        end
    endtask

    task apply_reset;
        begin
            clear_inputs();
            reset = 1'b1;
            repeat (2) @(posedge clk);
            #1 reset = 1'b0;
            @(posedge clk);
            #1;
        end
    endtask

    task pulse_start;
        begin
            start = 1'b1;
            @(posedge clk);
            #1 start = 1'b0;
            @(posedge clk);
            #1;
        end
    endtask

    task advance_one_clock;
        begin
            @(posedge clk);
            #1;
        end
    endtask

    initial begin
        reset = 1'b0;
        clear_inputs();

        apply_reset();
        pulse_start();

        check(running == 1'b1, "start should make running high");
        check(clear == 1'b0, "clear should be low after start");
        check(game_over == 1'b0, "game_over should be low after start");
        check(pattern == 2'b00, "first obstacle pattern should be 0");
        check(obs == 3'b001, "first obstacle should block lane 0");
        check(ship == 3'b010, "ship should start at center lane");
        check(count == 2'b11, "count should start at 3");

        left = 1'b1;
        advance_one_clock();
        left = 1'b0;
        check(ship == 3'b001, "ship should move into blocked lane 0");
        check(count == 2'b10, "first clock should decrement count to 2");
        check(game_over == 1'b0, "first clock should not end game");

        advance_one_clock();
        check(count == 2'b01, "second clock should decrement count to 1");
        check(ship == 3'b001, "ship should stay in blocked lane before evaluation");
        check(hit_raw == 1'b1, "ship and obstacle should overlap before game_over clock");
        check(eval_event == 1'b1, "evaluation event should assert when count is 1");
        check(hit_event == 1'b1, "hit_event should assert while evaluating collision");
        check(game_over == 1'b0, "game should still be running before game_over clock");

        advance_one_clock();

        check(game_over == 1'b1, "collision should assert game_over");
        check(running == 1'b0, "collision should stop running");
        check(clear == 1'b0, "collision should not assert clear");

        $display("[PASS] game_over scenario: pattern=%0d count=%0d ship=%03b obs=%03b",
                 pattern, count, ship, obs);
        $finish;
    end
endmodule

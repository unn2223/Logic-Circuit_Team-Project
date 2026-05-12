`timescale 1ns/1ps

module tb_hormuz_game_success;
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

    function integer ship_lane;
        input [2:0] value;
        begin
            case (value)
                3'b001: ship_lane = 0;
                3'b010: ship_lane = 1;
                3'b100: ship_lane = 2;
                default:  ship_lane = -1;
            endcase
        end
    endfunction

    task check;
        input condition;
        input [8*128-1:0] message;
        begin
            if (!condition) begin
                $display("[FAIL] %0s", message);
                $display("       t=%0t running=%0b clear=%0b game_over=%0b pattern=%0d count=%0d ship=%03b obs=%03b hit_raw=%0b",
                         $time, running, clear, game_over, pattern, count, ship, obs, hit_raw);
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
            check(running == 1'b1, "start should make running high");
            check(ship == 3'b010, "ship should start at center lane");
        end
    endtask

    task pulse_left;
        begin
            left  = 1'b0;
            right = 1'b0;
            @(negedge clk);
            left  = 1'b1;
            @(posedge clk);
            #1;
            left = 1'b0;
        end
    endtask

    task pulse_right;
        begin
            left  = 1'b0;
            right = 1'b0;
            @(negedge clk);
            right = 1'b1;
            @(posedge clk);
            #1;
            right = 1'b0;
        end
    endtask

    task move_one_step_toward;
        input integer target_lane;
        integer current_lane;
        begin
            current_lane = ship_lane(ship);

            if (current_lane > target_lane) begin
                pulse_left();
            end else if (current_lane < target_lane) begin
                pulse_right();
            end
        end
    endtask

    task advance_one_clock_toward;
        input integer target_lane;
        integer current_lane;
        begin
            current_lane = ship_lane(ship);
            left  = 1'b0;
            right = 1'b0;

            @(negedge clk);

            if (current_lane > target_lane) begin
                left = 1'b1;
            end else if (current_lane < target_lane) begin
                right = 1'b1;
            end

            @(posedge clk);
            #1;
            left  = 1'b0;
            right = 1'b0;
        end
    endtask

    task move_to_lane;
        input integer target_lane;
        integer current_lane;
        begin
            current_lane = ship_lane(ship);

            while (current_lane > target_lane) begin
                pulse_left();
                current_lane = ship_lane(ship);
            end

            while (current_lane < target_lane) begin
                pulse_right();
                current_lane = ship_lane(ship);
            end

            check(current_lane == target_lane, "ship should reach target lane");
        end
    endtask

    task play_safe_pattern;
        input integer safe_lane;
        reg [1:0] before_pattern;
        begin
            before_pattern = pattern;

            advance_one_clock_toward(safe_lane);
            check(game_over == 1'b0, "first countdown clock should not produce game_over");

            advance_one_clock_toward(safe_lane);
            check(count == 2'b01, "count should be 1 before evaluation");

            check(ship_lane(ship) == safe_lane, "ship should reach safe lane before evaluation");
            check((ship & obs) == 3'b000, "selected lane must be safe before evaluation");

            advance_one_clock_toward(safe_lane);
            check(game_over == 1'b0, "safe pattern should not produce game_over");

            $display("[SAFE] pattern=%0d lane=%0d",
                     before_pattern, safe_lane);
        end
    endtask

    initial begin
        reset = 1'b0;
        clear_inputs();

        apply_reset();
        pulse_start();

        play_safe_pattern(2);
        play_safe_pattern(1);
        play_safe_pattern(2);
        play_safe_pattern(2);

        check(clear == 1'b1, "success scenario should assert clear");
        check(running == 1'b0, "success scenario should stop running");
        check(game_over == 1'b0, "success scenario should not assert game_over");

        $display("[PASS] success scenario: clear=%0b running=%0b game_over=%0b",
                 clear, running, game_over);
        $finish;
    end
endmodule

`timescale 1ns/1ps

module tb_collision_detector;
    reg running;
    reg eval_event;
    reg [2:0] ship;
    reg [2:0] obs;
    wire hit_raw;
    wire hit_event;

    integer errors;

    collision_detector dut(
        .running(running),
        .eval_event(eval_event),
        .ship(ship),
        .obs(obs),
        .hit_raw(hit_raw),
        .hit_event(hit_event)
    );

    task check;
        input in_running;
        input in_eval_event;
        input [2:0] in_ship;
        input [2:0] in_obs;
        input exp_hit_raw;
        input exp_hit_event;
        begin
            running = in_running;
            eval_event = in_eval_event;
            ship = in_ship;
            obs = in_obs;
            #1;

            if (hit_raw !== exp_hit_raw || hit_event !== exp_hit_event) begin
                $display("FAIL collision_detector running=%b eval_event=%b ship=%b obs=%b: hit_raw=%b hit_event=%b",
                         running, eval_event, ship, obs, hit_raw, hit_event);
                $display("  expected: hit_raw=%b hit_event=%b", exp_hit_raw, exp_hit_event);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0;
        running = 1'b0;
        eval_event = 1'b0;
        ship = 3'b000;
        obs = 3'b000;

        check(1'b0, 1'b0, 3'b001, 3'b001, 1'b1, 1'b0);
        check(1'b1, 1'b0, 3'b010, 3'b010, 1'b1, 1'b0);
        check(1'b0, 1'b1, 3'b100, 3'b100, 1'b1, 1'b0);
        check(1'b1, 1'b1, 3'b100, 3'b001, 1'b0, 1'b0);
        check(1'b1, 1'b1, 3'b010, 3'b010, 1'b1, 1'b1);
        check(1'b1, 1'b1, 3'b101, 3'b001, 1'b1, 1'b1);

        if (errors == 0) begin
            $display("PASS tb_collision_detector");
        end else begin
            $display("FAIL tb_collision_detector errors=%0d", errors);
        end
        $finish;
    end
endmodule

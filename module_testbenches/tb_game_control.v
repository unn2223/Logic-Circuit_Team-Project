`timescale 1ns/1ps

module tb_game_control;
    reg clk;
    reg reset;
    reg start_event;
    reg hit_event;
    reg clear_event;
    wire running;
    wire clear;
    wire game_over;

    integer errors;

    game_control dut(
        .clk(clk),
        .reset(reset),
        .start_event(start_event),
        .hit_event(hit_event),
        .clear_event(clear_event),
        .running(running),
        .clear(clear),
        .game_over(game_over)
    );

    always #5 clk = ~clk;

    task expect_state;
        input exp_running;
        input exp_clear;
        input exp_game_over;
        begin
            #1;
            if (running !== exp_running ||
                clear !== exp_clear ||
                game_over !== exp_game_over) begin
                $display("FAIL game_control: running=%b clear=%b game_over=%b",
                         running, clear, game_over);
                $display("  expected: running=%b clear=%b game_over=%b",
                         exp_running, exp_clear, exp_game_over);
                errors = errors + 1;
            end
        end
    endtask

    task tick;
        begin
            @(posedge clk);
            #1;
        end
    endtask

    initial begin
        errors = 0;
        clk = 1'b0;
        reset = 1'b0;
        start_event = 1'b0;
        hit_event = 1'b0;
        clear_event = 1'b0;

        #1;
        reset = 1'b1;
        expect_state(1'b0, 1'b0, 1'b0);
        reset = 1'b0;

        start_event = 1'b1;
        tick();
        expect_state(1'b1, 1'b0, 1'b0);

        start_event = 1'b0;
        tick();
        expect_state(1'b1, 1'b0, 1'b0);

        hit_event = 1'b1;
        tick();
        expect_state(1'b0, 1'b0, 1'b1);

        hit_event = 1'b0;
        start_event = 1'b1;
        tick();
        expect_state(1'b1, 1'b0, 1'b0);

        start_event = 1'b0;
        clear_event = 1'b1;
        tick();
        expect_state(1'b0, 1'b1, 1'b0);

        clear_event = 1'b0;
        tick();
        expect_state(1'b0, 1'b1, 1'b0);

        start_event = 1'b1;
        tick();
        expect_state(1'b1, 1'b0, 1'b0);

        start_event = 1'b1;
        hit_event = 1'b1;
        clear_event = 1'b1;
        tick();
        expect_state(1'b1, 1'b0, 1'b0);

        start_event = 1'b0;
        hit_event = 1'b0;
        clear_event = 1'b0;
        reset = 1'b1;
        #1;
        expect_state(1'b0, 1'b0, 1'b0);
        reset = 1'b0;

        if (errors == 0) begin
            $display("PASS tb_game_control");
        end else begin
            $display("FAIL tb_game_control errors=%0d", errors);
        end
        $finish;
    end
endmodule

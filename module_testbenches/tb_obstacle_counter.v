`timescale 1ns/1ps

module tb_obstacle_counter;
    reg clk;
    reg reset;
    reg start_event;
    reg safe_event;
    wire [1:0] pattern;
    wire last_pattern;
    wire pattern_inc_event;

    integer errors;

    obstacle_counter dut(
        .clk(clk),
        .reset(reset),
        .start_event(start_event),
        .safe_event(safe_event),
        .pattern(pattern),
        .last_pattern(last_pattern),
        .pattern_inc_event(pattern_inc_event)
    );

    always #5 clk = ~clk;

    task expect_state;
        input [1:0] exp_pattern;
        input exp_last_pattern;
        input exp_pattern_inc_event;
        begin
            #1;
            if (pattern !== exp_pattern ||
                last_pattern !== exp_last_pattern ||
                pattern_inc_event !== exp_pattern_inc_event) begin
                $display("FAIL obstacle_counter: pattern=%b last=%b inc=%b",
                         pattern, last_pattern, pattern_inc_event);
                $display("  expected: pattern=%b last=%b inc=%b",
                         exp_pattern, exp_last_pattern, exp_pattern_inc_event);
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
        safe_event = 1'b0;

        #1;
        reset = 1'b1;
        expect_state(2'b00, 1'b0, 1'b0);
        reset = 1'b0;

        safe_event = 1'b1;
        expect_state(2'b00, 1'b0, 1'b1);
        tick();
        expect_state(2'b01, 1'b0, 1'b1);

        tick();
        expect_state(2'b10, 1'b0, 1'b1);

        tick();
        expect_state(2'b11, 1'b1, 1'b0);

        tick();
        expect_state(2'b11, 1'b1, 1'b0);

        start_event = 1'b1;
        safe_event = 1'b1;
        tick();
        expect_state(2'b00, 1'b0, 1'b1);

        start_event = 1'b0;
        safe_event = 1'b0;
        tick();
        expect_state(2'b00, 1'b0, 1'b0);

        reset = 1'b1;
        #1;
        expect_state(2'b00, 1'b0, 1'b0);
        reset = 1'b0;

        if (errors == 0) begin
            $display("PASS tb_obstacle_counter");
        end else begin
            $display("FAIL tb_obstacle_counter errors=%0d", errors);
        end
        $finish;
    end
endmodule

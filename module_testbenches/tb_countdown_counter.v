`timescale 1ns/1ps

module tb_countdown_counter;
    reg clk;
    reg reset;
    reg start_event;
    reg step_event;
    reg safe_event;
    reg count_is_1;
    wire [1:0] count;

    integer errors;

    countdown_counter dut(
        .clk(clk),
        .reset(reset),
        .start_event(start_event),
        .step_event(step_event),
        .safe_event(safe_event),
        .count_is_1(count_is_1),
        .count(count)
    );

    always #5 clk = ~clk;

    task expect_count;
        input [1:0] exp_count;
        begin
            #1;
            if (count !== exp_count) begin
                $display("FAIL countdown_counter: count=%b expected=%b", count, exp_count);
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
        step_event = 1'b0;
        safe_event = 1'b0;
        count_is_1 = 1'b0;

        #1;
        reset = 1'b1;
        expect_count(2'b11);
        reset = 1'b0;

        step_event = 1'b1;
        count_is_1 = 1'b0;
        tick();
        expect_count(2'b10);

        step_event = 1'b1;
        count_is_1 = 1'b0;
        tick();
        expect_count(2'b01);

        step_event = 1'b1;
        count_is_1 = 1'b1;
        tick();
        expect_count(2'b01);

        safe_event = 1'b1;
        step_event = 1'b0;
        count_is_1 = 1'b1;
        tick();
        expect_count(2'b11);

        safe_event = 1'b0;
        step_event = 1'b1;
        count_is_1 = 1'b0;
        tick();
        expect_count(2'b10);

        start_event = 1'b1;
        step_event = 1'b1;
        count_is_1 = 1'b0;
        tick();
        expect_count(2'b11);

        start_event = 1'b0;
        step_event = 1'b0;
        safe_event = 1'b0;
        reset = 1'b1;
        #1;
        expect_count(2'b11);
        reset = 1'b0;

        if (errors == 0) begin
            $display("PASS tb_countdown_counter");
        end else begin
            $display("FAIL tb_countdown_counter errors=%0d", errors);
        end
        $finish;
    end
endmodule

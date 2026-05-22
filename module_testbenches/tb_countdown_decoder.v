`timescale 1ns/1ps

module tb_countdown_decoder;
    reg [1:0] count;
    wire count_3;
    wire count_2;
    wire count_1;
    wire count_is_1;

    integer errors;

    countdown_decoder dut(
        .count(count),
        .count_3(count_3),
        .count_2(count_2),
        .count_1(count_1),
        .count_is_1(count_is_1)
    );

    task check;
        input [1:0] in_count;
        input exp_count_3;
        input exp_count_2;
        input exp_count_1;
        input exp_count_is_1;
        begin
            count = in_count;
            #1;

            if (count_3 !== exp_count_3 ||
                count_2 !== exp_count_2 ||
                count_1 !== exp_count_1 ||
                count_is_1 !== exp_count_is_1) begin
                $display("FAIL countdown_decoder count=%b: count_3=%b count_2=%b count_1=%b count_is_1=%b",
                         count, count_3, count_2, count_1, count_is_1);
                $display("  expected: count_3=%b count_2=%b count_1=%b count_is_1=%b",
                         exp_count_3, exp_count_2, exp_count_1, exp_count_is_1);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0;
        count = 2'b00;

        check(2'b00, 1'b0, 1'b0, 1'b0, 1'b0);
        check(2'b01, 1'b0, 1'b0, 1'b1, 1'b1);
        check(2'b10, 1'b0, 1'b1, 1'b0, 1'b0);
        check(2'b11, 1'b1, 1'b0, 1'b0, 1'b0);

        if (errors == 0) begin
            $display("PASS tb_countdown_decoder");
        end else begin
            $display("FAIL tb_countdown_decoder errors=%0d", errors);
        end
        $finish;
    end
endmodule

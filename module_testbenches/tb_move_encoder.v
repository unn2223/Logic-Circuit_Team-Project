`timescale 1ns/1ps

module tb_move_encoder;
    reg left;
    reg right;
    wire move_left;
    wire move_right;
    wire move_stay;
    wire [1:0] cmd;

    integer errors;

    move_encoder dut(
        .left(left),
        .right(right),
        .move_left(move_left),
        .move_right(move_right),
        .move_stay(move_stay),
        .cmd(cmd)
    );

    task check;
        input in_left;
        input in_right;
        input exp_move_left;
        input exp_move_right;
        input exp_move_stay;
        input [1:0] exp_cmd;
        begin
            left = in_left;
            right = in_right;
            #1;

            if (move_left !== exp_move_left ||
                move_right !== exp_move_right ||
                move_stay !== exp_move_stay ||
                cmd !== exp_cmd) begin
                $display("FAIL move_encoder left=%b right=%b: move_left=%b move_right=%b move_stay=%b cmd=%b",
                         left, right, move_left, move_right, move_stay, cmd);
                $display("  expected: move_left=%b move_right=%b move_stay=%b cmd=%b",
                         exp_move_left, exp_move_right, exp_move_stay, exp_cmd);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0;
        left = 1'b0;
        right = 1'b0;

        check(1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 2'b00);
        check(1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 2'b01);
        check(1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 2'b10);
        check(1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 2'b00);

        if (errors == 0) begin
            $display("PASS tb_move_encoder");
        end else begin
            $display("FAIL tb_move_encoder errors=%0d", errors);
        end
        $finish;
    end
endmodule

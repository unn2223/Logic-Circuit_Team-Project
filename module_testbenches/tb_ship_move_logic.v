`timescale 1ns/1ps

module tb_ship_move_logic;
    reg [2:0] ship;
    reg [1:0] cmd;
    wire [2:0] next_ship;
    wire [2:0] stay_next;
    wire [2:0] left_next;
    wire [2:0] right_next;

    integer errors;

    ship_move_logic dut(
        .ship(ship),
        .cmd(cmd),
        .next_ship(next_ship),
        .stay_next(stay_next),
        .left_next(left_next),
        .right_next(right_next)
    );

    task check;
        input [2:0] in_ship;
        input [1:0] in_cmd;
        input [2:0] exp_next_ship;
        input [2:0] exp_stay_next;
        input [2:0] exp_left_next;
        input [2:0] exp_right_next;
        begin
            ship = in_ship;
            cmd = in_cmd;
            #1;

            if (next_ship !== exp_next_ship ||
                stay_next !== exp_stay_next ||
                left_next !== exp_left_next ||
                right_next !== exp_right_next) begin
                $display("FAIL ship_move_logic ship=%b cmd=%b: next=%b stay=%b left=%b right=%b",
                         ship, cmd, next_ship, stay_next, left_next, right_next);
                $display("  expected: next=%b stay=%b left=%b right=%b",
                         exp_next_ship, exp_stay_next, exp_left_next, exp_right_next);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0;
        ship = 3'b010;
        cmd = 2'b00;

        check(3'b001, 2'b00, 3'b001, 3'b001, 3'b001, 3'b010);
        check(3'b001, 2'b01, 3'b001, 3'b001, 3'b001, 3'b010);
        check(3'b001, 2'b10, 3'b010, 3'b001, 3'b001, 3'b010);
        check(3'b001, 2'b11, 3'b001, 3'b001, 3'b001, 3'b010);

        check(3'b010, 2'b00, 3'b010, 3'b010, 3'b001, 3'b100);
        check(3'b010, 2'b01, 3'b001, 3'b010, 3'b001, 3'b100);
        check(3'b010, 2'b10, 3'b100, 3'b010, 3'b001, 3'b100);
        check(3'b010, 2'b11, 3'b010, 3'b010, 3'b001, 3'b100);

        check(3'b100, 2'b00, 3'b100, 3'b100, 3'b010, 3'b100);
        check(3'b100, 2'b01, 3'b010, 3'b100, 3'b010, 3'b100);
        check(3'b100, 2'b10, 3'b100, 3'b100, 3'b010, 3'b100);
        check(3'b100, 2'b11, 3'b100, 3'b100, 3'b010, 3'b100);

        if (errors == 0) begin
            $display("PASS tb_ship_move_logic");
        end else begin
            $display("FAIL tb_ship_move_logic errors=%0d", errors);
        end
        $finish;
    end
endmodule

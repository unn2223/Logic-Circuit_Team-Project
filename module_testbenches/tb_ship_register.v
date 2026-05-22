`timescale 1ns/1ps

module tb_ship_register;
    reg clk;
    reg reset;
    reg start_event;
    reg move_event;
    reg [2:0] next_ship;
    wire [2:0] ship;

    integer errors;

    ship_register dut(
        .clk(clk),
        .reset(reset),
        .start_event(start_event),
        .move_event(move_event),
        .next_ship(next_ship),
        .ship(ship)
    );

    always #5 clk = ~clk;

    task expect_ship;
        input [2:0] exp_ship;
        begin
            #1;
            if (ship !== exp_ship) begin
                $display("FAIL ship_register: ship=%b expected=%b", ship, exp_ship);
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
        move_event = 1'b0;
        next_ship = 3'b010;

        #1;
        reset = 1'b1;
        expect_ship(3'b010);
        reset = 1'b0;

        next_ship = 3'b100;
        move_event = 1'b0;
        tick();
        expect_ship(3'b010);

        move_event = 1'b1;
        next_ship = 3'b100;
        tick();
        expect_ship(3'b100);

        move_event = 1'b0;
        next_ship = 3'b001;
        tick();
        expect_ship(3'b100);

        start_event = 1'b1;
        move_event = 1'b1;
        next_ship = 3'b001;
        tick();
        expect_ship(3'b010);

        start_event = 1'b0;
        move_event = 1'b1;
        next_ship = 3'b001;
        tick();
        expect_ship(3'b001);

        reset = 1'b1;
        #1;
        expect_ship(3'b010);
        reset = 1'b0;

        if (errors == 0) begin
            $display("PASS tb_ship_register");
        end else begin
            $display("FAIL tb_ship_register errors=%0d", errors);
        end
        $finish;
    end
endmodule

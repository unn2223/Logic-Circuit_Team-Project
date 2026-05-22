`timescale 1ns/1ps

module tb_obstacle_generator;
    reg [1:0] pattern;
    wire [2:0] obs;
    wire [3:0] dec;

    integer errors;

    obstacle_generator dut(
        .pattern(pattern),
        .obs(obs),
        .dec(dec)
    );

    task check;
        input [1:0] in_pattern;
        input [2:0] exp_obs;
        input [3:0] exp_dec;
        begin
            pattern = in_pattern;
            #1;

            if (obs !== exp_obs || dec !== exp_dec) begin
                $display("FAIL obstacle_generator pattern=%b: obs=%b dec=%b", pattern, obs, dec);
                $display("  expected: obs=%b dec=%b", exp_obs, exp_dec);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0;
        pattern = 2'b00;

        check(2'b00, 3'b001, 4'b0001);
        check(2'b01, 3'b100, 4'b0010);
        check(2'b10, 3'b010, 4'b0100);
        check(2'b11, 3'b001, 4'b1000);

        if (errors == 0) begin
            $display("PASS tb_obstacle_generator");
        end else begin
            $display("FAIL tb_obstacle_generator errors=%0d", errors);
        end
        $finish;
    end
endmodule

`timescale 1ns/1ps

module tb_decoder2to4;
    reg [1:0] in;
    wire [3:0] d;

    integer errors;

    decoder2to4 dut(
        .in(in),
        .d(d)
    );

    task check;
        input [1:0] in_value;
        input [3:0] exp_d;
        begin
            in = in_value;
            #1;

            if (d !== exp_d) begin
                $display("FAIL decoder2to4 in=%b: d=%b expected=%b", in, d, exp_d);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0;
        in = 2'b00;

        check(2'b00, 4'b0001);
        check(2'b01, 4'b0010);
        check(2'b10, 4'b0100);
        check(2'b11, 4'b1000);

        if (errors == 0) begin
            $display("PASS tb_decoder2to4");
        end else begin
            $display("FAIL tb_decoder2to4 errors=%0d", errors);
        end
        $finish;
    end
endmodule

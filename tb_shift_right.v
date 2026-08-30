`timescale 1ns/1ps
module tb_shift_right;

    reg  [3:0] A;
    reg  [1:0] S;
    wire [3:0] R;

    shift_right DUT (
        .A (A),
        .S (S),
        .R (R)
    );

    initial begin
        $dumpfile("shift_right.vcd");
        $dumpvars(0, tb_shift_right);

        $monitor("t=%0t | A=%b S=%b -> R=%b", $time, A, S, R);

        A = 4'b1011;

        S = 2'b00; #10;  // esperado: R=1011 (sin desplazar)
        S = 2'b01; #10;  // esperado: R=0101
        S = 2'b10; #10;  // esperado: R=0010
        S = 2'b11; #10;  // esperado: R=0001

        $finish;
    end

endmodule

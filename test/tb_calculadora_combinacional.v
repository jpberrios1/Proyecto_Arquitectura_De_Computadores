`timescale 1ns/1ps
// ============================================================
// Testbench para calculadora_combinacional
// Prueba las 5 operaciones activas (001 a 101).
// No prueba 000 (Reinicio) porque ese caso lo maneja
// la Memoria MUX en el siguiente paso, no este bloque.
// ============================================================

module tb_calculadora_combinacional;

    reg  [3:0] A, B;
    reg        c2, c1, c0;
    wire [3:0] R;

    calculadora DUT (
        .A  (A),
        .B  (B),
        .c2 (c2),
        .c1 (c1),
        .c0 (c0),
        .R  (R)
    );

    wire signed [3:0] A_s = A;
    wire signed [3:0] B_s = B;
    wire signed [3:0] R_s = R;

    initial begin
        $dumpfile("calculadora_combinacional.vcd");
        $dumpvars(0, tb_calculadora_combinacional);

        $monitor("t=%0t | A=%b(%0d) B=%b(%0d) op=%b%b%b -> R=%b(%0d)",
                  $time, A, A_s, B, B_s, c2, c1, c0, R, R_s);

        A = 4'b0011; B = 4'b0101;         // A=3, B=5

        c2=0; c1=0; c0=1; #10;  // Suma: 3+5=8 -> esperado R=1000
        c2=0; c1=1; c0=0; #10;  // Resta A-B: 3-5=-2 -> esperado R=1110
        c2=0; c1=1; c0=1; #10;  // Resta inversa B-A: 5-3=2 -> esperado R=0010

        A = 4'b1011;              // A=1011, B[1:0] sigue siendo 01 (de B=0101)
        c2=1; c1=0; c0=0; #10;  // Shift left, S=B[1:0]=01 -> esperado R=0110
        c2=1; c1=0; c0=1; #10;  // Shift right, S=01 -> esperado R=0101

        $finish;
    end

endmodule

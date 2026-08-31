// R = A + B => A + B      (c2c1c0 = 001)
// R = A - B => A + B' + 1 (c2c1c0 = 010)
// R = B - A => A' + B + 1 (c2c1c0 = 011)
// (c2c1c0 = 000 es Reinicio, ese caso se maneja fuera de este bloque)

module alu_aritmetica (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       c1,
    input  wire       c0,
    output wire [3:0] R
);

    // Salidas del selector de operacion
    wire cin, invA, invB;

    selector_operacion_aritmetica SEL (
        .c1   (c1),
        .c0   (c0),
        .cin  (cin),
        .invA (invA),
        .invB (invB)
    );

    // Operandos ya pasados por el inversor
    wire [3:0] Ainv, Binv;

    inversor4Bit invA0 (.Inv(invA), .X(A[3:0]), .S(Ainv[3:0]));
    inversor4Bit invB0 (.Inv(invB), .X(B[3:0]), .S(Binv[3:0]));

    // Carry que se propaga entre bits para los full adder
    wire [3:0] carry;

    full_adder FA0 (
        .A    (Ainv[0]),
        .B    (Binv[0]),
        .Cin  (cin),       
        .S    (R[0]),
        .Cout (carry[0])
    );

    full_adder FA1 (
        .A (Ainv[1]),
        .B (Binv[1]),
        .Cin (carry[0]),
        .S (R[1]),
        .Cout (carry[1])
    );

    full_adder FA2 (
        .A (Ainv[2]),
        .B (Binv[2]),
        .Cin (carry[1]),
        .S (R[2]),
        .Cout (carry[2])
    );

    full_adder FA3 (
        .A (Ainv[3]),
        .B (Binv[3]),
        .Cin (carry[2]),
        .S (R[3]),
        .Cout ()
    );

endmodule

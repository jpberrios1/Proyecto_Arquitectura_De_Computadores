// ============================================================
// ALU aritmetica de 4 bits (Suma / Resta / Resta inversa)
// Integra: selector_operacion + inversor x8 + full_adder x4
//
// R = A + B          (c2c1c0 = 001)
// R = A - B          (c2c1c0 = 010)
// R = B - A          (c2c1c0 = 011)
// (c2c1c0 = 000 es Reinicio, ese caso se maneja fuera de este bloque)
// ============================================================

module alu_aritmetica (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       c2,
    input  wire       c1,
    input  wire       c0,
    output wire [3:0] R
);

    // Senales de control que salen del selector de operacion
    wire cin, invA, invB;

    // Operandos ya pasados por el inversor controlado
    wire [3:0] Ainv, Binv;

    // Carry que se propaga entre bits
    wire [3:0] carry;

    // ---- Selector de operacion (ya lo tienes hecho) ----
    selector_operacion SEL (
        .c2   (c2),
        .c1   (c1),
        .c0   (c0),
        .cin  (cin),
        .invA (invA),
        .invB (invB)
    );

    // ================= BIT 0 (ejemplo resuelto) =================
    inversor4Bit invA0 (.Inv(invA), .X(A[3:0]), .S(Ainv[3:0]));
    inversor4Bit invB0 (.Inv(invB), .X(B[3:0]), .S(Binv[3:0]));

    full_adder FA0 (
        .A    (Ainv[0]),
        .B    (Binv[0]),
        .Cin  (cin),        // el primer carry-in viene del selector
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

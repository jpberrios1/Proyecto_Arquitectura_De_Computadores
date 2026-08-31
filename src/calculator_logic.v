// ============================================================
// Calculadora - nucleo combinacional
// Junta la rama aritmetica y la rama de shifts, y decide
// cual resultado es el real segun c2:
//   c2=0 -> resultado aritmetico (suma / resta / resta inversa)
//   c2=1 -> resultado de shift (izquierda o derecha)
//
// Nota: el caso c2c1c0 = 000 (Reinicio) NO se maneja aqui.
// Ese caso se resuelve despues, en la "Memoria MUX" que decide
// entre este resultado R y forzar 0000 antes de guardar en
// el registro (eso viene en el siguiente paso del proyecto).
// ============================================================

module calculadora (
    input  wire [3:0] A,   // op1
    input  wire [3:0] B,   // segundo operando ya elegido (op2 o Rprev)
    input  wire       c2,
    input  wire       c1,
    input  wire       c0,
    output wire [3:0] R
);

    wire [3:0] R_arit, R_shift;

    // TODO: instancia alu_aritmetica
    //   entradas: A, B, c2, c1, c0  ->  salida: R_arit
    alu_aritmetica module1 (
        .A (A),
        .B (B),
        .c1 (c1),
        .c0 (c0),
        .R (R_arit)
    );

    shifter module2 (
        .A (A),
        .S (B[1:0]),
        .c0 (c0),
        .R (R_shift)
    );

    mux2_4bit module12 (
        .Selector (c2),
        .D0 (R_arit),
        .D1 (R_shift),
        .Y (R)
    );

endmodule
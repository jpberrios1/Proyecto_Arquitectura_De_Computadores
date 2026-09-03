// Calculator Logic
// Junta la rama aritmetica y la rama de shifts, y decide cual resultado es el real segun c2:
//   c2=0 -> resultado aritmetico (suma / resta / resta inversa)
//   c2=1 -> resultado de shift (izquierda o derecha)
//
// Nota: el caso c2c1c0 = 000 (Reinicio) NO se maneja aqui.

module shift_arithmetic_selector (
    input  wire [3:0] A,   // op1
    input  wire [3:0] B,   // segundo operando ya elegido (op2 o Rprev)
    input  wire       bit2,
    input  wire       bit1,
    input  wire       bit0,
    output wire [3:0] o_calculated
);

    wire [3:0] arithmetic_output;
    wire [3:0] shift_output;

    arithmetic_logic_unit arithmetic_module (
        .A    (A),
        .B    (B),
        .bit1 (bit1),
        .bit0 (bit0),
        .R    (arithmetic_output)
    );

    shifter shift_module (
        .A       (A),
        .S       (B[1:0]), //Solo necesita los 2 bits menos significativos de B para el shift
        .bit0    (bit0),
        .o_shift (shift_output)
    );

    mux_2_to_1_4bit mux_arith_shift (
        .select (bit2),
        .d0     (arithmetic_output),
        .d1     (shift_output),
        .y      (o_calculated)
    );

endmodule
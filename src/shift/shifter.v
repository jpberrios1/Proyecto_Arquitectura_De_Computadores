// ============================================================
// Shifter
// Combina shift_left y shift_right, y elige cual de los dos
// resultados es el real segun c0:
//   c0=0 -> shift left  (operacion 100)
//   c0=1 -> shift right (operacion 101)

module shifter (
    input  wire [3:0] A,
    input  wire [1:0] S,
    input  wire       c0,
    output wire [3:0] R
);

    wire [3:0] answer_shiftL, answer_shiftR;

    shift_left sl (
        .A (A),
        .S (S),
        .R (answer_shiftL)
    );

    shift_right sr (
        .A (A),
        .S (S),
        .R (answer_shiftR)
    );

    mux2_4bit choose_shift (
        .Selector (c0),
        .D0 (answer_shiftL),
        .D1 (answer_shiftR),
        .Y  (R)
    );

endmodule
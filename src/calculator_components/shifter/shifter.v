// Shifter
// Combina shift_left y shift_right, y elige cual de los dos
// resultados es el real segun c0:
//   c0=0 -> shift left  (operacion 100)
//   c0=1 -> shift right (operacion 101)

// Hace shift de A a la izquierda o derecha S veces, rellenando con ceros.
module shifter (
    input  wire [3:0] A,
    input  wire [1:0] S,
    input  wire       bit0,
    output wire [3:0] o_shift
);

    wire [3:0] shiftl_output;
    wire [3:0] shiftr_output;

    shift_left sl (
        .a (A),
        .s (S),
        .r (shiftl_output)
    );

    shift_right sr (
        .a (A),
        .s (S),
        .r (shiftr_output)
    );

    mux_2_to_1_4bit choose_shift (
        .select (bit0),
        .d0     (shiftl_output),
        .d1     (shiftr_output),
        .y      (o_shift)
    );

endmodule
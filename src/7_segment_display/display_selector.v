// ============================================================
// Selector de valor a mostrar en pantalla
// Segun el estado actual, elige que valor de 4 bits pasarle
// al decodificador de 7 segmentos:
//   00 (ingresar_operacion) -> 0000 (nada que mostrar aun)
//   01 (ingresar_op1)       -> op1_val
//   10 (ingresar_op2)       -> op2_val
//   11 (mostrar_resultado)  -> result
//
// Mismo patron en arbol que mux4, pero con mux_2_to_1_4bit
// en vez del de 1 bit.
// ============================================================

module selector_display (
    input  wire [1:0] current_state,
    input  wire [3:0] op1_val,
    input  wire [3:0] op2_val,
    input  wire [3:0] result,
    output wire [3:0] value_to_show
);

    wire [3:0] level_a;  // entre 0000 y op1_val
    wire [3:0] level_b;  // entre op2_val y result

    mux_2_to_1_4bit between_init_and_op1 (
        .select (current_state[0]),
        .d0     (4'b0000),
        .d1     (op1_val),
        .y      (level_a)
    );

    mux_2_to_1_4bit between_op2_and_result (
        .select (current_state[0]),
        .d0     (op2_val),
        .d1     (result),
        .y      (level_b)
    );

    mux_2_to_1_4bit level_ab (
        .select (current_state[1]),
        .d0     (level_a),
        .d1     (level_b),
        .y      (value_to_show)
    );
    
endmodule
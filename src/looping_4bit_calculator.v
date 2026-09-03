// Looping 4bit Calculator
//
// Version de calculadcora que maneja el reincio (codigo 000) y guarda el resultado en un registro de 4 bits.
// La salida del registro se reingresa a la logica como segundo operando si sel_op2=1, sino se toma un externo.

module looping_4bit_calculator (
    input  wire        clk,
    input  wire        execute,
    input  wire [2:0]  code,         //Selector de operacion (bit2, bit1, bit0)
    input  wire        select_op2,   // Determina el tipo de segundo operando
    input  wire [3:0]  op1,
    input  wire [3:0]  external_op2, // Segundo operando externo (si select_op2=0)
    output wire [3:0]  answer
);

    wire [3:0] op2;
    wire [3:0] calculated_result;
    wire [3:0] final_result;
    wire       is_reset;

    // Selector del segundo operando: externo vs. resultado anterior
    mux_2_to_1_4bit mux_op2 (
        .select (select_op2),
        .d0     (external_op2),
        .d1     (answer),   // realimentacion desde el registro
        .y      (op2)
    );

    // Nucleo combinacional (ALU + shifter)
    shift_arithmetic_selector select_alu_or_shifter (
        .A            (op1),
        .B            (op2),
        .bit2         (code[2]),
        .bit1         (code[1]),
        .bit0         (code[0]),
        .o_calculated (calculated_result)
    );

    // Deteccion de codigo == 000 (Reinicio), armada con compuertas
    nor reset (is_reset, code[2], code[1], code[0]);

    // "Memoria mux": si es Reinicio, fuerza 0000 antes de guardar
    mux_2_to_1_4bit mux_reset (
        .select (is_reset),
        .d0     (calculated_result),
        .d1     (4'b0000),
        .y      (final_result)
    );

    // Registro de resultado
    register_4bit reg_result (
        .clk  (clk),
        .load (execute),
        .D    (final_result),
        .Q    (answer)
    );

endmodule
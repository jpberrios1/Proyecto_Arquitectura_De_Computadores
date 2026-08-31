// ============================================================
// calculadora_4bits.v
// Top-level con la interfaz que espera el testbench del profesor.
//
// Correcciones respecto a la version anterior:
//  - 'calculadora' se instancia con sus puertos reales: A,B,c2,c1,c0,R
//  - el mux se llama 'mux2_4bit' (sin 's')
//  - se agrega el mux de Reinicio: 'calculadora' NO maneja
//    codigo=000 (ver comentario en calculator_logic.v), asi que
//    se detecta aqui con compuertas (NOR de c2,c1,c0) y se fuerza
//    0000 antes de guardar en el registro.
// ============================================================

module calculadora_4bits (
    input  wire       clk,
    input  wire        ejecutar,
    input  wire [2:0]  codigo,
    input  wire        sel_op2,
    input  wire [3:0]  op1,
    input  wire [3:0]  op2_ext,
    output wire [3:0]  resultado
);

    wire [3:0] op2_res;
    wire [3:0] resultado_comb;
    wire [3:0] resultado_final;
    wire       es_reinicio;

    // Selector del segundo operando: externo vs. resultado anterior
    mux2_4bit mux_op2 (
        .Selector (sel_op2),
        .D0       (op2_ext),
        .D1       (resultado),   // realimentacion desde el registro
        .Y        (op2_res)
    );

    // Nucleo combinacional (ALU + shifter)
    calculadora core (
        .A  (op1),
        .B  (op2_res),
        .c2 (codigo[2]),
        .c1 (codigo[1]),
        .c0 (codigo[0]),
        .R  (resultado_comb)
    );

    // Deteccion de codigo == 000 (Reinicio), armada con compuertas
    nor restart (es_reinicio, codigo[2], codigo[1], codigo[0]);

    // "Memoria mux": si es Reinicio, fuerza 0000 antes de guardar
    mux2_4bit mux_reinicio (
        .Selector (es_reinicio),
        .D0       (resultado_comb),
        .D1       (4'b0000),
        .Y        (resultado_final)
    );

    // Registro de resultado
    registro_4bit reg_resultado (
        .clk  (clk),
        .LOAD (ejecutar),
        .D    (resultado_final),
        .Q    (resultado)
    );

endmodule
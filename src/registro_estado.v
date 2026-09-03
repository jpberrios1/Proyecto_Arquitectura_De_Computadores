// ============================================================
// Registro de estado (2 bits, 4 estados)
// Estados: 00=ingresar_operacion 01=ingresar_op1
//          10=ingresar_op2       11=mostrar_resultado
//
// Cada vez que "avanzar" esta en 1 en un flanco de subida,
// el estado pasa al siguiente del ciclo. Si "avanzar"=0,
// se mantiene igual.
// ============================================================

module registro_estado (
    input  wire       clk,
    input  wire       avanzar,
    output reg  [1:0] Q
);

    wire [1:0] estado_siguiente;
    wire [1:0] next_Q;

    wire notQ0;
    not n0 (notQ0, Q[0]);
    buf n1 (estado_siguiente[0], notQ0);

    xor n3 (estado_siguiente[1], Q[1], Q[0]);

    mux_2_to_1 bit1 (
        .select (avanzar),
        .d0 (Q[0]),
        .d1 (estado_siguiente[0]),
        .y (next_Q[0])
    );

    mux_2_to_1 bit2 (
        .select (avanzar),
        .d0 (Q[1]),
        .d1 (estado_siguiente[1]),
        .y (next_Q[1])
    );

    always @(posedge clk) begin
        Q <= next_Q;
        
    end

    initial begin
        Q = 2'b00;
    end

endmodule
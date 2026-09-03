// ============================================================
// Registro de estado (2 bits, 4 estados)
// Estados: 00=ingresar_operacion 01=ingresar_op1
//          10=ingresar_op2       11=mostrar_resultado
//
// Cada vez que "avanzar" esta en 1 en un flanco de subida,
// el estado pasa al siguiente del ciclo. Si "avanzar"=0,
// se mantiene igual.
// ============================================================

module state_register (
    input  wire       clk,
    input  wire       continue,
    output reg  [1:0] current_Q
);

    wire [1:0] next_state;
    wire [1:0] next_Q;

    wire notQ0;
    not n0 (notQ0, current_Q[0]);
    buf n1 (next_state[0], notQ0);

    xor n3 (next_state[1], current_Q[1], current_Q[0]);

    mux_2_to_1 bit1 (
        .select (continue),
        .d0 (current_Q[0]),
        .d1 (next_state[0]),
        .y (next_Q[0])
    );

    mux_2_to_1 bit2 (
        .select (continue),
        .d0 (current_Q[1]),
        .d1 (next_state[1]),
        .y (next_Q[1])
    );

    always @(posedge clk) begin
        current_Q <= next_Q;
        
    end

    initial begin
        current_Q = 2'b00;
    end

endmodule
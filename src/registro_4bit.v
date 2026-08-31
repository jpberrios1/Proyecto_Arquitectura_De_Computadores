// ============================================================
// Registro de 4 bits con carga condicional (LOAD)
// En cada flanco de subida de clk:
//   LOAD=1 -> Q captura el valor de D
//   LOAD=0 -> Q mantiene su valor actual
// ============================================================

module registro_4bit (
    input  wire       clk,
    input  wire       LOAD,
    input  wire [3:0] D,
    output reg  [3:0] Q
);

    wire [3:0] next_Q;

    mux2_4bit changes (
        .Selector (LOAD),
        .D0 (Q),
        .D1 (D),
        .Y (next_Q)
    );

    always @(posedge clk) begin
        Q <= next_Q;
    end

endmodule
// Registro de 4 bits
// En cada flanco de subida de clk guarda el valor dependiendo del valor de "load":
//   load=1 -> "Q" captura el valor de "D"
//   load=0 -> "Q" mantiene su valor actual
// ============================================================

module register_4bit (
    input  wire       clk,
    input  wire       load,
    input  wire [3:0] D,
    output reg  [3:0] Q
);

    wire [3:0] next_Q;

    mux_2_to_1_4bit mux_change (
        .select (load),
        .d0     (Q),
        .d1     (D),
        .y      (next_Q)
    );

    always @(posedge clk) begin
        Q <= next_Q;
    end

endmodule
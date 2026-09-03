// Registro de 1 bits
// En cada flanco de subida de clk guarda el valor dependiendo del valor de "load":
//   load=1 -> "Q" captura el valor de "D"
//   load=0 -> "Q" mantiene su valor actual
// ============================================================

module register_1bit (
    input  wire clk,
    input  wire load,
    input  wire D,
    output reg  Q
);

    wire next_Q;

    mux_2_to_1 mux_change (
        .select (load),
        .d0     (Q),
        .d1     (D),
        .y      (next_Q)
    );

    always @(posedge clk) begin
        Q <= next_Q;
    end

    initial begin
        Q = 1'b0;
    end

endmodule
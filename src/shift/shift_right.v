// Shift Right 
// Mueve los bits de 'a' a la derecha 's' veces, rellenando con ceros.
// 's' son 2 bits (4 combinaciones de desplazamiento: 0, 1, 2, 3).

module shift_right (
    input  wire [3:0] a,
    input  wire [1:0] s, 
    output wire [3:0] r
);

    mux_4_to_1 mux_bit0 (
        .sel   (s),
        .bit0  (a[3]),
        .bit1  (1'b0),
        .bit2  (1'b0),
        .bit3  (1'b0),
        .o_bit (r[3])
    );

   mux_4_to_1 mux_bit1 (
        .sel   (s),
        .bit0  (a[2]),
        .bit1  (a[3]),
        .bit2  (1'b0),
        .bit3  (1'b0),
        .o_bit (r[2])
    );

    mux_4_to_1 mux_bit2 (
        .sel   (s),
        .bit0  (a[1]),
        .bit1  (a[2]),
        .bit2  (a[3]),
        .bit3  (1'b0),
        .o_bit (r[1])
    );

    mux_4_to_1 mux_bit3 (
        .sel   (s),
        .bit0  (a[0]),
        .bit1  (a[1]),
        .bit2  (a[2]),
        .bit3  (a[3]),
        .o_bit (r[0])
    );


endmodule
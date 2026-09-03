// Mux 2:1 - 1 bit
// Entran 2 bits y dependiendo de un selector, decide cual pasa a la salida
// select = 0 -> y = d0
// select = 1 -> y = d1

// Ecuacion: y = d0.sel' + d1.sel

module mux_2_to_1 (
    input  wire select,
    input  wire d0,
    input  wire d1,
    output wire y
);
    wire not_select;
    wire d0_not_select;
    wire d1_select;

    not u_not (not_select, select);

    and u_and0 (d0_not_select, d0, not_select);
    and u_and1 (d1_select, d1, select);

    or u_or (y, d0_not_select, d1_select);

endmodule

// Mux 2:1 - 4 bits

module mux_2_to_1_4bit (
    input  wire       select,
    input  wire [3:0] d0,
    input  wire [3:0] d1,
    output wire [3:0] y
);

    mux_2_to_1 mux_bit0 (
        .select (select),
        .d0     (d0[0]),
        .d1     (d1[0]),
        .y      (y[0])
    );

    mux_2_to_1 mux_bit1 (
        .select (select),
        .d0     (d0[1]),
        .d1     (d1[1]),
        .y      (y[1])
    );

    mux_2_to_1 mux_bit2 (
        .select (select),
        .d0     (d0[2]),
        .d1     (d1[2]),
        .y      (y[2])
    );

    mux_2_to_1 mux_bit3 (
        .select (select),
        .d0     (d0[3]),
        .d1     (d1[3]),
        .y      (y[3])
    );
    
endmodule

// ============================================================
// Mux 4:1 - 1 bit
// Sel[1:0] = 00 -> Y = D0
// Sel[1:0] = 01 -> Y = D1
// Sel[1:0] = 10 -> Y = D2
// Sel[1:0] = 11 -> Y = D3

// Mux que entran 4 bits y dependiendo de un selector de 2 bits, decide cual pasa a la salida
// Ecuacion: Y = D0.Sel1'.Sel0' + D1.Sel1'.Sel0 + D2.Sel1.Sel0' + D3.Sel1.Sel0

module mux_4_to_1 (
    input  wire [1:0] sel,
    input  wire       bit0,
    input  wire       bit1,
    input  wire       bit2,
    input  wire       bit3,
    output wire       o_bit
);
    wire w1;
    wire w2;

    mux_2_to_1 mux_bit0_bit1 (
        .select (sel[0]),
        .d0     (bit0),
        .d1     (bit1),
        .y      (w1)
    );

    mux_2_to_1 mux_bit2_bit3 (
        .select (sel[0]),
        .d0     (bit2),
        .d1     (bit3),
        .y      (w2)
    );

    mux_2_to_1 output_mux (
        .select (sel[1]),
        .d0     (w1),
        .d1     (w2),
        .y      (o_bit)
    );

endmodule
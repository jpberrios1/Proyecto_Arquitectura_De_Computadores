// ============================================================
// Mux 2:1 - 1 bit
// Sel=0 -> Y = D0
// Sel=1 -> Y = D1
//
// Ecuacion: Y = D0.Sel' + D1.Sel

module mux2 (
    input  wire Sel,
    input  wire D0,
    input  wire D1,
    output wire Y
);
    wire notSel;
    not n1 (notSel, Sel);

    wire D0notSel;
    wire D1Sel;

    and n2 (D0notSel, D0, notSel);
    and n3 (D1Sel, D1, Sel);

    or n4 (Y, D0notSel, D1Sel);

endmodule

module mux2_4bit (
    input  wire Selector,
    input  wire [3:0] D0,
    input  wire [3:0] D1,
    output wire [3:0] Y
);

    mux2 B0 (
        .Sel (Selector),
        .D0 (D0[0]),
        .D1 (D1[0]),
        .Y (Y[0])
    );

    mux2 B1 (
        .Sel (Selector),
        .D0 (D0[1]),
        .D1 (D1[1]),
        .Y (Y[1])
    );

    mux2 B2 (
        .Sel (Selector),
        .D0 (D0[2]),
        .D1 (D1[2]),
        .Y (Y[2])
    );

    mux2 B3 (
        .Sel (Selector),
        .D0 (D0[3]),
        .D1 (D1[3]),
        .Y (Y[3])
    );
    
endmodule

// ============================================================
// Mux 4:1 - 1 bit
// Sel[1:0] = 00 -> Y = D0
// Sel[1:0] = 01 -> Y = D1
// Sel[1:0] = 10 -> Y = D2
// Sel[1:0] = 11 -> Y = D3


module mux4 (
    input  wire [1:0] Sel,
    input  wire       D0,
    input  wire       D1,
    input  wire       D2,
    input  wire       D3,
    output wire       Y
);
    wire w1, w2;

    mux2 gate1 (
        .Sel (Sel[0]),
        .D0 (D0),
        .D1 (D1),
        .Y (w1)
    );

    mux2 gate2 (
        .Sel (Sel[0]),
        .D0 (D2),
        .D1 (D3),
        .Y (w2)
    );

    mux2 gate12 (
        .Sel (Sel[1]),
        .D0 (w1),
        .D1 (w2),
        .Y (Y)
    );

endmodule
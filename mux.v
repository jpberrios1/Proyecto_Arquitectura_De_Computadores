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
    input  wire Sel_,
    input  wire [3:0] D0_,
    input  wire [3:0] D1_,
    output wire [3:0] Y_
);

    mux2 B0 (
        .Sel (Sel_),
        .D0 (D0_[0]),
        .D1 (D1_[0]),
        .Y (Y_[0])
    );

    mux2 B1 (
        .Sel (Sel_),
        .D0 (D0_[1]),
        .D1 (D1_[1]),
        .Y (Y_[1])
    );

    mux2 B2 (
        .Sel (Sel_),
        .D0 (D0_[2]),
        .D1 (D1_[2]),
        .Y (Y_[2])
    );

    mux2 B3 (
        .Sel (Sel_),
        .D0 (D0_[3]),
        .D1 (D1_[3]),
        .Y (Y_[3])
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
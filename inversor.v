// Tabla de verdad:
// Inv X | S
//  0  0 | 0
//  0  1 | 1
//  1  0 | 1
//  1  1 | 0


// Si Inv=0, deja pasar X
// Si Inv=1, invierte X.

module inversorBit (
    input  wire Inv,
    input  wire X,
    output wire S
);

    xor n1 (S, Inv, X);

endmodule

module inversor4Bit (
    input wire Inv,
    input wire [3:0] X,
    output wire [3:0] S
);
    xor bit0 (S[0], Inv, X[0]);
    xor bit1 (S[1], Inv, X[1]);
    xor bit2 (S[2], Inv, X[2]);
    xor bit3 (S[3], Inv, X[3]);
    
endmodule

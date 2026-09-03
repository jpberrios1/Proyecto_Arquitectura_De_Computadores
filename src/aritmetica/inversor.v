// Tabla de verdad:
// Inv X | S
//  0  0 | 0
//  0  1 | 1
//  1  0 | 1
//  1  1 | 0


// Si Inv=0, deja pasar X
// Si Inv=1, invierte X.

// Se ingresan 4 bits y dependiendo de la condicion de "invert", salen los bits invertidos
// "invert = 0" -> Salen como entraron
// "invert = 1" -> Salen invertidos

module inversor_4_bit (
    input wire  invert,
    input wire  [3:0] input_X,
    output wire [3:0] output_S
);
    xor bit0 (output_S[0], invert, input_X[0]);
    xor bit1 (output_S[1], invert, input_X[1]);
    xor bit2 (output_S[2], invert, input_X[2]);
    xor bit3 (output_S[3], invert, input_X[3]);
    
endmodule

// Un inversor normal es solo una puerta xor.

/*module inversorBit (
    input  wire Inv,
    input  wire X,
    output wire S
);
    xor n1 (S, Inv, X);

endmodule*/

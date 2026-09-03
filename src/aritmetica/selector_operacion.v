// Tabla de verdad:
// c2 c1 c0 | cin invA invB   
//  0  0  0 |  0   0    0     Reinicio
//  0  0  1 |  0   0    0     Suma
//  0  1  0 |  1   0    1     Resta (A - B)
//  0  1  1 |  1   1    0     Resta inversa (B - A)

// Ecuaciones con Karnaugh:
//   cin  = c1
//   invA = c1 . c0
//   invB = c1 . c0'


module arithmetic_operation_selector (
    // bit2 solo decide su usar o no las operaciones aritmeticas
    input  wire bit1, 
    input  wire bit0,
    output wire carry_in,
    output wire is_A_inverted,
    output wire is_B_inverted
);

    wire bit0_inverted;
    not n1 (bit0_inverted, bit0);
    
    // Copia el valor de bit1 a la salida carry_in
    buf n2 (carry_in, bit1);

    and n3 (is_A_inverted, bit1, bit0);          // Decide si A es numero negativo
    and n4 (is_B_inverted, bit1, bit0_inverted); // Decide si B es numero negativo

endmodule
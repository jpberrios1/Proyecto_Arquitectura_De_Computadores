// ============================================================
// Selector de Operacion - Calculadora 4 bits
// Traduce el codigo de operacion (c2 c1 c0) en las senales
// de control cin, invA e invB para el sumador/restador.
//
// Tabla de verdad (del trabajo de tu companera):
// c2 c1 c0 | cin invA invB   operacion
//  0  0  0 |  0   0    0     Reinicio
//  0  0  1 |  0   0    0     Suma
//  0  1  0 |  1   0    1     Resta (A - B)
//  0  1  1 |  1   1    0     Resta inversa (B - A)
//  (c2=1 son shifts, no le importan a este bloque -> don't care)
//
// Ecuaciones ya simplificadas con Karnaugh:
//   cin  = c1
//   invA = c1 . c0
//   invB = c1 . c0'
// ============================================================

module selector_operacion (
    input  wire c2,   // no se usa en estas ecuaciones (era don't care)
    input  wire c1,
    input  wire c0,
    output wire cin,
    output wire invA,
    output wire invB
);

    // Cable separado que luego se convierte en el inverso
    // de c0 para obtener invB
    // Sintaxis: not nombre_instancia (salida, entrada);
    wire c0_n;
    not n1 (c0_n, c0);
    
    // Copia el valor de la entrada c1 a la salida cin (sin modificar)
    // Sintaxis: buf nombre_instancia (salida, entrada);
    buf n2 (cin, c1);

    // Sintaxis de un AND de 2 entradas:
    // and nombre_instancia (salida, entrada1, entrada2);

    and n3 (invA, c1, c0); //invA

    and n4 (invB, c1, c0_n); //invB

endmodule
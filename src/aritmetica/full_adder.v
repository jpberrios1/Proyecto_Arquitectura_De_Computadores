// Tabla de verdad:
// A B Cin | Cout S
// 0 0  0  |  0   0
// 0 0  1  |  0   1
// 0 1  0  |  0   1
// 0 1  1  |  1   0
// 1 0  0  |  0   1
// 1 0  1  |  1   0
// 1 1  0  |  1   0
// 1 1  1  |  1   1
//
// Ecuaciones:
//   S    = A xor B xor Cin
//   Cout = A.B + B.Cin + A.Cin


// Modulo que suma 2 bits A y B con un carry de entrada Cin
// Devuelve la suma S y el carry de salida Cout

module full_adder (
    input  wire A,
    input  wire B,
    input  wire Cin,
    output wire S,
    output wire Cout
);

    // Define la Suma
    xor x1 (S, A, B, Cin);

    // Define el carry de salida
    wire w1, w2, w3;

    and a1 (w1, A, B);
    and a2 (w2, A, Cin);
    and a3 (w3, B, Cin);

    or o1 (Cout, w1, w2, w3);

endmodule



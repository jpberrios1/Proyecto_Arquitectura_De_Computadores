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

module full_adder (
    input  wire A,
    input  wire B,
    input  wire Cin,
    output wire S,
    output wire Cout
);

    // XOR para la suma que sale (0,1)
    xor x1 (S, A, B, Cin);

    wire t1, t2, t3;

    //ANDS y OR para el carry que sigue para el siguiente digito
    and a1 (t1, A, B);
    and a2 (t2, A, Cin);
    and a3 (t3, B, Cin);
    or o1 (Cout, t1, t2, t3);

endmodule



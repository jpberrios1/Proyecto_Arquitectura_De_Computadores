

module full_adder_4bit (
    input wire  carry_in,
    input wire  [3:0] A,
    input wire  [3:0] B,
    output wire [3:0] S
);

    wire [3:0] full_carry;

    full_adder adder0 (
        .A    (A[0]),
        .B    (B[0]),
        .Cin  (carry_in),
        .S    (S[0]),
        .Cout (full_carry[0])
    );

    full_adder adder1 (
        .A    (A[1]),
        .B    (B[1]),
        .Cin  (full_carry[0]),
        .S    (S[1]),
        .Cout (full_carry[1])
    );

    full_adder adder2 (
        .A    (A[2]),
        .B    (B[2]),
        .Cin  (full_carry[1]),
        .S    (S[2]),
        .Cout (full_carry[2])
    );

    full_adder adder3 (
        .A    (A[3]),
        .B    (B[3]),
        .Cin  (full_carry[2]),
        .S    (S[3]),
        .Cout () // No necesitamnos el carry de salida final, sobrepasa los 4 bits
    );

endmodule
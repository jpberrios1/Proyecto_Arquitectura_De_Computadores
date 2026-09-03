// R = A + B => A + B      (c2c1c0 = 001)
// R = A - B => A + B' + 1 (c2c1c0 = 010)
// R = B - A => A' + B + 1 (c2c1c0 = 011)
// (c2c1c0 = 000 es Reinicio, ese caso se maneja fuera de este bloque)


// ALU Aritmetica que resuelve suma y ambas restas entre A y B
module arithmetic_logic_unit (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       bit1,
    input  wire       bit0,
    output wire [3:0] R
);

    // Salidas del selector de operacion
    wire carry_in;
    wire is_A_inverted;
    wire is_B_inverted;

    // Ver si hay carry de entrada y si A o B son negativos
    arithmetic_operation_selector sel (
        .bit1          (bit1),
        .bit0          (bit0),
        .carry_in      (carry_in),
        .is_A_inverted (is_A_inverted),
        .is_B_inverted (is_B_inverted)
    );

    // Operandos ya pasados por el inversor
    wire [3:0] A_inverted; 
    wire [3:0] B_inverted;

    inversor_4_bit inv_a (
        .invert   (is_A_inverted), 
        .input_X  (A), 
        .output_S (A_inverted)
    );

    inversor_4_bit inv_b (
        .invert   (is_B_inverted), 
        .input_X  (B), 
        .output_S (B_inverted)
    );

    // Carry que se propaga entre bits para los full adder
    wire [3:0] full_carry;

    full_adder adder0 (
        .A    (A_inverted[0]),
        .B    (B_inverted[0]),
        .Cin  (carry_in),
        .S    (R[0]),
        .Cout (full_carry[0])
    );

    full_adder adder1 (
        .A    (A_inverted[1]),
        .B    (B_inverted[1]),
        .Cin  (full_carry[0]),
        .S    (R[1]),
        .Cout (full_carry[1])
    );

    full_adder adder2 (
        .A    (A_inverted[2]),
        .B    (B_inverted[2]),
        .Cin  (full_carry[1]),
        .S    (R[2]),
        .Cout (full_carry[2])
    );

    full_adder adder3 (
        .A    (A_inverted[3]),
        .B    (B_inverted[3]),
        .Cin  (full_carry[2]),
        .S    (R[3]),
        .Cout () // No necesitamnos el carry de salida final, sobrepasa los 4 bits
    );

endmodule

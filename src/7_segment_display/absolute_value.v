// ============================================================
// Valor absoluto (signo + magnitud)
// signo = V[3]
// magnitud = |V|, calculado igual que una resta:
//   invertir V condicionalmente (segun el signo) + sumar 1
//   solo si es negativo (via el Cin de la cadena de full_adder)
// ============================================================

module absolute_value (
    input  wire [3:0] value,
    output wire       sign,
    output wire [3:0] magnitud
);

    // TODO 1: signo = V[3] (conexion directa, un buf o assign-like)

    buf buf_signo (sign, value[3]);

    wire [3:0] inverted_value;
    // TODO 2: instancia inversor4Bit, Inv=signo, X=V -> V_inv

    inversor_4bit invert_value (
        .invert   (sign),
        .input_X  (value),
        .output_S (inverted_value)
    );
    

    full_adder_4bit get_magnitud (
        .carry_in (sign),
        .A        (inverted_value),
        .B        (4'b0000),
        .S        (magnitud)
    );

endmodule

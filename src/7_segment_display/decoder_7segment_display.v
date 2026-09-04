// ============================================================
// Decodificador de 7 segmentos
// Entrada: magnitud de 4 bits (0 a 8, el resto son don't care)
// Salidas activas en alto (1 = segmento prendido) -- VERIFICAR
// en la placa real si tus displays son activo-bajo; si es asi,
// basta con agregar un 'not' a cada salida.
//
// E = F0' . (F2' + F1)
// F = F1'F0' + F2F1' + F2F0'
// G = F2'F1 + F2F1' + F1F0' + F3F2'F1'
// ============================================================

module decoder_7segment_display (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    input  wire x0,
    output wire A,
    output wire B,
    output wire C,
    output wire D,
    output wire E,
    output wire F,
    output wire G
);

    wire not_x3, not_x2, not_x1, not_x0;
    not n0 (not_x0, x0);
    not n1 (not_x1, x1);
    not n2 (not_x2, x2);
    not n3 (not_x3, x3);

    //A = F2'F0' + F2F0 + F1 --> F1 + (F2 XNOR F0)
    wire aux_a;
    xnor xnor_a (aux_a, x2, x0);
    or or_a (A, aux_a, x1);

    //B = F1'F0' + F1F0 + F2' --> F2' + (F1 XNOR F0)
    wire aux_b;
    xnor xnor_b (aux_b, x1, x0);
    or or_b (B, aux_b, not_x2);

    //C = F2 + F1' + F0
    or or_c (C, x2, not_x1, x0);

    //D = F2'F0' + F1F0' + F2F1'F0 + F2'F1
    wire aux_d1, aux_d2, aux_d3, aux_d4;

    and and_d1 (aux_d1, not_x2, not_x0);
    and and_d2 (aux_d2, x1, not_x0);
    and and_d3 (aux_d3, x2, not_x1, x0);
    and and_d4 (aux_d4, not_x2, x1);
    or or_d (D, aux_d1, aux_d2, aux_d3, aux_d4);

    // TODO 6: E = F0' . (F2' + F1)    -> 1 or + 1 and

    //E = F0'(F2' + F1)
    wire aux_e;
    or or_e (aux_e, not_x2, x1);
    and and_e (E, aux_e, not_x0);

    //F = F1'F0' + F2F1' + F2F0'  -> 3 terminos 'and' + 1 'or'
    wire aux_f1, aux_f2, aux_f3;
    and and_f1 (aux_f1, not_x1, not_x0);
    and and_f2 (aux_f2, x2, not_x1);
    and and_f3 (aux_f3, x2, not_x0);
    or or_f (F, aux_f3, aux_f2, aux_f1);

    //G = F2'F1 + F2F1' + F1F0' + F3F2'F1'
    wire aux_g1, aux_g2, aux_g3, aux_g4;

    and and_g1 (aux_g1, not_x2, x1);
    and and_g2 (aux_g2, x2, not_x1);
    and and_g3 (aux_g3, x1, not_x0);
    and and_g4 (aux_g4, x3, not_x2, not_x1);
    or or_g (G, aux_g1, aux_g2, aux_g3, aux_g4);


endmodule
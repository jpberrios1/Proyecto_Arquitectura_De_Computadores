// ============================================================
// Top level - Go Board
// Junta fsm_controller + selector_display + valor_absoluto +
// decoder_7segment_display, y los conecta a los nombres de
// pin que van a ir en el .pcf.
// ============================================================

module fpga_top (
    input  wire clk,
    input  wire i_Switch_1,   // sup-izq: incrementar
    input  wire i_Switch_2,   // inf-izq: decrementar
    input  wire i_Switch_3,   // sup-der: confirmar
    input  wire i_Switch_4,   // inf-der: usar resultado anterior

    output wire o_LED_1,
    output wire o_LED_2,
    output wire o_LED_3,

    output wire o_Seg1_A, o_Seg1_B, 
    output wire o_Seg1_C, o_Seg1_D,
    output wire o_Seg1_E, o_Seg1_F, o_Seg1_G,

    output wire o_Seg2_A, o_Seg2_B, 
    output wire o_Seg2_C, o_Seg2_D,
    output wire o_Seg2_E, o_Seg2_F, o_Seg2_G
);

    wire [3:0] result, op1_val, op2_val, code;
    wire [1:0] current_state;
    wire [3:0] value_to_show;
    wire       sign;
    wire [3:0] magnitud;
    wire       select_op2;


    fsm_controller principal_controller (
        .clk           (clk),
        .inc_btn       (i_Switch_1),
        .dec_btn       (i_Switch_2),
        .confirm_btn   (i_Switch_3),
        .useprev_btn   (i_Switch_4),
        .result        (result),
        .current_state (current_state),
        .op1_val       (op1_val),
        .op2_val       (op2_val),
        .code          (code),
        .select_op2    (select_op2)
    );

    wire [3:0] op2_display_value;

    mux_2_to_1_4bit choose_op2_display (
        .select (select_op2),
        .d0     (op2_val),
        .d1     (result),
        .y      (op2_display_value)
    );

    selector_display choose_display_phase (
        .current_state (current_state),
        .op1_val       (op1_val),
        .op2_val       (op2_display_value),
        .result        (result),
        .value_to_show (value_to_show)
    );

    absolute_value get_magnitud_and_sign (
        .value    (value_to_show),
        .sign     (sign),
        .magnitud (magnitud)
    );

    // Display with sign
    not inv_seg1_a (o_Seg1_A, 1'b0);
    not inv_seg1_b (o_Seg1_B, 1'b0);
    not inv_seg1_c (o_Seg1_C, 1'b0);
    not inv_seg1_d (o_Seg1_D, 1'b0);
    not inv_seg1_e (o_Seg1_E, 1'b0);
    not inv_seg1_f (o_Seg1_F, 1'b0);
    not inv_seg1_g (o_Seg1_G, sign);

    wire w_Seg2_A, w_Seg2_B, w_Seg2_C, w_Seg2_D, w_Seg2_E, w_Seg2_F, w_Seg2_G;

    decoder_7segment_display second_display (
        .x3 (magnitud[3]),
        .x2 (magnitud[2]),
        .x1 (magnitud[1]),
        .x0 (magnitud[0]),
        .A  (w_Seg2_A),
        .B  (w_Seg2_B),
        .C  (w_Seg2_C),
        .D  (w_Seg2_D),
        .E  (w_Seg2_E),
        .F  (w_Seg2_F),
        .G  (w_Seg2_G)
    );

    not inv_seg2_a (o_Seg2_A, w_Seg2_A);
    not inv_seg2_b (o_Seg2_B, w_Seg2_B);
    not inv_seg2_c (o_Seg2_C, w_Seg2_C);
    not inv_seg2_d (o_Seg2_D, w_Seg2_D);
    not inv_seg2_e (o_Seg2_E, w_Seg2_E);
    not inv_seg2_f (o_Seg2_F, w_Seg2_F);
    not inv_seg2_g (o_Seg2_G, w_Seg2_G);

    //   o_LED_1 = code[2], o_LED_2 = code[1], o_LED_3 = code[0]
    buf buf_led1 (o_LED_1, code[2]);
    buf buf_led2 (o_LED_2, code[1]);
    buf buf_led3 (o_LED_3, code[0]);


endmodule
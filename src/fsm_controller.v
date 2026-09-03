// ============================================================
// FSM Controller
// Traduce los 4 botones fisicos en las senales que necesita
// looping_4bit_calculator: code, op1, external_op2,
// select_op2 y execute.
//
// Botones (ya crudos, sin debouncing hecho aqui todavia):
//   btn_inc     -> superior izquierdo (incrementar)
//   btn_dec     -> inferior izquierdo (decrementar)
//   btn_confirm -> superior derecho   (confirmar/avanzar)
//   btn_useprev -> inferior derecho   (usar resultado anterior)
// ============================================================

module fsm_controller (
    input  wire       clk,
    input  wire       inc_btn,
    input  wire       dec_btn,
    input  wire       confirm_btn,
    input  wire       useprev_btn,
    output wire [3:0] result
);

    // ---- Paso 1: detectar flancos de los 4 botones ----
    wire inc_pulse;
    wire dec_pulse;
    wire confirm_pulse;
    wire useprev_pulse;

    flank_detector increment_pulse_detector (
        .clk    (clk),
        .button (inc_btn),
        .pulse  (inc_pulse)
    );

    flank_detector decrement_pulse_detector (
        .clk    (clk),
        .button (dec_btn),
        .pulse  (dec_pulse)
    );

    flank_detector confirm_pulse_detector (
        .clk    (clk),
        .button (confirm_btn),
        .pulse  (confirm_pulse)
    );

    flank_detector useprev_pulse_detector (
        .clk    (clk),
        .button (useprev_btn),
        .pulse  (useprev_pulse)
    );


    // ---- Paso 2: registro de estado ----
    wire [1:0] current_state;
    state_register state (
        .clk       (clk),
        .advance   (confirm_pulse),
        .current_Q (current_state)
    );

    // ---- Paso 3: decodificar el estado actual ----

    wire is_operation_state;
    wire is_op1_state;
    wire is_op2_state;
    wire is_resultado_state;


    state_decoder decode_current_state (
        .current_state       (current_state),
        .is_operation_state  (is_operation_state),
        .is_op1_state        (is_op1_state),
        .is_op2_state        (is_op2_state),
        .is_resultado_state  (is_resultado_state)
    );

    // ---- Paso 4: enrutar incrementar/decrementar segun estado ----
    wire inc_code, dec_code;
    wire inc_op1, dec_op1;
    wire inc_op2, dec_op2;

    and u_inc_code (inc_code, inc_pulse, is_operation_state);
    and u_dec_code (dec_code, dec_pulse, is_operation_state);

    and u_inc_op1 (inc_op1, inc_pulse, is_op1_state);
    and u_dec_op1 (dec_op1, dec_pulse, is_op1_state);

    and u_inc_op2 (inc_op2, inc_pulse, is_op2_state);
    and u_dec_op2 (dec_op2, dec_pulse, is_op2_state);


    // ---- Paso 5: los 3 contadores ----
    wire [3:0] code;  // usa solo codigo_full[2:0] afuera
    wire [3:0] op1_val;
    wire [3:0] op2_val;

    increment_decrement_4bit codigo_counter (
        .clk       (clk),
        .btn_plus  (inc_code),
        .btn_minus (dec_code),
        .r_Q       (code)
    );

    increment_decrement_4bit op1_counter (
        .clk       (clk),
        .btn_plus  (inc_op1),
        .btn_minus (dec_op1),
        .r_Q       (op1_val)
    );

    increment_decrement_4bit op2_counter (
        .clk       (clk),
        .btn_plus  (inc_op2),
        .btn_minus (dec_op2),
        .r_Q       (op2_val)
    );

    // ---- Paso 6: flag select_op2 (set/reset) ----
    wire select_op2;
    wire set_select_op2;
    wire load_select_op2;
    wire reset_select_op2;

    and u_set_select_to1 (set_select_op2, useprev_pulse, is_op2_state);
    and u_reset_select_to0 (reset_select_op2, confirm_pulse, is_op1_state);

    or u_load_select_op2 (load_select_op2, set_select_op2, reset_select_op2);

    register_1bit select_op2_register (
        .clk  (clk),
        .load (load_select_op2),
        .D    (set_select_op2),
        .Q    (select_op2)
    );

    // ---- Paso 7: senal de ejecutar (carga el registro final) ----
    wire execute;
    and u_execute (execute, confirm_pulse, is_op2_state);

    // ---- Paso 8: instanciar looping_4bit_calculator con todo esto ----
    looping_4bit_calculator calculator (
        .clk          (clk),
        .execute      (execute),
        .code         (code[2:0]),
        .select_op2   (select_op2),
        .op1          (op1_val),
        .external_op2 (op2_val),
        .answer       (result)
    );


endmodule
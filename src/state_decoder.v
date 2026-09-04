

module state_decoder (
    input  wire [1:0] current_state,
    output wire       is_operation_state,
    output wire       is_op1_state,
    output wire       is_op2_state,
    output wire       is_resultado_state
);

    wire not_current_state0, not_current_state1;
    not n0 (not_current_state0, current_state[0]);
    not n1 (not_current_state1, current_state[1]);
    
    and n2 (is_operation_state, not_current_state1, not_current_state0);
    and n3 (is_op1_state, not_current_state1, current_state[0]);
    and n4 (is_op2_state, current_state[1], not_current_state0);
    and n5 (is_resultado_state, current_state[1], current_state[0]);

endmodule
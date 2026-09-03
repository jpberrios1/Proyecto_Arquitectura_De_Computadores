

module increment_4bit (
    input  wire [3:0] current_value,
    output wire [3:0] incremented_value
);
    // Increment +1 logic
    not plus0 (incremented_value[0], current_value[0]);
    xor plus1 (incremented_value[1], current_value[1], current_value[0]);

    wire q0q1;
    and n0 (q0q1, current_value[1], current_value[0]);
    xor plus2 (incremented_value[2], current_value[2], q0q1);

    wire q0q1q2;
    and n1 (q0q1q2, q0q1, current_value[2]);
    xor plus3 (incremented_value[3], current_value[3], q0q1q2);

endmodule
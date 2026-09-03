

module decrement_4bit (
    input  wire [3:0] current_value,
    output wire [3:0] decremented_value
);
    // Increment -1 logic
    wire notQ0, notQ1, notQ2;
    not q0 (notQ0, current_value[0]);
    not q1 (notQ1, current_value[1]);
    not q2 (notQ2, current_value[2]);

    buf minus0 (decremented_value[0], notQ0);
    xor minus1 (decremented_value[1], current_value[1], notQ0);

    wire nq0nq1;
    and n2 (nq0nq1, notQ0, notQ1);
    xor minus2 (decremented_value[2], current_value[2], nq0nq1);

    wire nq0nq1nq2;
    and n3 (nq0nq1nq2, notQ2, nq0nq1);
    xor minus3 (decremented_value[3], current_value[3], nq0nq1nq2);

endmodule
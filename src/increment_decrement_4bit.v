// Increment a 4 bit number by 1 or decrement it by 1 depending on the button pressed

module increment_decrement_4bit (
    input wire clk,
    input wire btn_plus,
    input wire btn_minus,
    output reg [3:0] r_Q
);
    wire [3:0] plus_val;
    wire [3:0] minus_val;

    // Increment +1 logic
    not plus0 (plus_val[0], r_Q[0]);
    xor plus1 (plus_val[1], r_Q[1], r_Q[0]);

    wire q0q1;
    and n0 (q0q1, r_Q[1], r_Q[0]);
    xor plus2 (plus_val[2], r_Q[2], q0q1);

    wire q0q1q2;
    and n1 (q0q1q2, q0q1, r_Q[2]);
    xor plus3 (plus_val[3], r_Q[3], q0q1q2);

    // Increment -1 logic
    wire notQ0, notQ1, notQ2;
    not q0 (notQ0, r_Q[0]);
    not q1 (notQ1, r_Q[1]);
    not q2 (notQ2, r_Q[2]);

    buf minus0 (minus_val[0], notQ0);
    xor minus1 (minus_val[1], r_Q[1], notQ0);

    wire nq0nq1;
    and n2 (nq0nq1, notQ0, notQ1);
    xor minus2 (minus_val[2], r_Q[2], nq0nq1);

    wire nq0nq1nq2;
    and n3 (nq0nq1nq2, notQ2, nq0nq1);
    xor minus3 (minus_val[3], r_Q[3], nq0nq1nq2);

    //Decide if increment or decrement is the value to store on calculated_Q

    wire [3:0] calculated_Q;
    wire [3:0] next_Q;
    wire needsChange;

    mux_2_to_1_4bit calculate (
        .select (btn_minus),
        .d0 (plus_val),
        .d1 (minus_val),
        .y (calculated_Q)
    );

    // Check if either buttons have been pressed to affect change

    or check (needsChange, btn_plus, btn_minus);

    mux_2_to_1_4bit load (
        .select (needsChange),
        .d0 (r_Q),
        .d1 (calculated_Q),
        .y (next_Q)
    );

    always @(posedge clk) begin
        r_Q <= next_Q;
    end

    // For benchtest
    initial begin
        r_Q = 4'b0000;
    end


endmodule
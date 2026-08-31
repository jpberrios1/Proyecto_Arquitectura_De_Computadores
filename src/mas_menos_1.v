

module contador_masmenos_4bit (
    input wire clk,
    input wire btn_plus,
    input wire btn_minus,
    output reg [3:0] Q
);
    wire [3:0] plus_val;
    wire [3:0] minus_val;

    // Increment +1 logic
    not plus0 (plus_val[0], Q[0]);
    xor plus1 (plus_val[1], Q[1], Q[0]);

    wire q0q1;
    and n0 (q0q1, Q[1], Q[0]);
    xor plus2 (plus_val[2], Q[2], q0q1);

    wire q0q1q2;
    and n1 (q0q1q2, q0q1, Q[2]);
    xor plus3 (plus_val[3], Q[3], q0q1q2);

    // Increment -1 logic
    wire notQ0, notQ1, notQ2;
    not q0 (notQ0, Q[0]);
    not q1 (notQ1, Q[1]);
    not q2 (notQ2, Q[2]);

    buf minus0 (minus_val[0], notQ0);
    xor minus1 (minus_val[1], Q[1], notQ0);

    wire nq0nq1;
    and n2 (nq0nq1, notQ0, notQ1);
    xor minus2 (minus_val[2], Q[2], nq0nq1);

    wire nq0nq1nq2;
    and n3 (nq0nq1nq2, notQ2, nq0nq1);
    xor minus3 (minus_val[3], Q[3], nq0nq1nq2);

    //Decide if increment or decrement is the value to store on calculated_Q

    wire [3:0] calculated_Q;
    wire [3:0] next_Q;
    wire needsChange;

    mux2_4bit calculate (
        .Selector (btn_minus),
        .D0 (plus_val),
        .D1 (minus_val),
        .Y (calculated_Q)
    );

    // Check if either buttons have been pressed to affect change

    or check (needsChange, btn_plus, btn_minus);

    mux2_4bit load (
        .Selector (needsChange),
        .D0 (Q),
        .D1 (calculated_Q),
        .Y (next_Q)
    );

    always @(posedge clk) begin
        Q <= next_Q;
    end

    // For benchtest
    initial begin
        Q = 4'b0000;
    end


endmodule
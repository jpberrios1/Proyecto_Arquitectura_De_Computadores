// Increment a 4 bit number by 1 or decrement it by 1 depending on the button pressed

module increment_decrement_4bit (
    input wire clk,
    input wire btn_plus,
    input wire btn_minus,
    output reg [3:0] r_Q
);
    wire [3:0] plus_val;
    wire [3:0] minus_val;

    increment_4bit incrementer (
        .current_value (r_Q),
        .incremented_value (plus_val)
    );

    decrement_4bit decrementer (
        .current_value (r_Q),
        .decremented_value (minus_val)
    );

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

module shift_right (
    input  wire [3:0] A,
    input  wire [1:0] S,
    output wire [3:0] R
);

    mux4 B0 (
        .Sel (S),
        .D0 (A[3]),
        .D1 (1'b0),
        .D2 (1'b0),
        .D3 (1'b0),
        .Y (R[3])
    );

   mux4 B1 (
        .Sel (S),
        .D0  (A[2]),
        .D1  (A[3]),
        .D2  (1'b0),
        .D3  (1'b0),
        .Y   (R[2])
    );

    mux4 B2 (
        .Sel (S),
        .D0  (A[1]),
        .D1  (A[2]),
        .D2  (A[3]),
        .D3  (1'b0),
        .Y   (R[1])
    );

    mux4 B3 (
        .Sel (S),
        .D0  (A[0]),
        .D1  (A[1]),
        .D2  (A[2]),
        .D3  (A[3]),
        .Y   (R[0])
    );


endmodule
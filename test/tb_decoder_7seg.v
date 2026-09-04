`timescale 1ns/1ps
module tb_decoder_7seg;

    reg F3, F2, F1, F0;
    wire A, B, C, D, E, F, G;

    integer errores = 0;

    decoder_7segment_display DUT (
        .x3 (F3), .x2 (F2), .x1 (F1), .x0 (F0),
        .A (A), .B (B), .C (C), .D (D), .E (E), .F (F), .G (G)
    );

    task check_digito;
        input [127:0] nombre;
        input [6:0] esperado; // orden: A B C D E F G
        reg [6:0] obtenido;
        begin
            obtenido = {A, B, C, D, E, F, G};
            if (obtenido !== esperado) begin
                $display("FALLO %0s: esperado=%b obtenido=%b", nombre, esperado, obtenido);
                errores = errores + 1;
            end else begin
                $display("OK    %0s: segmentos=%b", nombre, obtenido);
            end
        end
    endtask

    initial begin
        $dumpfile("prueba.vcd");
        $dumpvars(0, tb_decoder_7seg);

        {F3,F2,F1,F0} = 4'b0000; #10; check_digito("digito 0", 7'b1111110);
        {F3,F2,F1,F0} = 4'b0001; #10; check_digito("digito 1", 7'b0110000);
        {F3,F2,F1,F0} = 4'b0010; #10; check_digito("digito 2", 7'b1101101);
        {F3,F2,F1,F0} = 4'b0011; #10; check_digito("digito 3", 7'b1111001);
        {F3,F2,F1,F0} = 4'b0100; #10; check_digito("digito 4", 7'b0110011);
        {F3,F2,F1,F0} = 4'b0101; #10; check_digito("digito 5", 7'b1011011);
        {F3,F2,F1,F0} = 4'b0110; #10; check_digito("digito 6", 7'b1011111);
        {F3,F2,F1,F0} = 4'b0111; #10; check_digito("digito 7", 7'b1110000);
        {F3,F2,F1,F0} = 4'b1000; #10; check_digito("digito 8", 7'b1111111);

        if (errores == 0)
            $display("TODOS LOS TESTS PASARON");
        else
            $display("%0d TEST(S) FALLARON", errores);

        $finish;
    end

endmodule

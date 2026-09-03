`timescale 1ns/1ps
// ============================================================
// Testbench para fsm_controller
// Simula clicks de botones (presionar y soltar), reusando el
// mismo periodo de reloj de siempre (10ns, flancos en 5,15,25...)
//
// Ronda 1: codigo=Suma, op1=1, op2=2 (nuevo)      -> esperado 3
// Ronda 2: mismo codigo, op1=4, op2=usar anterior -> esperado 7
// ============================================================

module tb_fsm_controller;

    reg  clk;
    reg  inc_btn, dec_btn, confirm_btn, useprev_btn;
    wire [3:0] result;

    integer errores = 0;

    fsm_controller DUT (
        .clk         (clk),
        .inc_btn     (inc_btn),
        .dec_btn     (dec_btn),
        .confirm_btn (confirm_btn),
        .useprev_btn (useprev_btn),
        .result      (result)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    // ---- Tareas para simular un "click" de cada boton ----
    // Cada boton se sostiene 20ns (2 periodos de reloj completos,
    // asegura que cruce al menos un flanco limpio) y luego se suelta,
    // dejando 20ns de reposo antes del siguiente click.
    task click_inc;
        begin
            inc_btn = 1; #20; inc_btn = 0; #20;
        end
    endtask

    task click_dec;
        begin
            dec_btn = 1; #20; dec_btn = 0; #20;
        end
    endtask

    task click_confirm;
        begin
            confirm_btn = 1; #20; confirm_btn = 0; #20;
        end
    endtask

    task click_useprev;
        begin
            useprev_btn = 1; #20; useprev_btn = 0; #20;
        end
    endtask

    task check_result;
        input [127:0] nombre;
        input [3:0]   esperado;
        begin
            if (result !== esperado) begin
                $display("FALLO %0s: esperado=%b obtenido=%b", nombre, esperado, result);
                errores = errores + 1;
            end else begin
                $display("OK    %0s: resultado=%b", nombre, result);
            end
        end
    endtask

    initial begin
        $dumpfile("fsm_controller.vcd");
        $dumpvars(0, tb_fsm_controller);

        inc_btn = 0; dec_btn = 0; confirm_btn = 0; useprev_btn = 0;
        #20;

        // ================= RONDA 1 =================
        // codigo: 1 click de inc -> 001 (Suma)
        click_inc;
        click_confirm;   // confirma codigo, pasa a ingresar op1

        // op1: 1 click de inc -> 0001 (1)
        click_inc;
        click_confirm;   // confirma op1, pasa a ingresar op2

        // op2: 2 clicks de inc -> 0010 (2)
        click_inc;
        click_inc;
        click_confirm;   // confirma op2 -> EJECUTA: 1 + 2 = 3

        check_result("ronda 1: 1 + 2", 4'b0011);

        click_confirm;   // confirma resultado -> vuelve a ingresar_operacion

        // ================= RONDA 2 =================
        // codigo: no tocamos nada, se mantiene en Suma (001)
        click_confirm;   // confirma codigo (sin cambios), pasa a op1

        // op1: 3 clicks de inc mas -> de 0001 (1) sube a 0100 (4)
        click_inc;
        click_inc;
        click_inc;
        click_confirm;   // confirma op1, pasa a ingresar op2

        // op2: en vez de incrementar, usamos el resultado anterior (3)
        click_useprev;
        click_confirm;   // confirma op2 -> EJECUTA: 4 + 3 = 7

        check_result("ronda 2: 4 + anterior(3)", 4'b0111);

        // ---- Resumen ----
        if (errores == 0)
            $display("TODOS LOS TESTS PASARON");
        else
            $display("%0d TEST(S) FALLARON", errores);

        $finish;
    end

endmodule

`timescale 1ns/1ps
// ============================================================
// Testbench extenso para fsm_controller
// Cubre: Reinicio, Suma (con y sin overflow), Resta (positiva
// y negativa), Resta inversa, Shift left (con y sin overflow
// de signo), Shift right (verificando relleno con ceros),
// el toggle de "usar resultado anterior", y el ciclo completo
// de vuelta al estado inicial.
//
// Los contadores de codigo/op1/op2 NO se resetean entre rondas
// (es una decision de diseno), asi que cada ronda calcula sus
// clicks relativos a donde quedo el contador en la ronda
// anterior. El comentario de cada ronda documenta el valor
// resultante para que sea facil rastrear si algo falla.
// ============================================================

module tb_fsm_controller_completo;

    reg  clk;
    reg  inc_btn, dec_btn, confirm_btn, useprev_btn;
    wire [3:0] result;
    wire [1:0] current_state;
    wire [3:0] op1_val, op2_val, code;
    wire       select_op2;

    integer errores = 0;

    fsm_controller DUT (
        .clk           (clk),
        .inc_btn       (inc_btn),
        .dec_btn       (dec_btn),
        .confirm_btn   (confirm_btn),
        .useprev_btn   (useprev_btn),
        .result        (result),
        .current_state (current_state),
        .op1_val       (op1_val),
        .op2_val       (op2_val),
        .code          (code),
        .select_op2    (select_op2)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    task click_inc;     begin inc_btn=1;     #20; inc_btn=0;     #20; end endtask
    task click_dec;     begin dec_btn=1;     #20; dec_btn=0;     #20; end endtask
    task click_confirm; begin confirm_btn=1; #20; confirm_btn=0; #20; end endtask
    task click_useprev; begin useprev_btn=1; #20; useprev_btn=0; #20; end endtask

    task clicks_inc; input integer n; integer i; begin
        for (i = 0; i < n; i = i + 1) click_inc;
    end endtask

    task clicks_dec; input integer n; integer i; begin
        for (i = 0; i < n; i = i + 1) click_dec;
    end endtask

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

    task check_state;
        input [127:0] nombre;
        input [1:0]   esperado;
        begin
            if (current_state !== esperado) begin
                $display("FALLO %0s: estado esperado=%b obtenido=%b", nombre, esperado, current_state);
                errores = errores + 1;
            end else begin
                $display("OK    %0s: estado=%b", nombre, current_state);
            end
        end
    endtask

    initial begin
        $dumpfile("fsm_controller_completo.vcd");
        $dumpvars(0, tb_fsm_controller_completo);

        inc_btn = 0; dec_btn = 0; confirm_btn = 0; useprev_btn = 0;
        #20;

        // ===== RONDA 1: Reinicio (code=000) =====
        // code:0->0  op1:0->3  op2:0->5
        clicks_inc(0); click_confirm;
        clicks_inc(3); click_confirm;
        clicks_inc(5); click_confirm;
        check_result("Reinicio ignora op1/op2", 4'b0000);
        click_confirm; // vuelve a ingresar_operacion

        // ===== RONDA 2: Suma sin overflow (code=001) =====
        // code:0->1  op1:3->3  op2:5->4
        clicks_inc(1); click_confirm;
        clicks_inc(0); click_confirm;
        clicks_dec(1); click_confirm;
        check_result("Suma 3+4=7", 4'b0111);
        click_confirm;

        // ===== RONDA 3: Suma CON overflow (code=001) =====
        // code:1->1  op1:3->7  op2:4->3
        clicks_inc(0); click_confirm;
        clicks_inc(4); click_confirm;
        clicks_dec(1); click_confirm;
        check_result("Suma 7+3=10 -> wrap -6", 4'b1010);
        click_confirm;

        // ===== RONDA 4: Resta positiva (code=010) =====
        // code:1->2  op1:7->5  op2:3->2
        clicks_inc(1); click_confirm;
        clicks_dec(2); click_confirm;
        clicks_dec(1); click_confirm;
        check_result("Resta 5-2=3", 4'b0011);
        click_confirm;

        // ===== RONDA 5: Resta negativa (code=010) =====
        // code:2->2  op1:5->2  op2:2->5
        clicks_inc(0); click_confirm;
        clicks_dec(3); click_confirm;
        clicks_inc(3); click_confirm;
        check_result("Resta 2-5=-3", 4'b1101);
        click_confirm;

        // ===== RONDA 6: Resta inversa (code=011) =====
        // code:2->3  op1:2->2  op2:5->5
        clicks_inc(1); click_confirm;
        clicks_inc(0); click_confirm;
        clicks_inc(0); click_confirm;
        check_result("Resta inversa 5-2=3", 4'b0011);
        click_confirm;

        // ===== RONDA 7: Shift left sin overflow (code=100) =====
        // code:3->4  op1:2->1  op2:5->2 (shift=2)
        clicks_inc(1); click_confirm;
        clicks_dec(1); click_confirm;
        clicks_dec(3); click_confirm;
        check_result("Shift left 0001<<2=0100", 4'b0100);
        click_confirm;

        // ===== RONDA 8: Shift left CON overflow de signo (code=100) =====
        // code:4->4  op1:1->1  op2:2->3 (shift=3)
        clicks_inc(0); click_confirm;
        clicks_inc(0); click_confirm;
        clicks_inc(1); click_confirm;
        check_result("Shift left 0001<<3=1000 (-8)", 4'b1000);
        click_confirm;

        // ===== RONDA 9: Shift right (code=101) =====
        // code:4->5  op1:1->8 (1000)  op2:3->1 (shift=1)
        clicks_inc(1); click_confirm;
        clicks_inc(7); click_confirm;
        clicks_dec(2); click_confirm;
        check_result("Shift right 1000>>1=0100 (relleno con 0)", 4'b0100);
        click_confirm;

        // ===== RONDA 10: usar resultado anterior (1 click = SI lo usa) =====
        // code:5->1 (Suma)  op1:8->2  op2 sin tocar (queda en 1)
        clicks_dec(4); click_confirm;
        clicks_dec(6); click_confirm;
        click_useprev;      // 1 click: activa "usar anterior"
        click_confirm;      // ejecuta con B = ultimo resultado (0100 = 4)
        check_result("Usar anterior: 2+4=6", 4'b0110);
        click_confirm;

        // ===== RONDA 11: doble click en useprev = vuelve a op2 normal =====
        // code:1->1  op1:2->3  op2 sin tocar (sigue en 1)
        clicks_inc(0); click_confirm;
        clicks_inc(1); click_confirm;
        click_useprev;      // activa
        click_useprev;      // desactiva de nuevo (toggle)
        click_confirm;      // ejecuta con B = op2_val normal (1), NO el anterior
        check_result("Doble toggle cancela: 3+1=4 (no 3+6)", 4'b0100);
        click_confirm;

        // ===== RONDA 12: confirma el ciclo completo =====
        check_state("vuelve a ingresar_operacion tras confirmar resultado", 2'b00);

        // ---- Resumen ----
        if (errores == 0)
            $display("TODOS LOS TESTS PASARON");
        else
            $display("%0d TEST(S) FALLARON", errores);

        $finish;
    end

endmodule

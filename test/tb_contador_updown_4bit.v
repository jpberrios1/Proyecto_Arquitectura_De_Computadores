`timescale 1ns/1ps

module tb_contador_updown_4bit;

    reg        clk;
    reg        btn_inc;
    reg        btn_dec;
    wire [3:0] Q;

    // Instancia del módulo
    contador_masmenos_4bit DUT (
        .clk     (clk),
        .btn_plus (btn_inc),
        .btn_minus (btn_dec),
        .Q       (Q)
    );

    // Generador de reloj (periodo de 10ns)
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Configuración para GTKWave
        $dumpfile("prueba.vcd");
        $dumpvars(0, tb_contador_updown_4bit);

        // Imprimir resultados en la terminal
        $monitor("t=%0t | inc=%b dec=%b -> Q=%d (bin: %b)", $time, btn_inc, btn_dec, Q, Q);

        // Inicialización
        btn_inc = 0;
        btn_dec = 0;
        #15; // Esperar para alinear con el reloj

        // Prueba 1: Incrementar 3 veces (0 -> 1 -> 2 -> 3)
        $display("\n--- Iniciando Prueba de Incremento ---");
        btn_inc = 1;
        #30; 
        btn_inc = 0;
        #10;

        // Prueba 2: Decrementar 4 veces (3 -> 2 -> 1 -> 0 -> 15)
        $display("\n--- Iniciando Prueba de Decremento (con underflow) ---");
        btn_dec = 1;
        #40; 
        btn_dec = 0;
        #10;

        // Prueba 3: Mantener estado (Debería quedarse en 15)
        $display("\n--- Iniciando Prueba de Memoria (mantener estado) ---");
        #20;

        // Prueba 4: Presionar ambos a la vez
        // Por nuestro diseño, si btn_dec=1, se prioriza la resta.
        $display("\n--- Iniciando Prueba de Colisión (ambos presionados) ---");
        btn_inc = 1;
        btn_dec = 1;
        #20;
        btn_inc = 0;
        btn_dec = 0;
        #20;

        $finish;
    end

endmodule
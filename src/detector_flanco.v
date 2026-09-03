// Detector de flanco (one-shot)
// Convierte una senal sostenida (boton presionado) en un
// pulso de un solo ciclo de reloj, justo cuando el boton
// pasa de 0 a 1.

// Esto es porque presionar el boton puede durar varios ciclos de reloj, estropeando la logica de la calculadora

module detector_flanco (
    input  wire clk,
    input  wire button,
    output wire pulse
);
    reg delayed_button;

    always @(posedge clk) begin
        delayed_button <= button;
    end

    wire not_delayed_btn;
    not n1 (not_delayed_btn, delayed_button);

    and detect (pulse, button, not_delayed_btn);

endmodule
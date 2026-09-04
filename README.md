# Calculadora de 4 bits

Arquitectura de Computadores - Universidad de los Andes (2026-2).

## Integrantes

- Agustin Flores
- Ana Cecilia Lobo
- Juan Pablo Berrios

## El Programa

Este repositorio tiene todos los componentes necesarios para implementar una calculadora de 4 bits en complemento a 2 (numeros del -8 al 7) para una FPGA Lattice iCE40HX1K (Nandland Go Board). La logica combinacional de esta se realizo exclusivamente con compuertas lógicas (`and`, `or`, `not`, `xor`, `nor`, `xnor`, `buf`) y se evito el uso de funciones de mayor nivel en modulos secuenciales.

## Uso en la FPGA (secuencia de botones)

| Botón               | Función                                      |
|-------------------- | -------------------------------------------  |
| Superior-izquierdo  |  Incrementar el valor actual                 |
| Inferior-izquierdo  |  Decrementar el valor actual                 |
| Superior-derecho    |  Confirmar / avanzar / ejecutar              |
| Inferior-derecho    |  Usar el resultado anterior como op2 (toggle)|

### Flujo de Operacion

1. Aumentar o disminuir el codigo de la operacion a realizar visualizado por 3 LEDS
2. Aumentar o disminuir el primer operando
3. Decidir el segundo operando con el boton inferior-derecho con las siguientes opciones:
    - Usar operando nuevo, capaz de aumentar y disminuir su valor
    - Usar resultado de operacion anterior

    El boton funciona como un interruptor de uso que se reinicia cada ves que se entra a esta etapa y en el display se muestra que numero se utilizara.
4. Ver resultado en el display.
5. Volver al paso 1.

**Importante**: Para pasar de una etapa a la siguiente siempre se debe presionar el boton de confirmar (superior derecho)

#### Notas

- Los contadores de cada etapa (operacion, primer operando y segundo operando) no se reinician entre operaciones

- Los numeros van desde el -8 al 7 ciclando entre si si se fuera a entregar un numero mas grande

## Operaciones soportadas

| Código | Operación      | Resultado          |
|--------|----------------|--------------------|
| `000`  | Reinicio       | `R = 0000`         |
| `001`  | Suma           | `R = A + B`        |
| `010`  | Resta          | `R = A - B`        |
| `011`  | Resta inversa  | `R = B - A`        |
| `100`  | Shift left     | `R = A << B[1:0]`  |
| `101`  | Shift right    | `R = A >> B[1:0]`  |

Los códigos `110` y `111` no están definidos por el enunciado, pero por cómo está
construido el mux de selección, terminan comportándose exactamente igual que `100` y `101`
respectivamente.

## Estructura del archivos

```verilog
src/                              // Carpeta con archivos de la aplicacion
   |- 7_segment_display/
   |  |- absolute_value.v           
   |  |- decoder_7segment_display.v 
   |  |- display_selector.v         
   |- calculator_components/
   |  |- arithmetic_logic_unit/     
   |  |  |- arithmetic_logic_unit.v
   |  |  |- arithmetic_operation_selector.v
   |  |  |- full_adder_4bit.v
   |  |  |- full_adder.v
   |  |  |- inversor_4bit
   |  |- shifter/
   |  |  |- shift_left.v
   |  |  |- shift_right.v
   |  |  |- shifter
   |  |- shift_arithmetic_selection.v
   |- increment_decrement/       
   |  |- registers/
   |  |  |- register_1bit.v
   |  |  |- register_4bit.v
   |  |  |- state_register.v    
   |- display_selector.v            
   |- flank_detector.v              
   |- fsm_controller.v               
   |- looping_4bit_calculator.v      
   |- mux.v                          
   |- state_decoder.v                
   |- top.v                          
---- 

test/                             // Carpeta con archivos de TestBench
    |- tb_fsm_controller_completo.v  
----

go_board.pcf                      // Especificaciones de la tarjeta
Makefile                          // Archivo de Compilacion
```

## Prerequisitos

Para poder correr simulaciones, compilar el codigo o actualizar la placa FPGA segun las especificaciones de este repositorio se necesitan las siguientes herramientas

### Open-source FPGA Toolchain

- [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build) (Open-source FPGA Toolchain toold)
  - [Icarus Verilog](http://iverilog.icarus.com/)
  - [Yosys](https://yosyshq.readthedocs.io/projects/yosys/en/latest/)
  - [nextpnr-ice40](https://github.com/YosysHQ/nextpnr)
  - [iceprog](https://github.com/YosysHQ/icestorm/blob/main/iceprog/iceprog.c)

### Compilacion y conexion

- [GNU Make](https://www-geeksforgeeks-org.translate.goog/installation-guide/how-to-install-make-on-ubuntu/?_x_tr_sl=en&_x_tr_tl=es&_x_tr_hl=es&_x_tr_pto=tc&_x_tr_hist=true) (Seguir otra guia de instalacion si no corresponde al sistema)
- [usbipd-win](https://learn.microsoft.com/es-es/windows/wsl/connect-usb) (Solo para sistemas Windows con WSL)

## Cómo correr la simulación (Icarus Verilog + GTKWave)

```bash
make compile   # compila todos los .v de src/ y test/
make run       # corre la simulación 
make wave      # abre GTKWave con las señales grabadas de la simulacion
make clean     # borra los archivos generados
```

## Cómo programar la Go Board

```bash
make fpga   # sintetiza + place&route + empaqueta -> genera fpga_top.bin
make prog   # sube el bitstream a la placa por USB (podria pedir permisos sudo)
```

Si estás en WSL2, antes de `make prog` asegúrate de tener el dispositivo USB
adjunto a WSL (`usbipd attach --wsl --busid <BUSID>` desde PowerShell, una vez
por cada vez que se reconecta el cable o se reinicia WSL).

- Puedes revisar el `<BUSID>` usando el commando `usbipd list`

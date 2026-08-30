# Variables
CC = iverilog -g2012
SIMULATOR = vvp
TARGET = sim.vvp
WAVEFILE = calculadora.vcd
SRCS = $(shell find src test -name "*.v")
TB ?= test/tb_calculadora_combinacional.v

all: compile run

# Compilar todos los archivos .v en el ejecutable final
compile $(TARGET): $(SRCS)
	$(CC) -o $(TARGET) $(SRCS)

# Ejecutar la simulación
run: $(TARGET)
	$(SIMULATOR) $(TARGET)

test_calc:
	@$(MAKE) TB=test/tb_calculadora_combinacional.v

test_shift:
	@$(MAKE) TB=test/tb_shift_right.v

# Visualizar las ondas en GTKWave sin bloquear la terminal
wave:
	gtkwave $(WAVEFILE) &

clean:
	rm -f $(TARGET) *.vcd *.vvp

.PHONY: all compile run wave clean
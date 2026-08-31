# Variables
CC = iverilog -g2012
SIMULATOR = vvp
TARGET = sim.vvp
WAVEFILE = prueba.vcd
SRCS = $(shell find src test -name "*.v")

all: compile run

# Compilar todos los archivos .v en el ejecutable final
compile $(TARGET): $(SRCS)
	$(CC) -o $(TARGET) $(SRCS)

# Ejecutar la simulación
run: $(TARGET)
	$(SIMULATOR) $(TARGET)

# Visualizar las ondas en GTKWave sin bloquear la terminal
wave:
	gtkwave $(WAVEFILE) &

clean:
	rm -f $(TARGET) *.vcd *.vvp

.PHONY: all compile run wave clean
# Variables
CC = iverilog
SIMULATOR = vvp
TARGET = sim.vvp
WAVEFILE = prueba.vcd
SRCS = $(wildcard *.v)

all: compile run

# Compilar todos los archivos .v en el ejecutable final
compile $(TARGET): $(SRCS)
	$(CC) -g2012 -o $(TARGET) $(SRCS)

# Ejecutar la simulación
run: $(TARGET)
	$(SIMULATOR) $(TARGET)

# Visualizar las ondas en GTKWave sin bloquear la terminal
wave:
	gtkwave $(WAVEFILE) &

clean:
	rm -f $(TARGET) *.vcd *.vvp

.PHONY: all compile run wave clean
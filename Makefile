# Variables testing
CC = iverilog -g2012
SIMULATOR = vvp
TEST_TARGET = sim.vvp
WAVEFILE = wave.vcd
TEST_SRCS = $(shell find src test -name "*.v")

# FPGA Variables
FPGA_SRCS = $(shell find src -name "*.v")
TOP = fpga_top
PCF = go_board.pcf
DEVICE = hx1k
PACKAGE = vq100

all: compile run

# Compilar todos los archivos .v en el ejecutable final
compile $(TEST_TARGET): $(TEST_SRCS)
	$(CC) -o $(TEST_TARGET) $(TEST_SRCS)

# Ejecutar la simulación
run: $(TEST_TARGET)
	$(SIMULATOR) $(TEST_TARGET)

# Visualizar las ondas en GTKWave sin bloquear la terminal
wave:
	gtkwave $(WAVEFILE) &

clean:
	rm -f $(TEST_TARGET) *.vcd *.vvp
	rm -f $(TOP).json $(TOP).asc $(TOP).bin

$(TOP).json: $(FPGA_SRCS)
	yosys -p "synth_ice40 -top $(TOP) -json $(TOP).json" $(FPGA_SRCS)

$(TOP).asc: $(TOP).json $(PCF)
	nextpnr-ice40 --$(DEVICE) --package $(PACKAGE) --json $(TOP).json --pcf $(PCF) --asc $(TOP).asc

$(TOP).bin: $(TOP).asc
	icepack $(TOP).asc $(TOP).bin

fpga: $(TOP).bin
 
prog: $(TOP).bin
	iceprog $(TOP).bin

.PHONY: all compile run wave clean fpga prog
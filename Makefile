# ==============================
# User-selectable parameters
# ==============================
BLOCK ?= half_adder
IMPL  ?= behave

# Tools
LINT := verilator
SIM  := iverilog
RUN  := vvp
VIEW := gtkwave

# ==============================
# Derived paths
# ==============================
RTL_FILE  := rtl/$(IMPL)/$(BLOCK).v
TB_FILE   := tb/tb_$(BLOCK).v

BUILD_DIR := sim/build/$(IMPL)
WAVE_DIR  := sim/waves/$(IMPL)

OUT_BIN   := $(BUILD_DIR)/$(BLOCK).vvp
WAVE_FILE := $(WAVE_DIR)/$(BLOCK).vcd

# ==============================
# Default target
# ==============================
all: lint build run

# ==============================
# Lint (Verilator only)
# ==============================
lint:
	@echo "🔍 Linting RTL $(BLOCK) [$(IMPL)]"
	$(LINT) --lint-only -Wall \
		$(RTL_FILE)


# ==============================
# Build (Icarus compile)
# ==============================
build:
	@echo "🛠  Building $(BLOCK) [$(IMPL)]"
	mkdir -p $(BUILD_DIR) $(WAVE_DIR)
	$(SIM) -g2012 \
		-DWAVE_FILE=\"$(WAVE_FILE)\" \
		-o $(OUT_BIN) \
		$(RTL_FILE) $(TB_FILE)

# ==============================
# Run simulation
# ==============================
run:
	@echo "▶ Running simulation"
	$(RUN) $(OUT_BIN)

# ==============================
# View waveform
# ==============================
wave:
	$(VIEW) $(WAVE_FILE)

# ==============================
# Cleanup
# ==============================
clean:
	rm -rf sim/build/* sim/waves/*

.PHONY: all lint build run wave clean

# Verilog Learning Environment

A **personal Verilog learning environment**.

This repository exists to remove **tooling and organization friction** so users can focus on **writing RTL and testbenches**.
The **setup itself** is the point — not the RTL inside it.

RTL modules and testbenches here are **learning experiments** and may be wrong.
If something runs, it only means it **compiled and simulated**.

---

## Contents

* [What This Repository Is / Is Not](#what-this-repository-is--is-not)
* [Using the Environment (Required Rules)](#using-the-environment-required-rules)
* [Directory Structure](#directory-structure)
* [Tools Required (Fedora)](#tools-required-fedora)
* [Makefile Targets](#makefile-targets)
* [Disclaimer](#disclaimer)
* [License](#license)

---

## What This Repository Is / Is Not

### Provides

* Fixed directory structure
* Makefile-based simulation flow
* Interactive menu for running simulations
* Consistent naming conventions

### Does NOT Provide

* No correctness checking
* No verification enforcement
* No reference designs
* No teaching of Verilog concepts

---

## Using the Environment (Required Rules)

These rules are **mandatory**.
If they are not followed, the build **will fail** or behavior will be undefined.

### RTL Organization

RTL files must follow:

```
rtl/<implementation>/<block>.v
```

Examples:

```
rtl/behave/half_adder.v
rtl/flow/half_adder.v
rtl/gate/half_adder.v
```

The `<block>` name is used by the Makefile and menu system.

---

### Testbench Naming (MANDATORY)

Each block must have **exactly one testbench** named:

```
tb_<block>.v
```

Examples:

```
tb/tb_half_adder.v
tb/tb_full_adder.v
```

---

### Required Testbench Structure

Every testbench must follow this structure:

```verilog
`ifndef WAVE_FILE
  `error "WAVE_FILE not defined by Makefile"
`endif

module tb_<block>;

    // reg  : inputs driven by testbench
    // wire : outputs driven by DUT

    // Instantiate DUT
    // <block> dut ( ... );

    initial begin
        $dumpfile(`WAVE_FILE);
        $dumpvars(0, tb_<block>);

        // test stimulus here

        $finish;
    end

endmodule
```

#### Why this structure exists

* `WAVE_FILE` is passed by the Makefile
* Prevents silent waveform failures
* Enforces consistent simulation behavior
* Testbenches must not hardcode paths
* One top-level control block keeps flow predictable

This is an **environment requirement**, not a Verilog rule.

---

### Running the Environment

#### Menu (recommended)

Before running the menu for the first time, make it executable (run once):

```bash
chmod +x menu.sh
```

Run the menu:

```bash
./menu.sh
```

The menu:

* Detects available blocks
* Filters valid implementations
* Shows only valid actions
* Includes a clean option

#### Makefile

```
make BLOCK=<block> IMPL=<impl> <target>
```

Example:

```
make BLOCK=half_adder IMPL=behave build
```

---

## Directory Structure

```
rtl/        RTL implementations
tb/         Testbenches
sim/build/  Generated simulation binaries
sim/waves/  Generated waveform files
menu.sh     Interactive runner
Makefile    Build control
```

The `sim/` directory is part of the repository structure.
Generated files inside `sim/build/` and `sim/waves/` are ignored by Git.

---

## Tools Required (Fedora)

```
sudo dnf install -y iverilog verilator gtkwave make
```

---

## Makefile Targets

```
lint   Lint RTL using Verilator
build  Compile RTL + TB
run    Run simulation
wave   Open waveform
all    lint → build → run
clean  Remove build and wave files
```

---

## Disclaimer

This environment guarantees:

* Correct tool invocation
* Consistent file organization

It does **not** guarantee:

* RTL correctness
* Testbench validity
* Meaningful results

Learning and debugging are the user’s responsibility.

---

## License

[MIT License](LICENSE)

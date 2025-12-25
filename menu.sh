#!/usr/bin/env bash
set -e

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
RTL_DIR="$ROOT_DIR/rtl"

echo "=============================="
echo " RTL Simulation Menu"
echo "=============================="
echo

# -------------------------------------------------
# Discover blocks and which implementations have them
# -------------------------------------------------
declare -A BLOCK_MAP

for impl_path in "$RTL_DIR"/*; do
    [ -d "$impl_path" ] || continue
    impl="$(basename "$impl_path")"

    for vfile in "$impl_path"/*.v; do
        [ -e "$vfile" ] || continue
        block="$(basename "$vfile" .v)"
        BLOCK_MAP["$block"]+="$impl "
    done
done

if [ ${#BLOCK_MAP[@]} -eq 0 ]; then
    echo "❌ No RTL blocks found"
    exit 1
fi

# -------------------------------------------------
# 1) Select BLOCK
# -------------------------------------------------
blocks=("${!BLOCK_MAP[@]}" "clean")

echo "Select block:"
select BLOCK in "${blocks[@]}"; do
    [[ -n "$BLOCK" ]] || { echo "Invalid choice, try again."; continue; }

    if [[ "$BLOCK" == "clean" ]]; then
        echo
        echo "=============================="
        echo "Running command:"
        echo "make clean"
        echo "=============================="
        make clean
        exit 0
    fi

    break
done

echo
echo "Selected block: $BLOCK"


# -------------------------------------------------
# 2) Select IMPLEMENTATION (filtered)
# -------------------------------------------------
impls=(${BLOCK_MAP["$BLOCK"]})

echo
echo "Available implementations for '$BLOCK':"
select IMPL in "${impls[@]}"; do
    [[ -n "$IMPL" ]] && break
    echo "Invalid choice, try again."
done

echo
echo "Selected implementation: $IMPL"

# -------------------------------------------------
# 3) Select ACTION (descriptive, single menu)
# -------------------------------------------------
BUILD_FILE="$ROOT_DIR/sim/build/$IMPL/$BLOCK.vvp"
WAVE_FILE="$ROOT_DIR/sim/waves/$IMPL/$BLOCK.vcd"

actions=()
descs=()

# Always available
actions+=("lint")
descs+=("Lint RTL using Verilator")

actions+=("build")
descs+=("Compile RTL + TB using Icarus Verilog")

# Conditional
if [ -f "$BUILD_FILE" ]; then
    actions+=("run")
    descs+=("Run simulation (vvp)")
fi

if [ -f "$WAVE_FILE" ]; then
    actions+=("wave")
    descs+=("Open waveform in GTKWave")
fi

actions+=("all")
descs+=("Lint + build + run")

echo
echo "Select action:"
for i in "${!actions[@]}"; do
    printf "  %2d) %-6s – %s\n" $((i+1)) "${actions[$i]}" "${descs[$i]}"
done

while true; do
    read -p "Enter choice: " choice
    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#actions[@]} )); then
        ACTION="${actions[$((choice-1))]}"
        break
    fi
    echo "Invalid choice, try again."
done

echo
echo "=============================="
echo "Running command:"
echo "make IMPL=$IMPL BLOCK=$BLOCK $ACTION"
echo "=============================="
echo

make IMPL="$IMPL" BLOCK="$BLOCK" "$ACTION"


# Hexadecimal Keypad Scanner – Grayhill 072

## Project Overview
This project implements a **Hexadecimal Keypad Scanner** for the **Grayhill 072 4x4 matrix keypad**. It detects key presses, decodes them into a 4-bit code (0–F), and provides a valid signal for further digital processing. The system is fully implemented in **Verilog** and is suitable for **FPGA/ASIC** deployment.

---

## Features
- Detects all **16 keys** on a 4x4 keypad (0–F).
- Implements **synchronized row scanning** to avoid metastability.
- **Finite State Machine (FSM)** for sequential column scanning.
- Provides:
  - `Code` – 4-bit binary representing the key pressed.
  - `Valid` – High when a valid key press is detected.
  - `Col` – Column scanning signal.
- Works with **one-hot key press simulation** for testing.

---

## Key Mapping (Grayhill 072)

|        | Col0 | Col1 | Col2 | Col3 |
|--------|------|------|------|------|
| **Row0** | 0    | 1    | 2    | 3    |
| **Row1** | 4    | 5    | 6    | 7    |
| **Row2** | 8    | 9    | A    | B    |
| **Row3** | C    | D    | E    | F    |

---

## Modules

### 1. `Hex_Keypad_Grayhill_072.v`
- **Description**: Core keypad decoder module.
- **Inputs**:
  - `Row[3:0]` – Row lines from keypad.
  - `S_Row` – Synchronized row signal.
  - `clock` – System clock.
  - `reset` – Active-high asynchronous reset.
- **Outputs**:
  - `Code[3:0]` – Binary code of the pressed key.
  - `Valid` – High if a valid key is pressed.
  - `Col[3:0]` – Column scanning signal.
- **Operation**:
  - FSM with six states scans columns sequentially.
  - Detects pressed key based on row-column combination.
  - Outputs the corresponding 4-bit code.

---

### 2. `Row_Signal.v`
- **Description**: Generates row signals for the pressed key.
- **Inputs**:
  - `Key[15:0]` – One-hot encoded key press signal.
  - `Col[3:0]` – Column scan lines.
- **Output**:
  - `Row[3:0]` – Row signals to the keypad decoder.
- **Operation**:
  - Combinational logic maps each key and column combination to a row.
  - Ensures correct row signal corresponding to pressed key.

---

### 3. `Synchronizer.v`
- **Description**: Synchronizes asynchronous row signals with the system clock.
- **Inputs**:
  - `Row[3:0]` – Row signals from `Row_Signal`.
  - `clock` – System clock.
  - `reset` – Active-high asynchronous reset.
- **Output**:
  - `S_Row` – Synchronized row signal.
- **Operation**:
  - Two-stage register captures row signal.
  - Prevents metastability in digital processing.

---

### 4. `test_Hex_Keypad.v`
- **Description**: Testbench for the keypad scanner.
- **Functionality**:
  - Generates clock and reset signals.
  - Simulates **one-hot key press sequences** for all keys (0–F).
  - Monitors `Code` and `Valid` outputs.
- **Simulation Parameters**:
  - Clock period: 10 ns (100 MHz)
  - Total simulation: 2000 ns
- **Modules instantiated**:
  - `Hex_Keypad_Grayhill_072`
  - `Row_Signal`
  - `Synchronizer`

---



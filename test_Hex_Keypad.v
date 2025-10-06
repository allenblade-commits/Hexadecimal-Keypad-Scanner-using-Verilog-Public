`timescale 1ns / 1ps
/*******************************************************************************************
* File Name      : test_Hex_Keypad.v
* Author         : Allen Stanley
* Project        : Hexadecimal Keypad Testbench
* Description    : 
*   This testbench is designed to simulate and verify the operation of the 
*   Hex_Keypad_Grayhill_072 module. It stimulates the keypad by generating 
*   one-hot key press patterns and observes the corresponding outputs.
*
*   The testbench includes:
*       - Clock and reset signal generation
*       - Key press simulation for all hexadecimal keys (0-F)
*       - Mapping of pressed keys to string representations
*       - Instantiation of the DUT (Device Under Test): Hex_Keypad_Grayhill_072
*       - Support modules: Row_Signal and Synchronizer
*
* Simulation Time : 2000 ns
* Clock Period    : 10 ns (100 MHz)
* Date            : October 2025
********************************************************************************************/

module test_Hex_Keypad ();

    // ----------------------------- //
    // Output and Wire Declarations  //
    // ----------------------------- //
    wire [3:0] Code;        // 4-bit output code representing the pressed key
    wire Valid;             // High when a valid key press is detected
    wire [3:0] Col;         // Column lines for keypad scanning
    wire [3:0] Row;         // Row lines for keypad scanning
    wire [3:0] S_Row;       // Synchronized row signal (from Synchronizer module)

    // ----------------------------- //
    // Input and Register Declarations
    // ----------------------------- //
    reg clock, reset;       // Clock and Reset signals
    reg [15:0] Key;         // 16-bit one-hot encoded signal to represent key press
    reg [39:0] Pressed;     // Stores string representation of currently pressed key

    // ----------------------------- //
    // Parameter Declarations        //
    // ----------------------------- //
    // Parameters to represent key labels as strings
    parameter [39:0] Key_0 = "Key_0";
    parameter [39:0] Key_1 = "Key_1";
    parameter [39:0] Key_2 = "Key_2";
    parameter [39:0] Key_3 = "Key_3";
    parameter [39:0] Key_4 = "Key_4";
    parameter [39:0] Key_5 = "Key_5";
    parameter [39:0] Key_6 = "Key_6";
    parameter [39:0] Key_7 = "Key_7";
    parameter [39:0] Key_8 = "Key_8";
    parameter [39:0] Key_9 = "Key_9";
    parameter [39:0] Key_A = "Key_A";
    parameter [39:0] Key_B = "Key_B";
    parameter [39:0] Key_C = "Key_C";
    parameter [39:0] Key_D = "Key_D";
    parameter [39:0] Key_E = "Key_E";
    parameter [39:0] Key_F = "Key_F";
    parameter [39:0] None  = "None";

    // ----------------------------- //
    // Integer Declarations          //
    // ----------------------------- //
    integer j, k; // Loop control variables

    // ----------------------------- //
    // Key Press Decoding Logic      //
    // ----------------------------- //
    // This always block maps the 16-bit one-hot Key input to a string label
    always @(Key) begin
        case (Key)
            16'h0000: Pressed = None;    // No key pressed
            16'h0001: Pressed = Key_0;   // Key 0
            16'h0002: Pressed = Key_1;   // Key 1
            16'h0004: Pressed = Key_2;   // Key 2
            16'h0008: Pressed = Key_3;   // Key 3
            16'h0010: Pressed = Key_4;
            16'h0020: Pressed = Key_5;
            16'h0040: Pressed = Key_6;
            16'h0080: Pressed = Key_7;
            16'h0100: Pressed = Key_8;
            16'h0200: Pressed = Key_9;
            16'h0400: Pressed = Key_A;
            16'h0800: Pressed = Key_B;
            16'h1000: Pressed = Key_C;
            16'h2000: Pressed = Key_D;
            16'h4000: Pressed = Key_E;
            16'h8000: Pressed = Key_F;
            default:  Pressed = None;
        endcase
    end

    // ----------------------------- //
    // Module Instantiations         //
    // ----------------------------- //
    // DUT (Device Under Test)
    Hex_Keypad_Grayhill_072 M1 (
        .Row(Row),
        .S_Row(S_Row),
        .clock(clock),
        .reset(reset),
        .Code(Code),
        .Valid(Valid),
        .Col(Col)
    );

    // Row signal generator to simulate key press mapping
    Row_Signal M2 (
        .Key(Key),
        .Col(Col),
        .Row(Row)
    );

    // Synchronizer for row signals
    Synchronizer M3 (
        .Row(Row),
        .clock(clock),
        .reset(reset),
        .S_Row(S_Row)
    );

    // ----------------------------- //
    // Clock and Reset Generation    //
    // ----------------------------- //
    initial #2000 $finish;                  // End simulation after 2000 ns
    initial begin clock = 0; forever #5 clock = ~clock; end  // 10 ns clock period
    initial begin reset = 1; #10 reset = 0; end              // Reset deasserted after 10 ns

    // ----------------------------- //
    // Key Press Simulation Sequence //
    // ----------------------------- //
    initial begin
        for (k = 0; k <= 1; k = k + 1) begin
            Key = 0;  // Initialize with no key pressed
            #20;
            for (j = 0; j <= 16; j = j + 1) begin
                #20 Key[j] = 1;   // Simulate a key press
                #60 Key = 0;      // Release the key
            end
        end
    end

endmodule

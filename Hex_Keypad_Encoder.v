`timescale 1ns / 1ps
/*******************************************************************************************
* File Name      : Hex_Keypad_Grayhill_072.v
* Author         : Allen Stanley
* Project        : Hexadecimal Keypad Interface
* Description    : 
*   This module decodes key presses from a Grayhill 072 4x4 hexadecimal keypad.
*   It scans the keypad columns sequentially and detects the asserted row, generating:
*       - 4-bit Code corresponding to the pressed key (0-F)
*       - Valid signal indicating a valid key press
*       - Column output for scanning
*
*   Key mapping (Row x Col):
*       Col[0] Col[1] Col[2] Col[3]
* Row[0]    0       1       2       3
* Row[1]    4       5       6       7
* Row[2]    8       9       A       B
* Row[3]    C       D       E       F
*
* Inputs:
*   - Row    : 4-bit row signals from keypad
*   - S_Row  : Synchronized row signal
*   - clock  : System clock
*   - reset  : Active-high asynchronous reset
*
* Outputs:
*   - Code   : 4-bit code representing the pressed key
*   - Valid  : High when a valid key press is detected
*   - Col    : Column signal for scanning
*
* Operation:
*   - Implements a finite state machine (FSM) with 6 states to scan columns and detect keys.
*   - Generates one-hot column signals for scanning.
*   - Decodes the combination of Row and Col to output the corresponding key Code.

********************************************************************************************/

module Hex_Keypad_Grayhill_072(
    input  [3:0] Row,       // Row signals from keypad
    input        S_Row,      // Synchronized row signal
    input        clock,      // System clock
    input        reset,      // Active-high asynchronous reset
    output reg [3:0] Code,   // 4-bit key code (0-F)
    output       Valid,      // High when a valid key is detected
    output reg [3:0] Col     // Column signals for scanning
);

    // ----------------------------- //
    // FSM State Declarations        //
    // ----------------------------- //
    reg [5:0] state, next_state;

    // One-hot encoded states for FSM
    parameter S_0 = 6'b000001, // Assert all columns
              S_1 = 6'b000010, // Assert column 0
              S_2 = 6'b000100, // Assert column 1
              S_3 = 6'b001000, // Assert column 2
              S_4 = 6'b010000, // Assert column 3
              S_5 = 6'b100000; // All columns active for detection

    // ----------------------------- //
    // Valid Signal Logic            //
    // ----------------------------- //
    assign Valid = ((state == S_1) || (state == S_2) || (state == S_3) || (state == S_4)) && Row;

    // ----------------------------- //
    // Key Decoding Logic             //
    // ----------------------------- //
    // Combinational decoding based on Row and Col combination
    always @ (Row or Col)
        case ({Row, Col})
            8'b0001_0001: Code = 0; 8'b0001_0010: Code = 1;
            8'b0001_0100: Code = 2; 8'b0001_1000: Code = 3;
            8'b0010_0001: Code = 4; 8'b0010_0010: Code = 5;
            8'b0010_0100: Code = 6; 8'b0010_1000: Code = 7;
            8'b0100_0001: Code = 8; 8'b0100_0010: Code = 9;
            8'b0100_0100: Code = 10; // A
            8'b0100_1000: Code = 11; // B
            8'b1000_0001: Code = 12; // C
            8'b1000_0010: Code = 13; // D
            8'b1000_0100: Code = 14; // E
            8'b1000_1000: Code = 15; // F
            default:       Code = 0;  // Arbitrary choice
        endcase

    // ----------------------------- //
    // FSM Sequential Logic           //
    // ----------------------------- //
    always @(posedge clock or posedge reset)
        if (reset)
            state <= S_0;
        else
            state <= next_state;

    // ----------------------------- //
    // FSM Next-State Logic           //
    // ----------------------------- //
    always @(state or S_Row or Row) begin
        next_state = state;  // Default to hold current state
        Col = 0;             // Default column signals

        case (state)
            // Assert all columns and wait for key press
            S_0: begin
                Col = 4'b1111;
                if (S_Row) next_state = S_1;
            end
            // Assert column 0
            S_1: begin
                Col = 4'b0001;
                if (Row) next_state = S_5; else next_state = S_2;
            end
            // Assert column 1
            S_2: begin
                Col = 4'b0010;
                if (Row) next_state = S_5; else next_state = S_3;
            end
            // Assert column 2
            S_3: begin
                Col = 4'b0100;
                if (Row) next_state = S_5; else next_state = S_4;
            end
            // Assert column 3
            S_4: begin
                Col = 4'b1000;
                if (Row) next_state = S_5; else next_state = S_0;
            end
            // All columns active while a key is pressed
            S_5: begin
                Col = 4'b1111;
                if (Row == 0) next_state = S_0;
            end
        endcase
    end

endmodule

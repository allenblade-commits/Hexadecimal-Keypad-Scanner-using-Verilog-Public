`timescale 1ns / 1ps
/*******************************************************************************************
* File Name      : Row_Signal.v
* Author         : Allen Stanley
* Project        : Hexadecimal Keypad Interface
* Description    : 
*   This module generates the **row signals** for a 4x4 matrix keypad based on the
*   pressed key and the currently scanned column lines.
*   
*   Inputs:
*       - Key : 16-bit one-hot encoded key press input (Key[0] to Key[15])
*       - Col : 4-bit column lines representing the currently scanned column
*   
*   Outputs:
*       - Row : 4-bit output representing the active row lines corresponding to
*               the pressed key and current column
*
* Operation:
*   - Each Row[i] becomes active when a key in that row is pressed AND its
*     corresponding column is active.
*   - The module uses combinational logic to generate the Row signals.

********************************************************************************************/

module Row_Signal(
    input  [15:0] Key,  // 16-bit one-hot key input
    input  [3:0]  Col,  // 4-bit column scan lines
    output reg [3:0] Row // 4-bit output row lines
);

    // -----------------------------------------------------------------------------
    // Combinational logic for row signals:
    // - Each Row[i] is the OR of the ANDs between keys in that row and their 
    //   corresponding column signals.
    // - Example: Row[0] = (Key[0] AND Col[0]) OR (Key[1] AND Col[1]) ...
    // -----------------------------------------------------------------------------
    always @(Key or Col) begin
        Row[0] = (Key[0]  && Col[0]) || (Key[1]  && Col[1]) || (Key[2]  && Col[2]) || (Key[3]  && Col[3]);
        Row[1] = (Key[4]  && Col[0]) || (Key[5]  && Col[1]) || (Key[6]  && Col[2]) || (Key[7]  && Col[3]);
        Row[2] = (Key[8]  && Col[0]) || (Key[9]  && Col[1]) || (Key[10] && Col[2]) || (Key[11] && Col[3]);
        Row[3] = (Key[12] && Col[0]) || (Key[13] && Col[1]) || (Key[14] && Col[2]) || (Key[15] && Col[3]);
    end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Name: Allen Stanley
// 
// Description: 
// --------------------------------------------------------------------------------
// This module is used to synchronize asynchronous keypad row signals (`Row[3:0]`)
// with the system clock. It prevents metastability and ensures clean, reliable
// signal transitions for further processing in the keypad decoder logic.
//
// The synchronization is done using a two-stage register mechanism:
//
//   • `A_Row` captures the OR'ed state of all row inputs.
//   • `S_Row` follows `A_Row` on the next clock cycle.
//
// The module operates on the **negative edge** of the clock and supports an
// asynchronous **active-high reset** to initialize internal registers.
//
// --------------------------------------------------------------------------------

// --------------------------------------------------------------------------------

//////////////////////////////////////////////////////////////////////////////////

module Synchronizer(
    input  [3:0] Row,   // Input: 4-bit row lines from the keypad matrix
    input        clock, // Input: System clock signal
    input        reset, // Input: Active-high asynchronous reset
    output reg   S_Row  // Output: Synchronized row signal
);

    // Intermediate register for first stage of synchronization
    reg A_Row;

    // -----------------------------------------------------------------------------
    // Two-stage synchronization process:
    // Triggered on the negative edge of the clock or positive edge of reset.
    // -----------------------------------------------------------------------------
    always @ (negedge clock or posedge reset)
    begin
        if (reset) 
        begin
            // Reset condition: clear both synchronizer stages
            A_Row <= 1'b0;
            S_Row <= 1'b0;
        end
        else 
        begin
            // Stage 1: Capture whether any row line is active (logic OR)
            A_Row <= (Row[0] || Row[1] || Row[2] || Row[3]);
            
            // Stage 2: Output synchronized signal
            S_Row <= A_Row;
        end 
    end
        
endmodule

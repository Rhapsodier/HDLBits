/* 
Synchronous HDLC framing involves decoding a continuous bit stream of data to look for bit patterns that indicate the beginning and end of frames (packets). Seeing exactly 6 consecutive 1s (i.e., 01111110) is a "flag" that indicate frame boundaries. To avoid the data stream from accidentally containing "flags", the sender inserts a zero after every 5 consecutive 1s which the receiver must detect and discard. We also need to signal an error if there are 7 or more consecutive 1s.

Create a finite state machine to recognize these three sequences:

0111110: Signal a bit needs to be discarded (disc).
01111110: Flag the beginning/end of a frame (flag).
01111111...: Error (7 or more 1s) (err).
When the FSM is reset, it should be in a state that behaves as though the previous input were 0.

Here are some example sequences that illustrate the desired operation.
 */

 module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);

module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err
);
    
    parameter S0 = 0;
    parameter S1 = 1;
    parameter S2 = 2;
    parameter S3 = 3;
    parameter S4 = 4;
    parameter S5 = 5;
    parameter S6 = 6;
    parameter S7 = 7;
    parameter S_DISC = 8;
    parameter S_FLAG = 9;
    
    reg [3:0] state, next_state;
    
    always @(posedge clk) begin
        if (reset) 
            state <= S0;
        else 
            state <= next_state;
    end
    
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S_DISC;
            S6: next_state = in ? S7 : S_FLAG;
            S7: next_state = in ? S7 : S0;
            S_DISC: next_state = in ? S1 : S0;
            S_FLAG: next_state = in ? S1 : S0;
            default: next_state = S0;
        endcase
    end
    
    assign disc = (state == S_DISC);
    assign flag = (state == S_FLAG);
    assign err = (state == S7);

endmodule

endmodule

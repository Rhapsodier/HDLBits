/* 
Given the following state machine with 1 input and 2 outputs:



Suppose this state machine uses one-hot encoding, where state[0] through state[9] correspond to the states S0 though S9, respectively. The outputs are zero unless otherwise specified.

Implement the state transition logic and output logic portions of the state machine (but not the state flip-flops). You are given the current state in state[9:0] and must produce next_state[9:0] and the two outputs. Derive the logic equations by inspection assuming a one-hot encoding. (The testbench will test with non-one hot inputs to make sure you're not trying to do something more complicated).
 */

  module top_module(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2);

always @(*) begin
    
    next_state[9] = state[6] & ~in;
    next_state[8] = state[5] & ~in;
    next_state[7] = (state[6] & in) || (state[7] & in);
for(int i=2; i<7; i++)
begin
    next_state[i] = state[i-1] & in;
end
    next_state[1] = (state[0] & in) || (state[8] & in) || (state[9] & in);
    next_state[0] = (~in & (state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9])); 
    
    end

assign out1 = state[9] | state[8];
assign out2 = state[9] | state[7];
endmodule
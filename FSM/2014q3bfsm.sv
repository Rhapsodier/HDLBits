/* 
Given the state-assigned table shown below, implement the finite-state machine. Reset should reset the FSM to state 000.

Present state
y[2:0]	Next state Y[2:0]	Output z
x=0	x=1
000	000	001	0
001	001	100	0
010	010	001	0
011	001	010	1
100	011	100	1
 */

 module top_module (
    input clk,
    input reset,   // Synchronous reset
    input x,
    output z
);

reg [2:0] state, next_state;
parameter A = 0, B = 1, C = 2, D = 3, E = 4;

always @(*) begin
    case(state)
A : next_state = x ? B : A;
B : next_state = x ? E : B;
C : next_state = x ? B : C;
D : next_state = x ? C : B;
E : next_state = x ? E : D;
    endcase
end

always @(posedge clk) begin
    if (reset)
    state <= A;
    else
    state <= next_state;
end

assign z = (state == D) || (state == E);

endmodule

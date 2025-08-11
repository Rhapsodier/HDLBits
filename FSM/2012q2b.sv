/* 
The state diagram for this question is shown again below.



Assume that a one-hot code is used with the state assignment y[5:0] = 000001(A), 000010(B), 000100(C), 001000(D), 010000(E), 100000(F)

Write a logic expression for the signal Y1, which is the input of state flip-flop y[1].

Write a logic expression for the signal Y3, which is the input of state flip-flop y[3].

(Derive the logic equations by inspection assuming a one-hot encoding. The testbench will test with non-one hot inputs to make sure you're not trying to do something more complicated).
 */

 module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);
    assign Y1 = w & y[0];
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule

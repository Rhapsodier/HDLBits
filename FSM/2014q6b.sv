/* 
Consider the state machine shown below, which has one input w and one output z.



Assume that you wish to implement the FSM using three flip-flops and state codes y[3:1] = 000, 001, ... , 101 for states A, B, ... , F, respectively. Show a state-assigned table for this FSM. Derive a next-state expression for the flip-flop y[2].

Implement just the next-state logic for y[2]. (This is much more a FSM question than a Verilog coding question. Oh well.) 
*/

module top_module (
    input [3:1] y,
    input w,
    output Y2);
    reg[2:0] state,next_state;
    parameter A=0,B=1,C=2,D=3,E=4,F=5;
    always@(*)begin
        case(y)
        	A:next_state=w?A:B;
            B:next_state=w?D:C;
            C:next_state=w?D:E;
            D:next_state=w?A:F;
            E:next_state=w?D:E;
            F:next_state=w?D:C;
            default:next_state=A;
        endcase      
    end
    assign Y2=(next_state==C)||(next_state==D);
 
endmodule
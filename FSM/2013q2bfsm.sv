/* 
Consider a finite state machine that is used to control some type of motor. The FSM has inputs x and y, which come from the motor, and produces outputs f and g, which control the motor. There is also a clock input called clk and a reset input called resetn.

The FSM has to work as follows. As long as the reset input is asserted, the FSM stays in a beginning state, called state A. When the reset signal is de-asserted, then after the next clock edge the FSM has to set the output f to 1 for one clock cycle. Then, the FSM has to monitor the x input. When x has produced the values 1, 0, 1 in three successive clock cycles, then g should be set to 1 on the following clock cycle. While maintaining g = 1 the FSM has to monitor the y input. If y has the value 1 within at most two clock cycles, then the FSM should maintain g = 1 permanently (that is, until reset). But if y does not become 1 within two clock cycles, then the FSM should set g = 0 permanently (until reset).

(The original exam question asked for a state diagram only. But here, implement the FSM.)
 */

 module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input x,
    input y,
    output f,
    output g
); 
    reg [3:0] state,next_state;
    parameter A=4'b0000,B=4'b0001,S0=4'b0011,S1=4'b0010,S2=4'b0110,S3=4'b0111,
    choose=4'b1111,forerver_zero=4'b1110,forerver_one=4'b1101;
    
    always@(posedge clk)begin
        if(~resetn)
            state <= A;
        else
            state <= next_state;
    end
    
    always@(*)begin
        case(state)
            A:begin
                next_state <= B;
                f <= 0;
                g <= 0;
            end
            B:begin
                next_state <= S0;
                f <= 1;
                g <= 0;
            end
            S0:begin
            	next_state <= x ? S1:S0;
                f <= 0;
                g <= 0;
            end
            S1:begin
                next_state <= x ? S1:S2;
                f <= 0;
                g <= 0;
            end
            S2:begin
                next_state <= x ? S3:S0;
                f <= 0;
                g <= 0;
            end
            S3:begin
                next_state <= y ? forerver_one:choose;
                f <= 0;
                g <= 1;
            end
            choose:begin
                next_state <= y ? forerver_one:forerver_zero;
                f <= 0;
                g <= 1;
            end
            forerver_zero:begin
                next_state <= forerver_zero;
                f <= 0;
                g <= 0;
            end
            forerver_one:begin
                next_state <= forerver_one;
                f <= 0;
                g <= 1;
            end
            default:begin
                next_state <= A;
                f <= 0;
                g <= 0;
            end
        endcase
    end
endmodule

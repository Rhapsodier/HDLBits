/* 
Consider a finite state machine with inputs s and w. Assume that the FSM begins in a reset state called A, as depicted below. The FSM remains in state A as long as s = 0, and it moves to state B when s = 1. Once in state B the FSM examines the value of the input w in the next three clock cycles. If w = 1 in exactly two of these clock cycles, then the FSM has to set an output z to 1 in the following clock cycle. Otherwise z has to be 0. The FSM continues checking w for the next three clock cycles, and so on. The timing diagram below illustrates the required values of z for different values of w.

Use as few states as possible. Note that the s input is used only in state A, so you need to consider just the w input.
 */

module top_module (
    input clk,
    input reset,   // Synchronous reset
    input s,
    input w,
    output z
);

    parameter A=1'b0, B=1'b1;
    reg state, next_state;
    reg [1:0] cycle_cnt;  
    reg [1:0] w_cnt;      
    reg delayed_z;       
    

    always @(*) begin
        case(state)
            A: next_state = s ? B : A;
            B: next_state = B;
            default: next_state = A;
        endcase
    end
    
    always @(posedge clk) begin
        if(reset)
            state <= A;
        else
            state <= next_state;
    end
    

    always @(posedge clk) begin
        if(reset) begin
            cycle_cnt <= 2'b0;
            w_cnt <= 2'b0;
            delayed_z <= 1'b0;
        end
        else if(state == B) begin
            if(cycle_cnt == 2) begin 
             
                delayed_z <= (w_cnt + w) == 2;
                cycle_cnt <= 2'b0;
                w_cnt <= 2'b0;
            end
            else begin
                cycle_cnt <= cycle_cnt + 1'b1;
                w_cnt <= w_cnt + w;
                delayed_z <= 1'b0;
            end
        end
        else begin  
            cycle_cnt <= 2'b0;
            w_cnt <= 2'b0;
            delayed_z <= 1'b0;
        end
    end
    
  
    assign z = delayed_z;
endmodule
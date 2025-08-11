/* 
This is the second component in a series of five exercises that builds a complex counter out of several smaller circuits. See the final exercise for the overall design.

Build a finite-state machine that searches for the sequence 1101 in an input bit stream. When the sequence is found, it should set start_shifting to 1, forever, until reset. Getting stuck in the final state is intended to model going to other states in a bigger FSM that is not yet implemented. We will be extending this FSM in the next few exercises.
 */

 module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output start_shifting);
    
    reg [2:0] state,next_state;
    parameter S0=3'b000,S1=3'b001,S2=3'b011,S3=3'b010,S4=3'b110;
    
    always@(posedge clk)begin
        if(reset)
            state <= S0;
        else
            state <= next_state;
    end
    
    always@(*)begin
        case(state)
            S0:begin
                next_state = data ? S1:S0;
                start_shifting = 0;
            end
            S1:begin
                next_state = data ? S2:S0;
                start_shifting = 0;
            end
            S2:begin
                next_state = data ? S2:S3;
                start_shifting = 0;
            end
            S3:begin
                next_state = data ? S4:S0;
                start_shifting = 0;
            end
            S4:begin
                next_state = S4;
                start_shifting = 1;
            end
        endcase
    end

endmodule
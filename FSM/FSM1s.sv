/* 
This is a Moore state machine with two states, one input, and one output. Implement this state machine. Notice that the reset state is B.

This exercise is the same as fsm1, but using synchronous reset.
 */

 // Note the Verilog-1995 module declaration syntax here:
module top_module(clk, reset, in, out);
    input clk;
    input reset;    // Synchronous reset to state B
    input in;
    output out;//  

    parameter A=0, B=1; 
    reg state, next_state;

    always @(*) begin    // This is a combinational always block
        // State transition logic
    case (state)
      A : next_state = in ? A : B;
      B : next_state = in ? B : A;
    endcase
    end

    always @(posedge clk) begin    // This is a sequential always block
        // State flip-flops with asynchronous reset
        if(reset)
        state <= B;
        else
        state <= next_state;
    end

    // Output logic
    // assign out = (state == ...);
    assign out = state;
endmodule

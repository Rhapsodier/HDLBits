/* 
You are to design a one-input one-output serial 2's complementer Moore state machine. The input (x) is a series of bits (one per clock cycle) beginning with the least-significant bit of the number, and the output (Z) is the 2's complement of the input. The machine will accept input numbers of arbitrary length. The circuit requires an asynchronous reset. The conversion begins when Reset is released and stops when Reset is asserted.
 */

module top_module (
    input clk,
    input areset,
    input x,
    output z
); 
   parameter A = 1'b0;
    parameter B = 1'b1;

    reg state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            A: next_state = x ? B : A;
            B: next_state = B;
            default: next_state = A;
        endcase
    end

    always @(*) begin
        case (state)
            A: z = x;        
            B: z = ~x;       
            default: z = 0;
        endcase
    end

endmodule
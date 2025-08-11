/* 
You are to design a one-input one-output serial 2's complementer Moore state machine. The input (x) is a series of bits (one per clock cycle) beginning with the least-significant bit of the number, and the output (Z) is the 2's complement of the input. The machine will accept input numbers of arbitrary length. The circuit requires an asynchronous reset. The conversion begins when Reset is released and stops when Reset is asserted.
 */
module top_module (
    input clk,
    input areset,
    input x,
    output z
);
    reg state, next_state;
    parameter KEEP = 0;  
    parameter INVERT = 1;

    always @(*) begin
        case(state)
            KEEP: next_state = x ? INVERT : KEEP;
            INVERT: next_state = INVERT;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        if(areset)
            state <= KEEP;
        else
            state <= next_state;
    end

    always @(posedge clk, posedge areset) begin
        if(areset)
            z <= 0;
        else begin
            case(state)
                KEEP: z <= x;    
                INVERT: z <= ~x;  
            endcase
        end
    end
endmodule
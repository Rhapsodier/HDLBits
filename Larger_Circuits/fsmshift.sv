/* 
This is the third component in a series of five exercises that builds a complex counter out of several smaller circuits. See the final exercise for the overall design.

As part of the FSM for controlling the shift register, we want the ability to enable the shift register for exactly 4 clock cycles whenever the proper bit pattern is detected. We handle sequence detection in Exams/review2015_fsmseq, so this portion of the FSM only handles enabling the shift register for 4 cycles.

Whenever the FSM is reset, assert shift_ena for 4 cycles, then 0 forever (until reset).
 */

module top_module (
    input clk,
    input reset,      // Synchronous reset
    output shift_ena);
    
    reg state,next_state;
    reg [2:0] count;
    parameter IDLE = 0, ENA = 1;
    
    always@(posedge clk)begin
        if(reset)begin
            state <= ENA;
            count <= 0;
        end
        else begin
            state <= next_state;
            count <= count + 1;
        end
    end
    
    always@(*)begin
        case(state)
            IDLE :begin
                next_state = IDLE;
                shift_ena = 0;
            end
            ENA :begin
                if(count<4) begin
                    next_state = ENA;
                    shift_ena = 1;
                end
                else begin
                    next_state = IDLE;
                    shift_ena = 0;
                end
            end
         endcase
    end

endmodule
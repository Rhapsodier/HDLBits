/* 
We want to add parity checking to the serial receiver. Parity checking adds one extra bit after each data byte. We will use odd parity, where the number of 1s in the 9 bits received must be odd. For example, 101001011 satisfies odd parity (there are 5 1s), but 001001011 does not.

Change your FSM and datapath to perform odd parity checking. Assert the done signal only if a byte is correctly received and its parity check passes. Like the serial receiver FSM, this FSM needs to identify the start bit, wait for all 9 (data and parity) bits, then verify that the stop bit was correct. If the stop bit does not appear when expected, the FSM must wait until it finds a stop bit before attempting to receive the next byte.

You are provided with the following module that can be used to calculate the parity of the input stream (It's a TFF with reset). The intended use is that it should be given the input bit stream, and reset at appropriate times so it counts the number of 1 bits in each byte.

module parity (
    input clk,
    input reset,
    input in,
    output reg odd);

    always @(posedge clk)
        if (reset) odd <= 0;
        else if (in) odd <= ~odd;

endmodule

Note that the serial protocol sends the least significant bit first, and the parity bit after the 8 data bits.
 */

 module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

    parameter IDLE = 0, DATA = 1, CHECK = 2, STOP = 3, ERROR = 4;
    
    reg[2:0] state, next_state;
    reg[3:0] cnt;
    reg[7:0] out;
    reg check;
    wire odd, start;
    
    parity parity_inst(
        .clk(clk),
        .reset(reset | start),
        .in(in),
        .odd(odd));    
    
    //transition
    always@(*)begin
        start = 0;
        case(state)
            IDLE:begin 
              next_state = in?IDLE:DATA; 
              start=1;
            end
            DATA:
              next_state = (cnt==8)?CHECK:DATA;
            CHECK:
              next_state = in?STOP:ERROR;
            STOP:begin 
              next_state=in?IDLE:DATA; 
              start=1; 
            end
            ERROR:
              next_state = in?IDLE:ERROR;
        endcase
    end
    
    //state
    always@(posedge clk)begin
        if(reset)
            state<=IDLE;
        else
            state<=next_state;
    end
    
    //cnt
    always@(posedge clk)begin
        if(reset)
            cnt<=0;
        else
            case(state)
                DATA:cnt<=cnt+1;
                default:cnt<=0;
            endcase
    end
    
    //out
    always@(posedge clk)begin
        if(reset)
            out<=0;
        else
            case(next_state)
                DATA:out<={in,out[7:1]};
            endcase
    end
    
    //check
    always@(posedge clk)begin
        if(reset)
            check<=0;
        else
            check<=odd;
    end
    
    assign out_byte=out;
    assign done=check&(state==STOP);
                
endmodule
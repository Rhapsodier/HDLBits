/* 
In many (older) serial communications protocols, each data byte is sent along with a start bit and a stop bit, to help the receiver delimit bytes from the stream of bits. One common scheme is to use one start bit (0), 8 data bits, and 1 stop bit (1). The line is also at logic 1 when nothing is being transmitted (idle).

Design a finite state machine that will identify when bytes have been correctly received when given a stream of bits. It needs to identify the start bit, wait for all 8 data bits, then verify that the stop bit was correct. If the stop bit does not appear when expected, the FSM must wait until it finds a stop bit before attempting to receive the next byte.
 */

  module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 

reg[11:0] state, next_state;
reg[1:0] abnormal_state, next_abnormal_state;
/* 采用one_hot编码，s0为start_bit,当中为数据位，s9为end_bit,s11为IDLE，s10为WAIT */

always @(*) begin

next_state[0] = (state[9] & ~in) || (state[11] & ~in);

for(int i=1; i<9; i++)
begin
    
next_state[i] = state[i-1];

end

next_state[9] = (state[8] & in) || (state[10] & in);
next_state[11] = (state[11] & in) || (state[9] & in);
next_state[10] = (state[10] & ~in) || (state[8] & ~in);
end

always @(posedge clk) begin
    if(reset)
    state <= 12'h800;
    else
    state <= next_state;
end

always @(posedge clk) begin
    if((next_state[9] == 1) && (state[10] != 1))
    done <= 1;
    else
    done <= 0;
end



endmodule

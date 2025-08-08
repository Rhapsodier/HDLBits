/* 
Now that you have a finite state machine that can identify when bytes are correctly received in a serial bitstream, add a datapath that will output the correctly-received data byte. out_byte needs to be valid when done is 1, and is don't-care otherwise.

Note that the serial protocol sends the least significant bit first.
 */

  module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

reg[7:0] datapath;
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

always @(posedge clk) begin
 if(reset)
 datapath <= 8'h00;
 else 
 begin
for(int i=1; i<9; i++)begin
    datapath[i-1] <= next_state[i] ? in : datapath[i-1];    
end
 end
end

assign out_byte = done ? datapath : 8'h00;

endmodule

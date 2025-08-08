/* 
Now that you have a state machine that will identify three-byte messages in a PS/2 byte stream, add a datapath that will also output the 24-bit (3 byte) message whenever a packet is received (out_bytes[23:16] is the first byte, out_bytes[15:8] is the second byte, etc.).

out_bytes needs to be valid whenever the done signal is asserted. You may output anything at other times (i.e., don't-care).
 */

  module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
    output done); //

reg [1:0]state, next_state;
parameter S1 = 0, S2 = 1, S3 = 2, DONE = 3;
reg [23:0] datapath;
always @(*) begin
    case(state)
    
    S1:
    begin
       next_state = in[3] ? S2 : S1;
    end 
    S2: begin
        next_state = S3;
    end
    S3:
    begin
         next_state = DONE;
    end 
    DONE: 
    begin 
        next_state = in[3] ? S2 : S1;
    end
    endcase
end

always @(posedge clk) begin
    if(reset) begin
    state <= S1;
    end
    else
    state <= next_state;
end

always @(posedge clk) begin
   if(reset) begin
    datapath = 24'h0;
    end
    else begin
    case (state)
    
    S1: datapath[23:16] <= in;
    S2: datapath[15:8] <= in;
    S3: datapath[7:0] <= in;
    DONE: 
         begin
           if(in[3])
           datapath[23:16] <= in;
           else datapath <= datapath; 
        end

    endcase
    end
    end
assign done = (state == DONE);
assign out_bytes = done ? datapath : 32'h0;
endmodule

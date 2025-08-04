 module top_module(
    input in,
    input clk,
    input areset,
    output out); //
reg state[3:0], next_state[3:0];
    parameter A=0, B=1, C=2, D=3;

   always @(*) begin
   next_state[A] = (~in & state[A]) || (~in & state[C]);
   next_state[B] = (in & state[B]) || (in & state[A]) || (in & state[D]);
   next_state[C] = (~in & state[B]) || (~in & state[D]);
   next_state[D] = (in & state[C]);
   end
    
   always @(posedge clk, posedge areset) begin
    if(areset) begin
    state[A] <= 1 ;
    state[B] <= 0;
    state[C] <= 0;
    state[D] <= 0;
   end
    else
    state <= next_state;
   end 
    assign out = (state[D] == 1);

endmodule

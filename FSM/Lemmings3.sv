/* 
See also: Lemmings1 and Lemmings2.

In addition to walking and falling, Lemmings can sometimes be told to do useful things, like dig (it starts digging when dig=1). LEFT Lemming can dig if it is currently walking on ground (ground=1 and not falling), and will continue digging until it reaches the other side (ground=0). LEFTt that point, since there is no ground, it will fall (aaah!), then continue walking in its original direction once it hits ground again. LEFTs with falling, being bumped while digging has no effect, and being told to dig when falling or when there is no ground is ignored.

(In other words, a walking Lemming can fall, dig, or switch directions. If more than one of these conditions are satisfied, fall has higher precedence than dig, which has higher precedence than switching directions.)

Extend your finite state machine to model this behaviour.
 */

 module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 
   
reg [1:0]state, next_state, mem_state;
parameter LEFT = 0, RIGHT = 1, FALL = 2, DIG = 3;


    always @(*) begin
   case(state)
   
   LEFT : 
   if (~ground)
   next_state = FALL;
   else if(dig)
   next_state = DIG;
   else begin
   next_state = bump_left ? RIGHT : LEFT;
   mem_state = LEFT;
   end

   RIGHT : 
   if (~ground)
   next_state = FALL;
   else if(dig)
   next_state = DIG;
   else begin
   next_state = bump_right ? LEFT : RIGHT;
   mem_state = RIGHT;
   end
   
   DIG :
   if(~ground)
   next_state = FALL;
   else  begin
   next_state = DIG;
   end

    FALL :
    if (~ground)
    next_state = FALL;
    else begin
    next_state = mem_state;
    end
    endcase
    end

    always @(posedge clk, posedge areset) begin
    if(areset) 
    state <= LEFT;
    else
    state <= next_state;
    end

assign walk_left = (state == LEFT);
assign walk_right = (state == RIGHT);
assign aaah = (state == FALL);
assign digging = (state == DIG);
endmodule

/* 
See also: Lemmings1, Lemmings2, and Lemmings3.

Although Lemmings can walk, fall, and dig, Lemmings aren't invulnerable. If a Lemming falls for too long then hits the ground, it can splatter. In particular, if a Lemming falls for more than 20 clock cycles then hits the ground, it will splatter and cease walking, falling, or digging (all 4 outputs become 0), forever (Or until the FSM gets reset). There is no upper limit on how far a Lemming can fall before hitting the ground. Lemmings only splatter when hitting the ground; they do not splatter in mid-air.

Extend your finite state machine to model this behaviour.

Falling for 20 cycles is survivable:
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
   
reg [2:0]state, next_state, mem_state;
int dead_count;
parameter LEFT = 0, RIGHT = 1, FALL = 2, DIG = 3, DEAD = 4;


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
        next_state = (dead_count > 5'd20) ? DEAD : mem_state;
    end

    DEAD :
    next_state = DEAD;

    endcase
    end



    always @(posedge clk, posedge areset) begin
    if(areset) begin
    state <= LEFT;
    dead_count <= 0;
    end
        else if(state == FALL && ~ground) begin
        dead_count <= dead_count + 1;
        end
    else begin
        state <= next_state;
            dead_count <= 0; 
    end
    end

always @(*) begin
 walk_left = (state == LEFT);
 walk_right = (state == RIGHT);
 aaah = (state == FALL);
 digging = (state == DIG);
 if(state == DEAD)
 {walk_left, walk_right, aaah, digging} = 4'b0000;
end
endmodule
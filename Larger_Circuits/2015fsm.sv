/* 
This is the fourth component in a series of five exercises that builds a complex counter out of several smaller circuits. See the final exercise for the overall design.

You may wish to do FSM: Enable shift register and FSM: Sequence recognizer first.

We want to create a timer that:

is started when a particular pattern (1101) is detected,
shifts in 4 more bits to determine the duration to delay,
waits for the counters to finish counting, and
notifies the user and waits for the user to acknowledge the timer.
In this problem, implement just the finite-state machine that controls the timer. The data path (counters and some comparators) are not included here.

The serial data is available on the data input pin. When the pattern 1101 is received, the state machine must then assert output shift_ena for exactly 4 clock cycles.

After that, the state machine asserts its counting output to indicate it is waiting for the counters, and waits until input done_counting is high.

At that point, the state machine must assert done to notify the user the timer has timed out, and waits until input ack is 1 before being reset to look for the next occurrence of the start sequence (1101).

The state machine should reset into a state where it begins searching for the input sequence 1101.

Here is an example of the expected inputs and outputs. The 'x' states may be slightly confusing to read. They indicate that the FSM should not care about that particular input signal in that cycle. For example, once a 1101 pattern is detected, the FSM no longer looks at the data input until it resumes searching after everything else is done.
 */

module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output shift_ena,
    output counting,
    input done_counting,
    output done,
    input ack );
    parameter A=0,B=1,C=2,D=3,E=4,F=5,G=6;
    
    reg [3:0] state,n_state,count;
       
    always@(posedge clk)begin
        if(reset)
            count<=4'd0;
        else if(state==E)begin
            if(count==4'd3)
                count<=0;
            else
                count <=count+1'b1;
        end
        else
            count<=count;     
    end
    
    always@(*)begin
        case(state)
            A:n_state = (data==1)?B:A;
            B:n_state = (data==1)?C:A;
            C:n_state = (data==0)?D:C;
            D:n_state = (data==1)?E:A;
            E:n_state = (count==4'd3)?F:E;
            F:n_state = (done_counting==1)?G:F;
            G:n_state = (ack==1)?A:G;
        endcase
    end
    
    always@(posedge clk)begin
        if(reset)
            state<=A;
        else
            state<=n_state;
    end
    
    assign shift_ena =(state==E)?1:0;
    assign counting = (state==F)?1:0;
    assign done =(state==G)?1:0;
 
endmodule
/* 
This is the fifth component in a series of five exercises that builds a complex counter out of several smaller circuits. You may wish to do the four previous exercises first (counter, sequence recognizer FSM, FSM delay, and combined FSM).

We want to create a timer with one input that:

is started when a particular input pattern (1101) is detected,
shifts in 4 more bits to determine the duration to delay,
waits for the counters to finish counting, and
notifies the user and waits for the user to acknowledge the timer.
The serial data is available on the data input pin. When the pattern 1101 is received, the circuit must then shift in the next 4 bits, most-significant-bit first. These 4 bits determine the duration of the timer delay. I'll refer to this as the delay[3:0].

After that, the state machine asserts its counting output to indicate it is counting. The state machine must count for exactly (delay[3:0] + 1) * 1000 clock cycles. e.g., delay=0 means count 1000 cycles, and delay=5 means count 6000 cycles. Also output the current remaining time. This should be equal to delay for 1000 cycles, then delay-1 for 1000 cycles, and so on until it is 0 for 1000 cycles. When the circuit isn't counting, the count[3:0] output is don't-care (whatever value is convenient for you to implement).

At that point, the circuit must assert done to notify the user the timer has timed out, and waits until input ack is 1 before being reset to look for the next occurrence of the start sequence (1101).

The circuit should reset into a state where it begins searching for the input sequence 1101.

Here is an example of the expected inputs and outputs. The 'x' states may be slightly confusing to read. They indicate that the FSM should not care about that particular input signal in that cycle. For example, once the 1101 and delay[3:0] have been read, the circuit no longer looks at the data input until it resumes searching after everything else is done. In this example, the circuit counts for 2000 clock cycles because the delay[3:0] value was 4'b0001. The last few cycles starts another count with delay[3:0] = 4'b1110, which will count for 15000 cycles.
 */

 module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack );

    parameter [3:0] S     = 4'd0;
    parameter [3:0] S1    = 4'd1;
    parameter [3:0] S11   = 4'd2;
    parameter [3:0] S110  = 4'd3;
    parameter [3:0] B0    = 4'd4;
    parameter [3:0] B1    = 4'd5;
    parameter [3:0] B2    = 4'd6;
    parameter [3:0] B3    = 4'd7;
    parameter [3:0] COUNT = 4'd8;
    parameter [3:0] WAIT  = 4'd9;
    
    reg [3:0] cs,ns;
    
    always @(posedge clk)begin
        if(reset)
            cs <= S;
        else
            cs <= ns;
    end
    
    always @(*)begin
        ns = S;
        case(cs)
            S:    ns= data? S1:S;
            S1:   ns= data? S11:S;
            S11:  ns= data? S11:S110;
            S110: ns= data? B0:S;
            B0:   ns= B1;
            B1:   ns= B2;
            B2:   ns= B3;
            B3:   ns= COUNT;
            COUNT:ns= (count == 0 && end_cnt)? WAIT:COUNT;
            WAIT: ns= ack? S:WAIT;
            default: ns=S;
        endcase
    end
    
    reg [3:0] delay = 4'd0;
    always @(posedge clk)begin
        if(reset)
            delay <= 4'd0;
        else begin
            case(cs)
                B0:delay<= {delay[2:0],data};
                B1:delay<= {delay[2:0],data};
                B2:delay<= {delay[2:0],data};
                B3:delay<= {delay[2:0],data};
                COUNT:begin
                    if(end_cnt)
                        delay <= delay -1;
                end
            endcase
        end
    end
    
    reg [9:0] cnt;
    wire add_cnt,end_cnt;
    always @(posedge clk)begin
        if(reset)
            cnt <= 10'd0;
        else if(add_cnt)begin
            if(end_cnt)begin
                cnt <=0;
            end
            else begin
                cnt <= cnt + 1'b1;     
            end
        end
    end
    assign add_cnt = (cs == COUNT)&(delay>=0);
    assign end_cnt = add_cnt && (cnt==999);
    
    assign count   = delay;
    assign counting= (cs==COUNT);
    assign done    = (cs==WAIT);
endmodule
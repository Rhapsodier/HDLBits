module top_module ();
    
    reg clk,reset,t,q;
    
    tff U1(.clk(clk),
           .reset(reset),
           .t(t),
           .q(q));
    
    initial begin
        clk = 0;
        t = 0;
        reset = 0;
    end
    
    always begin
        #5;
        clk = ~clk;
    end
    
    initial begin
        reset = 1'b0;
        #3;
        reset = 1'b1;
        #10;
        reset = 1'b0;   
    end
    
    always@(posedge clk)begin
        if(reset)
            t = 1;
        else
            t = 0;
    end
    

endmodule

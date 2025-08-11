module top_module ( );
    
    reg clk;
    
    dut U1(.clk(clk));
    
    initial begin
        clk = 0;
    end
    
    always begin
        #5;
        clk = ~clk;
    end

endmodule

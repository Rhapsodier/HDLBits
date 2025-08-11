module top_module();
    
    reg a,b,out;
    
    initial begin
        a = 0;
        b = 0;
        #10;
        a = 0;
        b = 1;
        #10;
        a = 1;
        b = 0;
        #10;
        a = 1;
        b = 1;
    end
    
    andgate U1({a,b},out);

endmodule

module top_module (input a, input b, input c, output out);//
    
    wire out_0;

    andgate inst1 (out_0, a, b, c, 1'b1 , 1'b1);
    
    assign out = ~out_0;

endmodule

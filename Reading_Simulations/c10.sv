module top_module (
    input clk,
    input a,
    input b,
    output q,
    output state  );
    
    always @(posedge clk) state <= state ? a|b : a&b;
    assign q = a^b^state;

endmodule

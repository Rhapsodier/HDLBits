module top_module (
    input [4:1] x, 
    output f );
//~x1x3+ x2x4
assign f = (~x[1] & x[3]) | (x[2] & x[4]);
endmodule

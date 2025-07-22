module top_module (
    input [4:1] x,
    output f
); 
assign f = (~x[2] & ~x[4]) | (~x[1] & x[3]) | (x[1] & x[2] & x[3] & x[4]);
endmodule

//~x2 ~x4 + ~x1 x3 + x1 x2 x3 x4
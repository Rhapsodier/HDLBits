module top_module (
    input in1,
    input in2,
    input in3,
    output out);
wire out1;
assign out1 = in1 ^ in2;
assign out = ~(out1 ^ in3); 
endmodule

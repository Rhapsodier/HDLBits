/*
For each bit in an 8-bit vector, detect when the input signal changes from one clock cycle to the next (detect any edge). The output bit should be set the cycle after a 0 to 1 transition occurs.

Here are some examples. For clarity, in[1] and anyedge[1] are shown separately
*/
module top_module (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);
reg [7:0]pre;
always @(posedge clk) begin
    pre <= in;
    anyedge <= in ^ pre;
end
endmodule

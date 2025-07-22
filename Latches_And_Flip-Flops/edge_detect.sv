/*
For each bit in an 8-bit vector, detect when the input signal changes from 0 in one clock cycle to 1 the next (similar to positive edge detection). The output bit should be set the cycle after a 0 to 1 transition occurs.

Here are some examples. For clarity, in[1] and pedge[1] are shown separately.
*/

module top_module (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);
reg [7:0] pre;
always @(posedge clk) begin
pre <= in;
pedge <= in & ~pre;
end
endmodule


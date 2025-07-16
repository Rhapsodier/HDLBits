/*
One drawback of the ripple carry adder (See previous exercise) is that the delay for an adder to compute the carry out (from the carry-in, in the worst case) is fairly slow, and the second-stage adder cannot begin computing its carry-out until the first-stage adder has finished. This makes the adder slow. One improvement is a carry-select adder, shown below. The first-stage adder is the same as before, but we duplicate the second-stage adder, one assuming carry-in=0 and one assuming carry-in=1, then using a fast 2-to-1 multiplexer to select which result happened to be correct.

In this exercise, you are provided with the same module add16 as the previous exercise, which adds two 16-bit numbers with carry-in and produces a carry-out and 16-bit sum. You must instantiate three of these to build the carry-select adder, using your own 16-bit 2-to-1 multiplexer.

Connect the modules together as shown in the diagram below. The provided module add16 has the following declaration:

module add16 ( input[15:0] a, input[15:0] b, input cin, output[15:0] sum, output cout );

*/

module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
wire [15:0] w1, w2, w3, w4, sum_low, sum_high_0, sum_high_1;
wire cout_low;
assign w1 = a[15:0];
assign w2 = a[31:16];
assign w3 = b[15:0];
assign w4 = b[31:16];
add16 add_low (w1, w3, 0, sum_low, cout_low);
add16 add_high_0 (w2, w4, 0, sum_high_0, );
add16 add_high_1 (w2, w4, 1, sum_high_1, );
always @ (*) begin
    case (cout_low)
      0  : sum = {sum_high_0, sum_low};
      1  : sum = {sum_high_1, sum_low};
    endcase
end
assign sum = {sum_high, sum_low};
endmodule

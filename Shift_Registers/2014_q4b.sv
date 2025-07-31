/* Write a top-level Verilog module (named top_module) for the shift register, assuming that n = 4. Instantiate four copies of your MUXDFF subcircuit in your top-level module. Assume that you are going to implement the circuit on the DE2 board.

Connect the R inputs to the SW switches,
clk to KEY[0],
E to KEY[1],
L to KEY[2], and
w to KEY[3].
Connect the outputs to the red lights LEDR[3:0].
(Reuse your MUXDFF from exams/2014_q4a.) */
module top_module (
    input [3:0] SW,
    input [3:0] KEY,
    output [3:0] LEDR
); //
MUXDFF mux0(KEY[0], KEY[3], SW[3], KEY[1], KEY[2], LEDR[3]);
MUXDFF mux1(KEY[0], LEDR[3], SW[2], KEY[1], KEY[2], LEDR[2]);
MUXDFF mux2(KEY[0], LEDR[2], SW[1], KEY[1], KEY[2], LEDR[1]);
MUXDFF mux3(KEY[0], LEDR[1], SW[0], KEY[1], KEY[2], LEDR[0]);
endmodule


module MUXDFF (
    input clk,
    input w, R, E, L,
    output Q
);
wire w1,w2;
assign w1 = E ? w : Q;
assign w2 = L ? R : w1;
always @(posedge clk) begin
    Q <= w2;
end
endmodule

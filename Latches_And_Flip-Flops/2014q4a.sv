//Write a Verilog module named top_module for one stage of this circuit, including both the flip-flop and multiplexers.
//https://hdlbits.01xz.net/wiki/File:Exams_2014q4.png

module top_module (
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

//Given the finite state machine circuit as shown, assume that the D flip-flops are initially reset to zero before the machine begins.

module top_module (
    input clk,
    input x,
    output z
); 
wire x0, x1, x2;
reg q0, q1, q2;
assign x0 = q0 ^ x;
assign x1 = ~q1 & x;
assign x2 = ~q2 | x;
always @(posedge clk) begin
    q0 <= x0;
    q1 <= x1;
    q2 <= x2;
end
assign z = ~(q0 | q1 | q2);
endmodule

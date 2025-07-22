//Create 8 D flip-flops. All DFFs should be triggered by the positive edge of clk.

module top_module (
    input clk,
    input [7:0] d,
    output [7:0] q
);
always @(posedge clk) begin
    q <= d;
    
end
endmodule

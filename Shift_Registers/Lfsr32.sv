//Build a 32-bit Galois LFSR with taps at bit positions 32, 22, 2, and 1. 

module top_module(
    input clk,
    input reset,    // Active-high synchronous reset to 32'h1
    output [31:0] q
); 
always @(posedge clk) begin
    if(reset)
    q <= 32'h1;
    else begin
        q[31] <= 1'b0 ^ q[0];
        for(int i=1; i<32; i++) begin
            if(i==22 || i==2 || i==1)
            q[i-1] <= q[i] ^ q[0];
            else
            q[i-1] <= q[i];
        end 
    end
end
endmodule
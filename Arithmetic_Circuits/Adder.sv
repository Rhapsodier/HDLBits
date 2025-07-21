module top_module (
    input [3:0] x,
    input [3:0] y, 
    output [4:0] sum);
wire cout[3:0];
assign sum[0] = x[0] + y[0]; 
assign cout[0] =  x[0] & y[0];
always @(*) begin
    for(int i = 1; i<4; i++) begin
        cout[i] = (x[i] & y[i]) | (y[i] & cout[i-1]) | (x[i] & cout[i-1]);
        sum[i] = x[i] + y[i] + cout[i-1];
    end
sum[4] = cout[3];
end
endmodule
// sum = x + y;

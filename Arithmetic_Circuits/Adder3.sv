/*
Now that you know how to build a full adder, make 3 instances of it to create a 3-bit binary ripple-carry adder. The adder adds two 3-bit numbers and a carry-in to produce a 3-bit sum and carry out. To encourage you to actually instantiate full adders, also output the carry-out from each full adder in the ripple-carry adder. cout[2] is the final carry-out from the last full adder, and is the carry-out you usually see.
*/
module top_module( 
    input [2:0] a, b,
    input cin,
    output [2:0] cout,
    output [2:0] sum );
assign sum = a + b + cin;
assign cout[0] =  (a[0] & b[0]) | (b[0] & cin) | (a[0] & cin);
always @(*) begin
    for(int i = 1; i<3; i++) begin
        cout[i] = (a[i] & b[i]) | (b[i] & cout[i-1]) | (a[i] & cout[i-1]);
    end
end
endmodule

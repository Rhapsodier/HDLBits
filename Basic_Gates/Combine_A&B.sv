/*
Taken from 2015 midterm question 4
See mt2015_q4a and mt2015_q4b for the submodules used here. The top-level design consists of two instantiations each of subcircuits A and B, as shown below.
https://hdlbits.01xz.net/wiki/File:Mt2015_q4.png
*/

/*
不能使用嵌套
module top_module (input x, input y, output z);
wire za1, za2, zb1, zb2;
module circuit_A (input x, input y, output z);
assign z = (x^y) & x;
endmodule

module circuit_B (input x, input y, output z);
assign z = ~(x ^ y);
endmodule

circuit_A A1(
    x, y, za1
);
circuit_A A2(
    x, y, za2
);
circuit_B B1(
    x, y, zb1
);
circuit_B B2(
    x, y, zb2
);
assign z = (za1 | zb1) ^ (za2 & zb2);

endmodule
*/


module top_module (input x, input y, output z);
wire za1, za2, zb1, zb2;
always @(*) begin
za1 = (x^y) & x;
za2 = (x^y) & x;
zb2 = ~(x ^ y);
zb1 = ~(x ^ y);
z = (za1 | zb1) ^ (za2 & zb2);
end
endmodule
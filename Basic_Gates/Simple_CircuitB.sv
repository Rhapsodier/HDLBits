/*
Circuit B can be described by the following simulation waveform:
https://hdlbits.01xz.net/wiki/File:Mt2015_q4b.png
*/
module top_module ( input x, input y, output z );
assign z = ~(x ^ y);
endmodule

/* Build a 4-digit BCD (binary-coded decimal) counter. Each decimal digit is encoded using 4 bits: q[3:0] is the ones digit, q[7:4] is the tens digit, etc. For digits [3:1], also output an enable signal indicating when each of the upper three digits should be incremented.

You may want to instantiate or modify some one-digit decade counters. */
module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q
);

    reg [3:0] q0, q1, q2, q3;  // 四个BCD计数器
    
    // 使能信号逻辑
    assign ena[1] = (q0 == 4'd9);
    assign ena[2] = (ena[1] && (q1 == 4'd9));
    assign ena[3] = (ena[2] && (q2 == 4'd9));
    wire overflow = (ena[3] && (q3 == 4'd9));
    
    // 组合输出
    assign q = {q3, q2, q1, q0};
    
    // 个位计数器 (q0)
    always @(posedge clk) begin
        if (reset)
            q0 <= 0;
        else
            q0 <= (q0 == 4'd9) ? 0 : q0 + 1;
    end
    
    // 十位计数器 (q1)
    always @(posedge clk) begin
        if (reset)
            q1 <= 0;
        else if (ena[1])
            q1 <= (q1 == 4'd9) ? 0 : q1 + 1;
    end
    
    // 百位计数器 (q2)
    always @(posedge clk) begin
        if (reset)
            q2 <= 0;
        else if (ena[2])
            q2 <= (q2 == 4'd9) ? 0 : q2 + 1;
    end
    
    // 千位计数器 (q3)
    always @(posedge clk) begin
        if (reset)
            q3 <= 0;
        else if (ena[3])
            q3 <= overflow ? 0 : (q3 == 4'd9) ? 0 : q3 + 1;
    end

endmodule

// HDLbits 不允许在顶层模块作模块的声明
/*  module top_module (
    input clk,
    input reset,
    output [3:1] ena,
    output [15:0] q
);
    
    // 进位使能信号
    assign ena[1] = (q[3:0] == 4'd9);
    assign ena[2] = (ena[1] && (q[7:4] == 4'd9));
    assign ena[3] = (ena[2] && (q[11:8] == 4'd9));
    wire OF = (ena[3] && (q[15:12] == 4'd9));
    
    // 实例化BCD计数器
    BCD_counter BCD_0(clk, reset, 1'b1, 1'b0, q[3:0]);
    BCD_counter BCD_1(clk, reset, ena[1], 1'b0, q[7:4]);
    BCD_counter BCD_2(clk, reset, ena[2], 1'b0, q[11:8]);
    BCD_counter BCD_3(clk, reset, ena[3], OF, q[15:12]);

endmodule

module BCD_counter (
    input clk,
    input reset,
    input ena,
    input OF,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (reset || OF)
            q <= 0;
        else if (ena)
            q <= (q == 4'd9) ? 0 : q + 1;
    end
endmodule 
*/

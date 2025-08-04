/* 
问题 4。[10 分]
一个大型蓄水池为多个用户供水。为了保持足够高的水位，三个传感器以 5 英寸的间隔垂直放置。当水位高于最高传感器（S₃）时，输入流量应为零。当水位低于最低传感器（S₁）时，流量应达到最大值（ nominal 流量阀和 Supplemental 流量阀均打开）。当水位在上部和下部传感器之间时，流量由两个因素决定：水位和上次传感器变化之前的水位。每个水位都有与其相关的标称流量率，如下表所示。如果传感器变化表明之前的水位低于当前水位，则应采用标称流量率。如果之前的水位高于当前水位，则应通过打开 Supplemental 流量阀（由 ΔFR 控制）来增加流量率。绘制蓄水池控制器的摩尔模型状态图。清楚地标明每个状态的所有状态转换和输出。你的有限状态机（FSM）的输入是 S₁、S₂和 S₃；输出是 FR1、FR2、FR3 和 ΔFR。
Also include an active-high synchronous reset that resets the state machine to a state equivalent to if the water level had been low for a long time (no sensors asserted, and all four outputs asserted).
 */

 module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
); 
reg [3:0]state, next_state;
parameter A = 4'b1111, B1 = 4'b0110, B2 = 4'b0111, C1 = 4'b0010, C2 = 4'b0011, D = 4'b0000;

always @(*) begin
    case(state)
A : next_state = s[1] ? B1 : A;
B1 : case (s[3:1])
   3'b001 : next_state = B1;
   3'b000 : next_state = A;
   3'b011 : next_state = C1;
endcase 
B2 : case (s[3:1])
   3'b001 : next_state = B2;
   3'b000 : next_state = A;
   3'b011 : next_state = C1;
endcase 
C1 : case(s[3:1])
   3'b011 : next_state = C1;
   3'b111 : next_state = D;
   3'b001 : next_state = B2;
endcase
C2 : case(s[3:1])
   3'b011 : next_state = C2;
   3'b111 : next_state = D;
   3'b001 : next_state = B2;
endcase
D : next_state = s[3] ? D : C2;
endcase
end

always @(posedge clk) begin
    if(reset)
    state <= A;
    else
    state <= next_state;
end

assign {fr3, fr2, fr1, dfr} = state;

endmodule

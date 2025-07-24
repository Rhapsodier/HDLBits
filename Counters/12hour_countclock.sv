/* Create a set of counters suitable for use as a 12-hour clock (with am/pm indicator). Your counters are clocked by a fast-running clk, with a pulse on ena whenever your clock should increment (i.e., once per second).

reset resets the clock to 12:00 AM. pm is 0 for AM and 1 for PM. hh, mm, and ss are two BCD (Binary-Coded Decimal) digits each for hours (01-12), minutes (00-59), and seconds (00-59). Reset has higher priority than enable, and can occur even when not enabled.

The following timing diagram shows the rollover behaviour from 11:59:59 AM to 12:00:00 PM and the synchronous reset and enable behaviour. */
module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // 定义各个计数器
    reg [3:0] ss_lo;  // 秒个位 (0-9)
    reg [3:0] ss_hi;  // 秒十位 (0-5)
    reg [3:0] mm_lo;  // 分个位 (0-9)
    reg [3:0] mm_hi;  // 分十位 (0-5)
    reg [3:0] hh_lo;  // 时个位 (1-9,0)
    reg [3:0] hh_hi;  // 时十位 (0-1)

    // 秒计数器逻辑
    always @(posedge clk) begin
        if (reset) begin
            ss_lo <= 0;
            ss_hi <= 0;
        end
        else if (ena) begin
            if (ss_lo == 9) begin
                ss_lo <= 0;
                if (ss_hi == 5)
                    ss_hi <= 0;
                else
                    ss_hi <= ss_hi + 1;
            end
            else
                ss_lo <= ss_lo + 1;
        end
    end

    // 分钟计数器逻辑
    always @(posedge clk) begin
        if (reset) begin
            mm_lo <= 0;
            mm_hi <= 0;
        end
        else if (ena && ss_lo == 9 && ss_hi == 5) begin
            if (mm_lo == 9) begin
                mm_lo <= 0;
                if (mm_hi == 5)
                    mm_hi <= 0;
                else
                    mm_hi <= mm_hi + 1;
            end
            else
                mm_lo <= mm_lo + 1;
        end
    end

    // 小时计数器逻辑
    always @(posedge clk) begin
        if (reset) begin
            hh_lo <= 2;  // 初始化为12:00
            hh_hi <= 1;
            pm <= 0;
        end
        else if (ena && ss_lo == 9 && ss_hi == 5 && mm_lo == 9 && mm_hi == 5) begin
            // 处理小时进位
            if (hh_lo == 9) begin
                hh_lo <= 0;
                hh_hi <= hh_hi + 1;
            end
            else if (hh_hi == 1 && hh_lo == 2) begin
                // 12:59:59 -> 1:00:00
                hh_hi <= 0;
                hh_lo <= 1;
            end
            else begin
                hh_lo <= hh_lo + 1;
                // 11:59:59 -> 12:00:00时切换AM/PM
                if (hh_hi == 1 && hh_lo == 1)
                    pm <= ~pm;
            end
        end
    end

    // 输出组合
    assign ss = {ss_hi, ss_lo};
    assign mm = {mm_hi, mm_lo};
    assign hh = {hh_hi, hh_lo};

endmodule
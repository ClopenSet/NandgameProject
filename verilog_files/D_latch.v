`ifndef D_LATCH_V
`define D_LATCH_V

`include "SR_Latch.v"

/*

SR latch
Input	Output
s	r	
1	0	1
0	1	0
1	1	Previous output
0	0	Not used


Input	Output
st	d		
1	0	0
1	1	1
0	1	Same as previous
0	0	Same as previous

对比知道新的真值表：

st  d   s	r   Output
1   1   1	0	1
1   0  	0	1   0
0   1   1	1	Previous output
0   0   1	1	Previous output

由此知道
s = ~st | d = st ~& d ~& st
r = st ~& d

*/


module Basic_D_Latch(
    input wire d,      // Data input
    input wire st,     // Enable signal
    output reg q       // Output
);

always @(st or d) begin
    if (st) begin
        q <= d;  
    end
end

endmodule

module GateLevel_D_Latch (
    output q,
    input st,
    input d
);

wire mid = st ~& d; // 直接用运算符表示

GateLevel_SR_Latch srlatch (
    .s(mid ~& st),
    .r(mid),
    .q(q)
);

endmodule

`ifdef TB_D_LATCH
`timescale 1ns / 1ps

module test_D_Latch;

    reg st, d;
    wire q_basic, q_gate;

    // 实例化基本 D 锁存器
    Basic_D_Latch basic_latch(.q(q_basic), .st(st), .d(d));

    // 实例化基于 SR 锁存器的 D 锁存器
    GateLevel_D_Latch gate_latch(.q(q_gate), .st(st), .d(d));

    initial begin
        // 初始化输入
        st = 0; d = 0;

        // 监视输出和输入
        $monitor("Time = %t, st = %b, d = %b, q_basic = %b, q_gate = %b",
                 $time, st, d, q_basic, q_gate);

        // 输入序列
        #10 d = 1;
        #10 st = 1; d = 0;
        #10 d = 1;
        #10 st = 0; d = 0;
        #10 d = 1;
        #10 st = 1; d = 0;
        #10 st = 0;
        #10 d = 1;
        #10 $finish;
    end

endmodule

`endif
`endif // D_LATCH_V

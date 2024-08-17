`include "MultibitAdder.v"
module BasicIncrement(
    input [15:0] in,  
    output [15:0] out 
);

assign out = in + 1;

endmodule

module GateLevelIncrement(
    input [15:0] in,
    output [15:0] out
);

    wire cout_unused;

    // 实例化BasicAdd16模块，b设置为0，cin设置为1，以实现自增
    BasicAdd16 adder(
        .a(in),
        .b(16'h0000),  // 全0
        .cin(1'b1),    // 加1
        .sum(out),
        .cout(cout_unused)
    ); 

endmodule




`include "HalfAdder.v"

// 实际上，BasicAdd16由16各全加器组成；由于加1仅仅需要半加器即可完成任务，而全加器的门数目比半加器多一倍；为求最少门数目，末位反向，十四个半加器和一个异或相加即可做到自增

// generate 语句学习

module OptimalIncrement(
    input [15:0] in,
    output [15:0] out
);

wire [14:0] carry;  // 定义进位线，只需要14位，因为从in[0]到in[14]生成的进位

// 第0位输出与进位
assign out[0] = ~in[0];  // 反转最低位
assign carry[0] = in[0]; // 将最低位的输入作为第一个进位

// 实例化半加器进行自增操作
genvar i;
generate
    for (i = 1; i < 15; i = i + 1) begin : half_adders
        GateLevelHalfAdder ha( //这个ha名字无关紧要，最终的名字是half_adders[i]
            .a(in[i]),
            .b(carry[i-1]),  // 上一级的进位作为本级的输入
            .h(carry[i]),  // 生成本级的进位
            .l(out[i])  // 本级的输出结果
        );
    end
endgenerate

// 最高位的处理，只需考虑最后一个进位
assign out[15] = in[15] ^ carry[14];  // 使用最后的进位

endmodule

`ifdef TB_INCREMENT

`timescale 1ns / 1ps

module Testbench;

    reg [15:0] in;         // 测试输入
    wire [15:0] out;       // 测试输出

    // 实例化 OptimalIncrement 模块
    OptimalIncrement UUT (
        .in(in),
        .out(out)
    );

    initial begin
        // 初始化输入
        in = 16'h0000;
        $monitor("Time=%t, in=%h, out=%h", $time, in, out);

        // 增加测试数据
        #10 in = 16'h0001; // 输入为 1，期望输出为 2
        #10 in = 16'hFFFF; // 输入为 FFFF，期望输出为 0000 (因溢出)
        #10 in = 16'h7FFF; // 输入为 7FFF，期望输出为 8000
        #10 in = 16'h8000; // 输入为 8000，期望输出为 8001
        #10 in = 16'h00FF; // 输入为 00FF，期望输出为 0100

        // 等待一段时间后结束测试
        #50;
        $finish;
    end

endmodule

`endif
module BasicXor(
    input wire a,
    input wire b,
    output wire q
);

assign q = a ^ b;
    
endmodule


module GateLevelXor(
    input wire a,
    input wire b,
    output wire q
);
// Nand 游戏第一个难点

/*

考虑到 C ~& D = ~C | ~D 
将 a^b 写成析取范式DNF a^b = (a & ~b) | (~a & b)
C = ~ (a & ~b) = ~a | b

考虑到(a ~& b) ~& a
=(~a | ~b) ~& a 
= ~(~a | ~b) | ~a 
= (a & b) | ~a
= (a | ~a) & (b | ~a)
= b | ~a

因此 
(a ~& b) ~& a = C
(a ~& b) ~& b = D

*/


wire AnandB;
wire C;
wire D;

nand (AnandB,a,b);
nand (C,AnandB,a);
nand (D,AnandB,b);
nand (q,C,D);
//若改为四个nand，根据对称性将会得到xnor，需要再多一个反向的到xor

endmodule


`define TB_XOR

`ifdef TB_XOR

`timescale 1ns / 1ps

module TestBench;
    // 测试输入
    reg a, b;
    // 测试输出
    wire q_basic, q_gatelevel;

    // 实例化 BasicXor 模块
    BasicXor basic_xor(.a(a), .b(b), .q(q_basic));

    // 实例化 GateLevelXor 模块
    GateLevelXor gatelevel_xor(.a(a), .b(b), .q(q_gatelevel));

    // 初始化测试输入
    initial begin
        a = 0; b = 0;
        #10 a = 0; b = 1;
        #10 a = 1; b = 0;
        #10 a = 1; b = 1;
        #10 $finish;
    end
    
    // 监视变量和比较结果
    initial begin
        $monitor("At time %t, a = %b, b = %b, q_basic = %b, q_gatelevel = %b",
                 $time, a, b, q_basic, q_gatelevel);
    end
    
    // 检查输出是否匹配
    always @(a or b) begin
        #1; // 延迟1ns以确保输出稳定
        if (q_basic !== q_gatelevel) begin
            $display("Mismatch found at %t: q_basic = %b, q_gatelevel = %b",
                     $time, q_basic, q_gatelevel);
        end
    end
endmodule

`endif
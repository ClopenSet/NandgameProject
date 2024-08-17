`ifndef HALFADDER_V
`define HALFADDER_V

module BasicHalfAdder(
    input wire a,
    input wire b,
    output wire h,
    output wire l
);

    assign {h,l} = a + b;

endmodule


`include "Invert.v"

module GateLevelHalfAdder(
    input wire a,
    input wire b,
    output wire h,
    output wire l
);
    wire a_nand_b;
    wire C;
    wire D;
    // 手动展开来优化 xor(sum, a, b) 和 and(carry, a, b)
    
    nand (a_nand_b,a,b);
    GateLevelInvert invertgatelevel(a_nand_b,h);
    nand (C,a_nand_b,a);
    nand (D,a_nand_b,b);
    nand (l,C,D);


endmodule

`ifdef TB_HALFADDER

`timescale 1ns / 1ps

module TestBench;
    reg a, b;
    wire l_basic, h_basic;
    wire l_gatelevel, h_gatelevel;

    // 实例化 BasicHalfAdder
    BasicHalfAdder basic_ha(.a(a), .b(b), .h(h_basic), .l(l_basic));

    // 实例化 GateLevelHalfAdder
    GateLevelHalfAdder gatelevel_ha(.a(a), .b(b), .h(h_gatelevel), .l(l_gatelevel));

    initial begin
        // 测试所有输入组合
        a = 0; b = 0;
        #10 a = 0; b = 1;
        #10 a = 1; b = 0;
        #10 a = 1; b = 1;
        #10 $finish;
    end

    initial begin
        $monitor("At time %t, a = %b, b = %b, l_basic = %b, h_basic = %b, l_gatelevel = %b, h_gatelevel = %b",
                 $time, a, b, l_basic, h_basic, l_gatelevel, h_gatelevel);
    end

    // 检查输出是否匹配
    always @(a or b) begin
        #1; // 延迟1ns以确保输出稳定
        if (l_basic !== l_gatelevel || h_basic !== h_gatelevel) begin
            $display("Mismatch found at %t: l_basic = %b, h_basic = %b, l_gatelevel = %b, h_gatelevel = %b",
                     $time, l_basic, h_basic, l_gatelevel, h_gatelevel);
        end
    end
endmodule

`endif
`endif // HALFADDER_V

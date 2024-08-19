`ifndef CMOS_NAND_V
`define CMOS_NAND_V

`include "CMOS.v"

module NAND_CMOS(
    input a,
    input b,
    output o
);
    wire p1o,p2o;
    wire n1o,n2o;
    PMOS p1(.off(a),.i(1'b1),.o(p1o));
    PMOS p2(.off(b),.i(1'b1),.o(p2o));
    NMOS n1(.on(b),.i(a),.o(n1o));
    NMOS n2(.on(n1o),.i(1'b0),.o(n2o));

    Junction j1(.i1(p1o),.i2(n2o),.o(j1o));
    Junction j2(.i1(j1o),.i2(p2o),.o(o));
endmodule

`ifdef TB_CMOS_NAND
`timescale 1ns / 1ps

module Testbench;

    reg a;
    reg b;
    wire o;

    // 实例化 NANDGate 模块
    NAND_CMOS nand_gate(
        .a(a),
        .b(b),
        .o(o)
    );

    initial begin
        // 初始化输入
        a = 0; b = 0;
        #10;  // 等待10纳秒
        
        // 测试不同的输入组合
        a = 0; b = 0;
        #10;
        $display("a = %b, b = %b, o = %b", a, b, o);
        
        a = 0; b = 1;
        #10;
        $display("a = %b, b = %b, o = %b", a, b, o);

        a = 1; b = 0;
        #10;
        $display("a = %b, b = %b, o = %b", a, b, o);

        a = 1; b = 1;
        #10;
        $display("a = %b, b = %b, o = %b", a, b, o);

        // 结束测试
        $finish;
    end

endmodule
`endif

`endif // CMOS_NAND_V


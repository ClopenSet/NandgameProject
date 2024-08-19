`ifndef ALU_V
`define ALU_V

`include "ArithmeticUnit.v"
`include "LogicUnit.v"

module BasicALU(
    input [15:0] X,
    input [15:0] Y,
    input u, op1, op0, sw, zx,
    output [15:0] out
);
    wire [15:0] X_sw, Y_sw, X_mod;

    // 处理交换标志 sw
    assign X_sw = (sw) ? Y : X;
    assign Y_sw = (sw) ? X : Y;

    // 处理置零标志 zx
    assign X_mod = (zx) ? 16'h0000 : X_sw;

    // 选择逻辑或算术操作
    wire [15:0] result_logic, result_arith;
    BasicLogicUnit logic_unit(.X(X_mod), .Y(Y_sw), .op1(op1), .op0(op0), .out(result_logic));
    BasicArithmeticUnit arithmetic_unit(.X(X_mod), .Y(Y_sw), .op1(op1), .op0(op0), .out(result_arith));

    assign out = (u) ? result_arith : result_logic;
endmodule

`include "ArithmeticUnit.v" // 使用门级版本
`include "LogicUnit.v" // 使用门级版本
`include "Selector.v" // Mux2to1_Hex

module GateLevelALU(
    input [15:0] X,
    input [15:0] Y,
    input u, op1, op0, sw, zx,
    output [15:0] out
);
    wire [15:0] X_sw, Y_sw, X_mod;

    // 处理交换标志 sw
    Mux2to1_Hex swap_X(.a(X), .b(Y), .sel(sw), .y(X_sw));
    Mux2to1_Hex swap_Y(.a(Y), .b(X), .sel(sw), .y(Y_sw));

    // 处理置零标志 zx
    Mux2to1_Hex select_xmod (.a(X_sw),.b(16'h0000),.sel(zx),.y(X_mod));

    // 选择逻辑或算术操作
    wire [15:0] result_logic, result_arith;
    GateLevelLogicUnit logic_unit(.X(X_mod), .Y(Y_sw), .op1(op1), .op0(op0), .out(result_logic));
    GateLevelArithmeticUnit arithmetic_unit(.X(X_mod), .Y(Y_sw), .op1(op1), .op0(op0), .out(result_arith));

    // 根据 u 标志选择输出
    Mux2to1_Hex select_output(.a(result_logic), .b(result_arith), .sel(u), .y(out));
endmodule


`ifdef TB_ALU

`timescale 1ns / 1ps

module TestBenchALU;
    reg [15:0] X, Y;
    reg u, op1, op0, sw, zx;
    wire [15:0] out_behavioral, out_gatelevel;

    // 实例化行为级ALU
    BasicALU behavioral_ALU (.X(X), .Y(Y), .u(u), .op1(op1), .op0(op0), .sw(sw), .zx(zx), .out(out_behavioral));

    // 实例化门级ALU
    GateLevelALU gatelevel_ALU (.X(X), .Y(Y), .u(u), .op1(op1), .op0(op0), .sw(sw), .zx(zx), .out(out_gatelevel));

    initial begin
        // 测试序列
        #10 {X, Y, u, op1, op0, zx, sw} = {16'h7, 16'h4, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0}; //000b
        #10 {X, Y, u, op1, op0, zx, sw} = {16'h7, 16'h4, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0}; //0003
        #10 {X, Y, u, op1, op0, zx, sw} = {16'h7, 16'h4, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1}; //fffd
        #10 {X, Y, u, op1, op0, zx, sw} = {16'h7, 16'h4, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0}; //fffc
        #10 {X, Y, u, op1, op0, zx, sw} = {16'h7, 16'h4, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1}; //fff9
        #10 {X, Y, u, op1, op0, zx, sw} = {16'h0, 16'h0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}; //0000
        #10 {X, Y, u, op1, op0, zx, sw} = {16'h0, 16'hFFFF, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}; //0000
        #10 {X, Y, u, op1, op0, zx, sw} = {16'hFFFF, 16'h0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};//0000
        #10 {X, Y, u, op1, op0, zx, sw} = {16'hFFFF, 16'hFFFF, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}; //ffff
        #10 {X, Y, u, op1, op0, zx, sw} = {16'h1, 16'hB1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}; //0001
        
        #10 $finish;
    end

    initial begin
        $monitor("Time = %t | X = %h, Y = %h, u = %b, op1 = %b, op0 = %b, sw = %b, zx = %b | out_behavioral = %h | out_gatelevel = %h",
                 $time, X, Y, u, op1, op0, sw, zx, out_behavioral, out_gatelevel);
    end
endmodule

`endif

`endif // ALU_V



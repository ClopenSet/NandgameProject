`ifndef LOGICUNIT_V
`define LOGICUNIT_V

`include "Selector.v"
module BasicLogicUnit(
    input [15:0] X,         // 16位输入X
    input [15:0] Y,         // 16位输入Y
    input op1,              // 操作选择位op1
    input op0,              // 操作选择位op0
    output reg [15:0] out   // 16位输出
);

always @ (op1, op0, X, Y) begin
    case ({op1, op0})      // 使用操作位op1和op0作为case语句的选择
        2'b00: out = X & Y;       // 当op1=0, op0=0时，输出X AND Y
        2'b01: out = X | Y;       // 当op1=0, op0=1时，输出X OR Y
        2'b10: out = X ^ Y;       // 当op1=1, op0=0时，输出X XOR Y
        2'b11: out = ~X;          // 当op1=1, op0=1时，输出INVERT X
        default: out = 16'bx;     // 默认输出不定值
    endcase
end

endmodule

module GateLevelLogicUnit(
    input [15:0] X,         // 16位输入X
    input [15:0] Y,         // 16位输入Y
    input op1,              // 操作选择位op1
    input op0,              // 操作选择位op0
    output [15:0] out       // 16位输出
);

    wire [15:0] result_and, result_or, result_xor, result_not;
    wire [15:0] mux1_out, mux2_out;

    // 基础逻辑操作
    assign result_and = X & Y;
    assign result_or = X | Y;
    assign result_xor = X ^ Y;
    assign result_not = ~X;

    // 使用 Mux2to1_Hex 选择器进行操作选择
    // 首先决定 AND 或 OR
    Mux2to1_Hex mux1(
        .a(result_and),
        .b(result_or),
        .sel(op0),
        .y(mux1_out)
    );

    // 决定 XOR 或 NOT
    Mux2to1_Hex mux2(
        .a(result_xor),
        .b(result_not),
        .sel(op0),
        .y(mux2_out)
    );

    // 最后的选择，基于 op1
    Mux2to1_Hex final_mux(
        .a(mux1_out),
        .b(mux2_out),
        .sel(op1),
        .y(out)
    );

endmodule


`endif // LOGICUNIT_V
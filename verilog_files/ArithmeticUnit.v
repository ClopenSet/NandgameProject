module BasicArithmeticUnit(
    input [15:0] X,
    input [15:0] Y,
    input op1,
    input op0,
    output reg [15:0] out
);
    always @ (op1, op0, X, Y) begin
        case ({op1, op0})
            2'b00: out = X + Y;      // op1=0, op0=0, X + Y
            2'b01: out = X + 1;      // op1=0, op0=1, X + 1
            2'b10: out = X - Y;      // op1=1, op0=0, X - Y
            2'b11: out = X - 1;      // op1=1, op0=1, X - 1
            default: out = 16'hxxxx; // undefined case
        endcase
    end
endmodule


`include "Selector.v"
module GateLevelArithmeticUnit(
    input [15:0] X,
    input [15:0] Y,
    input op1,
    input op0,
    output [15:0] out
);
    wire [15:0] second_operand;
    wire [15:0] add_result;
    wire [15:0] sub_result;

    // 选择 Y 或 1 作为第二操作数
    Mux2to1_Hex select_operand(
        .a(Y),
        .b(16'h0001),
        .sel(op0),
        .y(second_operand)
    );

    // 实现加法和减法操作
    assign add_result = X + second_operand;
    assign sub_result = X - second_operand;

    // 根据 op1 选择加法或减法
    Mux2to1_Hex select_operation(
        .a(add_result),
        .b(sub_result),
        .sel(op1),
        .y(out)
    );
endmodule
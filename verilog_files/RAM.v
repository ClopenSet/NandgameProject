`ifndef RAM_V
`define RAM_V

`include "Switch.v"
`include "Register.v"
`include "Selector.v"

module GateLevelRAMs(
    input wire cl,           // 时钟信号
    input wire st,           // 存储信号
    input wire ad,           // 地址位（1位）
    input wire [15:0] X,     // 16位输入数据
    output reg [15:0] Y      // 16位输出数据
);

reg [15:0] reg0, reg1;   // 两个16位寄存器
wire st0,st1;

BasicSwitch sw1(.s(ad),.d(st),.c0(st0),.c1(st1));
Mux2to1_Hex mux(.y(Y),.a(reg0),.b(reg1),.sel(ad));

BasicRegister R0 (
    .st(st0),
    .in(X),
    .out(reg0),
    .clk(cl)
);
BasicRegister R1 (
    .st(st1),
    .in(X),
    .out(reg1),
    .clk(cl)
);

endmodule 


module BasicRAM(
    input wire cl,           // 时钟信号
    input wire st,           // 存储信号
    input wire ad,           // 地址位（1位）
    input wire [15:0] X,     // 16位输入数据
    output reg [15:0] Y      // 16位输出数据
);
    reg [15:0] reg0, reg1;   // 两个16位寄存器

    // 写操作基于地址和存储信号
    always @(negedge cl) begin
        if (st) begin
            if (ad == 1'b0)
                reg0 <= X;
            else if (ad == 1'b1)
                reg1 <= X;
        end
    end

    // 读操作输出当前地址对应寄存器的值
    always @(posedge cl) begin
        if (ad == 1'b0)
            Y <= reg0;
        else if (ad == 1'b1)
            Y <= reg1;
    end
endmodule



`endif // RAM_V

`ifndef COMBINED_MEMORY_V
`define COMBINED_MEMORY_V

`include "Register.v"
`include "RAM.v"

module GateLevelBasicProcessor(
    input a,
    input d,
    input addr_a,
    input [15:0] X,
    input cl,
    output [15:0] A,
    output [15:0] D,
    output [15:0] addr_A
);

BasicRAM ram(
    .cl(cl),            // 时钟信号
    .st(addr_a),            // 存储信号
    .ad(A),     // 16位地址
    .X(X),      // 16位输入数据
    .Y(addr_A)       // 16位输出数据
);

BasicRegister rega(
    .st(a),
    .clk(cl),
    .in(X),
    .out(A)
);

BasicRegister regd(
    .st(d),
    .clk(cl),
    .in(X),
    .out(D)
);
    
endmodule



module BehavioralBasicProcessor(
    input wire a,      // 当a为高时，写入地址寄存器
    input wire d,      // 当d为高时，写入数据寄存器
    input wire addr_a, // 当addr_a为高时，写入RAM
    input wire [15:0] X,   // 输入数据
    input wire cl,         // 时钟信号
    output reg [15:0] A,   // 地址输出
    output reg [15:0] D,   // 数据输出
    output reg [15:0] addr_A // RAM读取的数据输出
);

    // 模拟的RAM存储空间，可以扩展到更多地址
    reg [15:0] ram[0:65535]; 

    always @(posedge cl) begin
        // 地址寄存器写入操作
        if (a) begin
            A <= X;
        end

        // 数据寄存器写入操作
        if (d) begin
            D <= X;
        end
    end

    always @(negedge cl) begin
        // RAM写入操作
        if (addr_a) begin
            ram[A] <= X; // 使用A寄存器指定的地址写入数据
            addr_A <= ram[A]; // 同时读取该地址的数据
        end else begin
            addr_A <= ram[A]; // 只读取不写入
        end
    end

endmodule
`endif // COMBINED_MEMORY_V

`ifndef COMPUTER_V
`define COMPUTER_V

`include "Clock.v" //For Clock
`include "Counter.v" //For Counter
`include "Control_Unit.v" //For Control Unit
`include "Combined_Memory.v" //For Memory
`include "ROM.v" // For ROM

module Computer;

    // 信号声明
    wire clk;           // 时钟信号
    wire [15:0] PC;     // 程序计数器的值
    wire [15:0] I;      // 当前指令
    wire [15:0] A;      // A寄存器的值
    wire [15:0] D;      // D寄存器的值
    wire [15:0] addr_A; // A寄存器对应的RAM地址的值
    wire [15:0] R;      // 控制单元的结果
    wire a, d, addr_a, j; // 控制信号
    wire st;            // 存储控制信号

    // 实例化时钟生成器
    clock_generator clk_gen(
        .clk(clk)
    );

    // 实例化基本计数器
    BasicCounter counter(
        .clk(clk),
        .st(j),     
        .X(A),       
        .out(PC)
    );

    // 实例化ROM，用于提供指令
    ROM program_memory(
        .Ad(PC),      // 程序计数器的值作为地址
        .data(I)      // 当前指令输出
    );

    // 实例化控制单元
    ControlUnit control_unit(
        .I(I),
        .A(A),
        .D(D),
        .addr_A(addr_A),
        .R(R),
        .a(a),
        .d(d),
        .addr_a(addr_a),
        .j(j)
    );

    // 实例化基本处理器
    GateLevelBasicProcessor processor(
        .a(a),
        .d(d),
        .addr_a(addr_a),
        .X(R),       // 控制单元的输出作为输入
        .cl(clk),
        .A(A),
        .D(D),
        .addr_A(addr_A)
    );

endmodule
`endif // COMPUTER_V

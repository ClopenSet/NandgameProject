`ifndef CLOCK_V
`define CLOCK_V


`timescale 1ns / 1ps
module clock_generator(
    output reg clk  // 输出时钟信号
);

parameter PERIOD = 10;  // 定义时钟周期的一半，总周期为20时间单位

// 初始化时钟信号，产生周期性翻转
initial clk = 0;  // 初始时钟设为0

always begin
    #PERIOD clk = ~clk;  // 每隔PERIOD时间单位翻转时钟信号
end

endmodule


`ifdef TB_CLOCK

module clock_generator_tb;

reg clk;  // 用于连接到时钟发生器的时钟信号

// 实例化时钟发生器模块
clock_generator uut (
    .clk(clk)
);

initial begin
    // 模拟500ns的运行时间，足以观察多个周期
    #500;
    
    // 终止仿真
    $finish;
end

// 用于观察波形的VCD文件生成
initial begin
    // 打开波形文件
    $dumpfile("clock_generator_tb.vcd");
    
    // 存储所有波形数据
    $dumpvars(0, clock_generator_tb);
end

endmodule

`endif

`endif // CLOCK_V
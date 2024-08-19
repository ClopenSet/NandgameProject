`ifndef COUNTER_V
`define COUNTER_V

module BasicCounter(
    input wire clk,      // 时钟信号
    input wire st,       // 存储控制信号
    input wire [15:0] X, // 输入值
    output reg [15:0] out // 输出值
);

    // 在时钟信号从1变到0的时候，根据st的值更新计数器
    always @(negedge clk) begin
        if (st == 1) 
            out <= X;          // 如果st为1，设置输出为输入X
        else 
            out <= out + 1;    // 如果st为0，将当前输出值加1
    end

endmodule

`include "Register.v"
`include "Increment.v"
`include "Selector.v"

module CounterUsingRegister(
    input wire clk,       // 时钟信号
    input wire st,        // 存储/重置控制信号
    input wire [15:0] X,  // 输入值，用于重置计数器
    output wire [15:0] out // 计数器的输出
);

    wire [15:0] next_value;
    wire [15:0] incremented_value;


    // 创建加法器，递增当前计数值
    BasicIncrement incre(.in(out),.out(incremented_value));

    // 选择适当的下一个值
    Mux2to1_Hex mux1(.a(incremented_value),.b(X),.sel(st),.y(next_value));

    // 使用BasicRegister存储和更新计数值
    BasicRegister reg_instance(
        .st(1'b1),         // 总是使能存储，因为我们通过next_value控制实际的输入
        .clk(clk),
        .in(next_value),
        .out(out)
    );

endmodule

`endif // COUNTER_V

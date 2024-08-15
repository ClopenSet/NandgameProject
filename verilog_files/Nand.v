
module Relay_off(
    input wire c, //magnet
    input wire in,
    output wire q
);
    assign q = c & in;
endmodule

module Relay_on(
    input wire c, //magnet
    input wire in,
    output wire q
);
    assign q = ~c & in;
endmodule


module PhysicalLevelNand(
    input wire a,
    input wire b,
    output wire q
);
    Relay_off off1 (.c(a),.in(b),.q(qoff));
    Relay_on on1 (.c(qoff),.in(1'b1),.q(q));
    //<size>'<base_format><number>
endmodule


module BasicNand(
    input wire a,
    input wire b,
    output wire q
);
    assign q = a ~& b;
endmodule



`timescale 1ns / 1ps

module TestBench;
    // 测试输入
    reg a, b;
    // 测试输出
    wire q_physical, q_basic;
    
    // 实例化PhysicalLevelNand
    PhysicalLevelNand nand_physical(.a(a), .b(b), .q(q_physical));
    // 实例化BasicNand
    BasicNand nand_basic(.a(a), .b(b), .q(q_basic));
    
    // 初始化测试输入
    initial begin
        // 初始时刻给定的输入
        a = 0; b = 0;
        #10;  // 等待10ns
        
        a = 0; b = 1;
        #10;  // 等待10ns
        
        a = 1; b = 0;
        #10;  // 等待10ns
        
        a = 1; b = 1;
        #10;  // 等待10ns
        
        $finish; // 结束仿真
    end
    
    // 监视变量和比较结果
    initial begin
        $monitor("At time %t, a = %b, b = %b, q_physical = %b, q_basic = %b",
                 $time, a, b, q_physical, q_basic);
    end
    
    // 检查输出是否匹配
    always @(a, b) begin
        #1; // 延迟1ns以确保输出稳定
        if (q_physical !== q_basic) begin
            $display("Mismatch found at %t: q_physical = %b, q_basic = %b",
                     $time, q_physical, q_basic);
        end
    end
endmodule

/* 
monitor 语句：在变量改变时打印
display 语句：正常的打印
*/

`timescale 1ns / 1ps

module TestBench_with_wave;
    reg a, b;
    wire q_physical, q_basic;

    PhysicalLevelNand nand_physical(.a(a), .b(b), .q(q_physical));
    BasicNand nand_basic(.a(a), .b(b), .q(q_basic));

    initial begin
        $dumpfile("nand_waves.vcd");
        $dumpvars(0, nand_physical.q, nand_basic.q);
        //$dumpvars(1,Testbench2) 执行全部导出

        a = 0; b = 0;
        #10 a = 0; b = 1;
        #10 a = 1; b = 0;
        #10 a = 1; b = 1;
        #10;

        $monitor("At time %t, a = %b, b = %b, q_physical = %b, q_basic = %b",
                 $time, a, b, q_physical, q_basic);

        $finish;
    end
endmodule
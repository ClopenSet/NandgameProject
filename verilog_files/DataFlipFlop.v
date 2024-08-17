`ifndef DATAFLIPFLOP_V
`define DATAFLIPFLOP_V

`include "D_Latch.v"
module GateLevelDFF(output q, input st, input d, input cl);
    wire stored_value;
    Basic_D_Latch d1(.q(q), .st(~cl), .d(stored_value));
    Basic_D_Latch d2(.q(stored_value), .st(st & cl), .d(d));
endmodule

module BasicDFF(output reg q, input st, input d, input cl);
    reg stored_value;
    always @(posedge cl) begin
        if (st) stored_value <= d;
    end
    always @(negedge cl) begin
        q <= stored_value;
    end
endmodule


module Testbench;
    reg st, d, cl;
    wire q1, q2;

    // 实例化两个 DFF
    GateLevelDFF dff1(.q(q1), .st(st), .d(d), .cl(cl));
    BasicDFF dff2(.q(q2), .st(st), .d(d), .cl(cl));

    // 时钟信号生成
    initial begin
        cl = 0;
        forever #5 cl = ~cl;  // 时钟周期为 10 单位时间
    end

    // 输入信号生成和监视输出
    initial begin
        st = 0; d = 0;
        // 初始化输入
        #10; st = 1; d = 1;
        #10; st = 1; d = 0;
        #10; st = 0; d = 1;
        #10; st = 1; d = 1;
        #20; $finish;  // 结束仿真
    end

    // 监视
    initial begin
        $monitor("At time %t, cl = %b, st = %b, d = %b -> q1 = %b, q2 = %b", $time, cl, st, d, q1, q2);
    end
endmodule


`endif // DATAFLIPFLOP_V

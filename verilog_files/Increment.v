module BasicIncrement(
    input [15:0] in,  
    output [15:0] out 
);

assign out = in + 1;

endmodule


module BasicAdd16(
    input [15:0] a,  
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);
assign {cout,sum} = a + b + cin;
    
endmodule

module GateLevelIncrement(
    input [15:0] in,
    output [15:0] out
);

    wire cout_unused;

    // 实例化BasicAdd16模块，b设置为0，cin设置为1，以实现自增
    BasicAdd16 adder(
        .a(in),
        .b(16'h0000),  // 全0
        .cin(1'b1),    // 加1
        .sum(out),
        .cout(cout_unused)
    );

endmodule
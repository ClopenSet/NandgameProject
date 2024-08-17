`include "MultiBitAdder.v"

module BasicSubtraction(
    input [15:0] a,   
    input [15:0] b,   
    output [15:0] result 
);

assign result = a - b;

endmodule


module GateLevelSubtraction(
    input [15:0] a,   
    input [15:0] b,   
    output [15:0] result  
);

//补码：例如，以16为模，-7(1111) 实际上就是 + 9 (1001)
// 补码计算的实际上就是 2^n - x 的原码

// 2^n - x = (2^n - 1 - x) + 1 = ~x + 1

// 计算B的补码
wire [15:0] b_complement;
wire cout_unused;
assign b_complement = ~b + 1;

BasicAdd16 adder(
    .a(a),
    .b(b_complement),
    .cin(1'b0),  
    .cout(cout_unused) 
);

endmodule

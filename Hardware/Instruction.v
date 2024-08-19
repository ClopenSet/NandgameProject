`ifndef INSTRUCTION_V
`define INSTRUCTION_V

`include "ALU.v"
`include "Condition.v"
`include "Selector.v"

module InstructionHandler(
    input wire [15:0] I, // 16位指令输入
    input wire [15:0] A,           // A寄存器输入
    input wire [15:0] D,           // D寄存器输入
    input wire [15:0] addr_A,      // RAM中A所代表地址的数
    output wire [15:0] R,      // 指令结果
    output wire a,      // 存储a的enable输出
    output wire d,    // 存储d的enable输出
    output wire addr_a,             // 存储A所代表地址的enable输出
    output wire j  //j输出
);

// X 永远来自 D
// Y 根据I[12]？ 来自 addr_A : A
// 利用 I[10:9] 控制 ALU 使得 X和Y 产生结果 R
// I[5:3]原样输出，决定将指令结果存储在哪里
// 利用 I [2:0] 判断 ALU 产生的结果 R 是否满足标志位

wire [15:0] Y;

Mux2to1_Hex mux(.sel(I[12]),.a(A),.b(addr_A),.y(Y)); 

BasicALU alu(
    .X(D),
    .Y(Y),
    .u(I[10]), .op1(I[9]), .op0(I[8]), .zx(I[7]), .sw(I[6]),
    .out(R)
);
    
assign {a,d,addr_a} = I [5:3]; // I[5:3]原样输出，决定将指令结果存储在哪里

BasicCondition cond(
    .lt(I[2]),  // Less than zero flag
    .eq(I[1]),  // Equal to zero flag
    .gt(I[0]),  // Greater than zero flag
    .X(R),  // Input value X
    .out(j)  // Output based on the condition flags and value of X
);



endmodule

`ifdef TB_INSTRUCTION
`timescale 1ns / 1ps

module InstructionHandler_tb;

// Inputs
reg [15:0] I;
reg [15:0] A;
reg [15:0] D;
reg [15:0] addr_A;

// Outputs
wire [15:0] R;
wire a;
wire d;
wire addr_a;
wire j;

// Instantiate the Unit Under Test (UUT)
InstructionHandler uut (
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

initial begin
    // Initialize Inputs
    I = 0; A = 0; D = 0; addr_A = 0;
    
    // Wait for global reset
    #100;
    
    // Test case 1: I=0xe590, A=7, D=9, addr_A=0x000d
    I = 16'hE590; A = 16'd7; D = 16'd9; addr_A = 16'h000D;
    #10; // Wait for simulation
    
    // Test case 2: I=0xe018, A=6, D=5, addr_A=0
    I = 16'hE018; A = 16'd6; D = 16'd5; addr_A = 16'd0;
    #10; // Wait for simulation
    
    // Test case 3: I=0xf4a3, A=0, D=0, addr_A=0x002a
    I = 16'hF4A3; A = 16'd0; D = 16'd0; addr_A = 16'h002A;
    #10; // Wait for simulation
    
    // Test case 4: I=0xf4a6, A=0, D=0, addr_A=0x002a
    I = 16'hF4A6; A = 16'd0; D = 16'd0; addr_A = 16'h002A;
    #10; // Wait for simulation
    
    // Test case 5: I=0xe760, A=0x002A, D=1, addr_A=2
    I = 16'hE760; A = 16'h002A; D = 16'd1; addr_A = 16'd2;
    #10; // Wait for simulation
    
    // Test case 6: I=0xe762, A=1, D=2, addr_A=0xFFFF
    I = 16'hE762; A = 16'd1; D = 16'd2; addr_A = 16'hFFFF;
    #10; // End simulation after this delay

end

// Monitor Outputs
initial begin
    $monitor("Time=%t, I=%h, A=%d, D=%d, *A=%h, R=%h, a=%b, d=%b, addr_a=%b, j=%b", $time, I, A, D, addr_A, R, a, d, addr_a, j);
end

endmodule
`endif


`endif // INSTRUCTION_V

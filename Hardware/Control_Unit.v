`ifndef CONTROL_UNIT_V
`define CONTROL_UNIT_V

`include "Instruction.v"

module ControlUnit(
    input wire [15:0] I, // 16位指令输入
    input wire [15:0] A,           // A寄存器输入
    input wire [15:0] D,           // D寄存器输入
    input wire [15:0] addr_A,      // RAM中A所代表地址的数
    output wire [15:0] R,           // 指令结果
    output wire a,                  // 存储a的enable输出
    output wire d,                  // 存储d的enable输出
    output wire addr_a,             // 存储A所代表地址的enable输出
    output wire j                   // j输出
);

wire [15:0] R_alu;
wire a_alu,d_alu,addr_a_alu,j_alu;

InstructionHandler ins (
    .I(I), // 16位指令输入
    .A(A),           // A寄存器输入
    .D(D),           // D寄存器输入
    .addr_A(addr_A),      // RAM中A所代表地址的数
    .R(R_alu),      // 指令结果
    .a(a_alu),      // 存储a的enable输出
    .d(d_alu),    // 存储d的enable输出
    .addr_a(addr_a_alu),             // 存储A所代表地址的enable输出
    .j(j_alu)  //j输出
);

assign R = I[15] ? R_alu : I ;
assign a = I[15] ~& ~a_alu;  // 即 ~ I [15] | a_alu ，即 I[15] ? a_alu : 1
assign d = I[15] & d_alu;// 即 I[15] ? d_alu : 0
assign addr_a = I[15] & addr_a_alu; // 即 I[15] ? addr_a_alu : 0
assign j = I[15] & j_alu; // 即 I[15] ? addr_a_alu : 0

endmodule

`ifdef TB_CONTROL_UNIT

`timescale 1ns / 1ps

module ControlUnit_tb;

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
ControlUnit uut (
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
    // Initialize the simulation
    $display("Time\tI\tA\tD\taddr_A\tR\ta\td\taddr_a\tj");
    $monitor("%g\t%h\t%h\t%h\t%h\t%h\t%b\t%b\t%b\t%b", $time, I, A, D, addr_A, R, a, d, addr_a, j);
    
    // Wait 100 ns for global reset to finish
    #100;
    
    // Add stimulus here
    I = 16'h04D2; A = 16'h0007; D = 16'h0009; addr_A = 16'h000d;  // 测试案例 1
    #10;
    I = 16'he590; A = 16'h0007; D = 16'h0009; addr_A = 16'h000d;  // 测试案例 2
    #10;
    I = 16'he018; A = 16'h0006; D = 16'h0005; addr_A = 16'h0000;  // 测试案例 3
    #10;
    I = 16'hf4a3; A = 16'h0000; D = 16'h0000; addr_A = 16'h002a;  // 测试案例 4
    #10;
    I = 16'he760; A = 16'h002a; D = 16'h0001; addr_A = 16'h0002;  // 测试案例 5
    #10;
    
    // End simulation
    $finish; // End simulation after the last test case
end

endmodule
`endif

`endif // CONTROL_UNIT_V



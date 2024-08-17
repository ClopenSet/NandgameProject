`ifndef MULTIBITADDER_V
`define MULTIBITADDER_V

module BasicMultiBitAdder(
    input [1:0] a,
    input [1:0] b,
    input cin,
    output [1:0] sum,
    output cout
);
assign {cout,sum} = a+b+cin;
    
endmodule

`include "FullAdder.v"
module GateLevelMultiBitAdder(
    input [1:0] a,
    input [1:0] b,
    input cin,
    output [1:0] sum,
    output cout
);

wire carry[0:0];

GateLevelFullAdder f1(
    .a(a[0]),
    .b(b[0]),
    .c(cin),
    .h(carry[0]),
    .l(sum[0])
);
GateLevelFullAdder f2(
    .a(a[1]),
    .b(b[1]),
    .c(carry[0]),
    .h(cout),
    .l(sum[1])
);
    
endmodule


//超前进位原理：
//P[n] = a[n] | b[n] 是否能传播
//G[n] = a[n] & b[n] 是否能生成

//C[n+1] = G[n] | (C[n] & P[n])


`ifdef TB_MULTIBITADDER
`timescale 1ns / 1ps

module Testbench;
    reg [1:0] a;
    reg [1:0] b;
    reg cin;
    wire [1:0] sum_basic, sum_gate;
    wire cout_basic, cout_gate;

    // Instantiate the BasicMultiBitAdder
    BasicMultiBitAdder basic_adder (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum_basic),
        .cout(cout_basic)
    );

    // Instantiate the GateLevelMultiBitAdder
    GateLevelMultiBitAdder gate_adder (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum_gate),
        .cout(cout_gate)
    );

    initial begin
        integer i;
        // Display header
        $display(" A  B Cin | Sum_Basic Cout_Basic | Sum_Gate Cout_Gate | Match");
        $display("----------------------------------------------------------");

        // Test all input combinations
        
        for (i = 0; i < 32; i = i + 1) begin
            {a, b, cin} = i;  // Set input combinations
            #10;  // Delay for signal propagation

            // Display results
            $display("%b %b  %b  |   %b       %b       |   %b      %b     |   %s",
                     a, b, cin, sum_basic, cout_basic, sum_gate, cout_gate, 
                     (sum_basic == sum_gate) && (cout_basic == cout_gate) ? "Yes" : "No");
        end

        // Finish simulation
        $finish;
    end
endmodule

`endif


module BasicAdd16(
    input [15:0] a,  
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);
assign {cout,sum} = a + b + cin;
    
endmodule
`endif // MULTIBITADDER_V

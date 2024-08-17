module BasicFullAdder(
    input wire a,
    input wire b,
    input wire c, //carry
    output wire h, //high
    output wire l //low
);
    // assign {h,l} = a + b + c;

    //assign h = (b~&c) ~& (a ~& (b^c));
    assign h = (b&c) | (a & (b^c));
    assign l = a ^ b ^ c;
endmodule

module GateLevelFullAdder(
    input wire a,
    input wire b,
    input wire c, //carry
    output wire h, //high
    output wire l //low
);

//消除反相器得到
//wire h1,l1,h2;
//GateLevelHalfAdder half1 (.a(b),.b(c),.h(h1),.l(l1));
//GateLevelHalfAdder half2 (.a(a),.b(l1),.h(h2),.l(l));
//assign h = h1 | h2;



wire b_nand_c,b_imply_c,c_imply_b,b_xor_c,a_nand_bxorc,a_imply_bxorc,bxorc_imply_a;

nand (b_nand_c,b,c); // b ~& c
nand (b_imply_c,b_nand_c,b); // ~b | c
nand (c_imply_b,b_nand_c,c); // ~c | b
nand (b_xor_c,b_imply_c,c_imply_b); //  b ^ c

nand (a_nand_bxorc,a,b_xor_c); // a ~& (b ^ c)

nand (h,b_nand_c,a_nand_bxorc);
// h = (b~&c) ~& (a ~& (b^c)) = (b&c) | (a & (b^c)) = ((b&c)|a) & ((b&c)|(b^c)) = (a|b) & (b|c) & (c|a)
// (a|b) & (b|c) & (c|a) = (a&b) | (b&c) | (c&a) 都代表 abc 中至少有两个为真

nand (bxorc_imply_a,a_nand_bxorc,b_xor_c);// ~(b ^ c) | a
nand (a_imply_bxorc,a,a_nand_bxorc); //  ~a | (b ^ c) 
nand (l,a_imply_bxorc,bxorc_imply_a); // l = a ^ b ^ c


endmodule

`ifdef TB_FULLADDER

`timescale 1ns / 1ps

module Testbench;

    // Inputs
    reg a;
    reg b;
    reg c;

    // Outputs
    wire h_basic, l_basic;
    wire h_gate, l_gate;

    // Instantiate the BasicFullAdder module
    BasicFullAdder basic_fa (
        .a(a),
        .b(b),
        .c(c),
        .h(h_basic),
        .l(l_basic)
    );

    // Instantiate the GateLevelFullAdder module
    GateLevelFullAdder gate_fa (
        .a(a),
        .b(b),
        .c(c),
        .h(h_gate),
        .l(l_gate)
    );

    // Initialize inputs
    initial begin
        // Initialize Inputs
        a = 0; b = 0; c = 0;

        // Wait for global reset
        #100;
        
        // Add stimulus here
        $display("A B C | H_basic L_basic | H_gate L_gate");
        $display("-------------------------------");

        repeat (8) begin //repeat语句来模拟
            {a, b, c} = {a, b, c} + 1;
            #10; // Wait 10 ns for changes
            $display("%b %b %b |    %b       %b    |    %b      %b", a, b, c, h_basic, l_basic, h_gate, l_gate);
        end

        // Finish simulation
        #10;
        $finish;
    end

endmodule

`endif
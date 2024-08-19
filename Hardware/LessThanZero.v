`ifndef LESSTHANZERO_V
`define LESSTHANZERO_V

module GateLevelLessThanZero(
    input signed [15:0] num,
    output lessthan0
);
    assign lessthan0 = num [15];
endmodule

module BasicLessThanZero(
    input signed [15:0] num,
    output lessthan0
);
    assign lessthan0 = (num < 0);
endmodule

`ifdef TB_LESSTHANZERO
`timescale 1ns / 1ps

module tb_LessThanZero;

    // Inputs
    reg signed [15:0] num;

    // Outputs
    wire lessthan0_gate;
    wire lessthan0_basic;

    // Instantiate the Gate Level Less Than Zero Module
    GateLevelLessThanZero uut_gate (
        .num(num),
        .lessthan0(lessthan0_gate)
    );

    // Instantiate the Basic Less Than Zero Module
    BasicLessThanZero uut_basic (
        .num(num),
        .lessthan0(lessthan0_basic)
    );

    // Initialize all variables
    initial begin
        // Initialize Inputs
        num = 0;
        
        // Apply test cases
        #10 num = 16'sd0;       // Test with 0
        #10 num = -16'sd1;      // Test with -1
        #10 num = 16'sd32767;   // Test with maximum positive value
        #10 num = -16'sd32768;  // Test with maximum negative value

        #10 $finish; // Finish simulation
    end

    // Monitor changes and display results
    initial begin
        $monitor("At time %t, num = %d | lessthan0_gate = %b | lessthan0_basic = %b", 
                 $time, num, lessthan0_gate, lessthan0_basic);
    end

endmodule
`endif


`endif // LESSTHANZERO_V

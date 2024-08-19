`ifndef CONDITION_V
`define CONDITION_V

module BasicCondition(
    input lt,  // Less than zero flag
    input eq,  // Equal to zero flag
    input gt,  // Greater than zero flag
    input signed [15:0] X,  // Input value X
    output reg out  // Output based on the condition flags and value of X
);

    // Process the conditions based on the flags
    always @ (lt or eq or gt or X) begin
        // Initialize output to 0 (default case when no condition matches)
        out = 0;

        // Evaluate conditions based on the flag settings
        case ({lt, eq, gt})
            3'b000: out = 0;            // Never true
            3'b001: out = (X > 0);      // X > 0
            3'b010: out = (X == 0);     // X = 0
            3'b011: out = (X >= 0);     // X ≥ 0
            3'b100: out = (X < 0);      // X < 0
            3'b101: out = (X != 0);     // X ≠ 0
            3'b110: out = (X <= 0);     // X ≤ 0
            3'b111: out = 1;            // Always true
            default: out = 0;           // Handle unexpected cases
        endcase
    end

endmodule


module GateLevelCondition(
    input lt,  // Less than zero flag
    input eq,  // Equal to zero flag
    input gt,  // Greater than zero flag
    input signed [15:0] X,  // Input value X
    output wire out  // Output based on the condition flags and value of X
);

wire is_neg,is_zero;
wire n_neg,n_pos,n_zero;

assign is_neg = (X < 0);
assign is_zero = (X == 0); 

assign is_pos = ~ ( is_neg | is_zero );

// 思路：out = (is_neg & lt) | (is_pos & gt) | (is_zero & eq) 打开后消去反相器
nand (n_neg,lt,is_neg);
nand (n_pos,gt,is_pos);
nand (n_zero,eq,is_zero);

wire n_neg_zero;
and (n_neg_zero,n_neg,n_zero);
nand (out,n_neg_zero,n_pos);

endmodule

`ifdef TB_CONDITION

`timescale 1ns / 1ps

module TestBenchGateLevelCondition;
    reg lt, eq, gt;
    reg signed [15:0] X;
    wire out;

    // Instantiate the GateLevelCondition module
    GateLevelCondition uut (
        .lt(lt), 
        .eq(eq), 
        .gt(gt), 
        .X(X), 
        .out(out)
    );

    initial begin
        // Display format for monitoring the values
        $monitor("Time = %0t | lt = %b, eq = %b, gt = %b, X = %h, out = %b",
                 $time, lt, eq, gt, X, out);

        //sd的写法：signed decimal。负号写在最前面。

        // Test cases
        #10 {lt, eq, gt, X} = {1'b0, 1'b0, 1'b0, 16'sd0};    // Expected: 0
        #10 {lt, eq, gt, X} = {1'b0, 1'b0, 1'b0, 16'sd1};    // Expected: 0
        #10 {lt, eq, gt, X} = {1'b0, 1'b0, 1'b0, 16'sd2};    // Expected: 0
        #10 {lt, eq, gt, X} = {1'b0, 1'b0, 1'b0, -16'sd1};   // Expected: 0
        #10 {lt, eq, gt, X} = {1'b1, 1'b1, 1'b1, 16'sd0};    // Expected: 1
        #10 {lt, eq, gt, X} = {1'b1, 1'b1, 1'b1, -16'sd1};    // Expected: 1
        #10 {lt, eq, gt, X} = {1'b1, 1'b1, 1'b1, 16'sd2};    // Expected: 1
        #10 {lt, eq, gt, X} = {1'b1, 1'b1, 1'b1, -16'sd1};   // Expected: 1
        #10 {lt, eq, gt, X} = {1'b0, 1'b0, 1'b1, 16'sd0};    // Expected: 0
        #10 {lt, eq, gt, X} = {1'b0, 1'b0, 1'b1, 16'sd1};    // Expected: 1

        #10 $finish;
    end
endmodule
`endif

`endif // CONDITION_V

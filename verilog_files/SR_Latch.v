/*

Input	Output
s	r	
1	0	1
0	1	0
1	1	Previous output
0	0	Not used

*/



module GateLevel_SR_Latch(
    input wire s,
    input wire r,
    output wire q
);

wire q_n;

// 双nor也是可以的，根据对称性，00维持不变，11不使用
nand (q_n,s,q);
nand (q,r,q_n);
    
endmodule

module Basic_SR_Latch(
    input wire S,
    input wire R,
    output reg Q
);

always @(S, R) begin
    if (S == 0 && R == 1)
        Q <= 0;  // Set to 0 
    else if (S == 1 && R == 0)
        Q <= 1;  // Reset to 1 
    else if (S == 1 && R == 1)
        Q <= Q;  // Hold previous state
    else if (S == 0 && R == 0)
        Q <= 1; //Unused状况，设置为1 
end

endmodule


`ifdef TB_SR_LATCH

`timescale 1ns / 1ps

module tb_SR_Latch;

    // Inputs
    reg S;
    reg R;

    // Outputs from gate-level implementation
    wire Q_gate;

    // Outputs from behavior-level implementation
    wire Q_behavior;

    // Instantiate the Gate-Level SR Latch
    GateLevel_SR_Latch uut_gate (
        .s(S), 
        .r(R), 
        .q(Q_gate)
    );

    // Instantiate the Behavior-Level SR Latch
    Basic_SR_Latch uut_behavior (
        .S(S),
        .R(R),
        .Q(Q_behavior)
    );

    initial begin
        // Initialize Inputs
        S = 0; R = 0;
        #100;  // Initial stabilization delay

        // Test Sequence
        // Test Set Condition (S=1, R=0)
        S = 1; R = 0;
        #10;  // Wait 10 ns to observe the behavior
        $display("Test Set: S=1, R=0 -> Q_gate=%b, Q_behavior=%b", Q_gate, Q_behavior);

        // Test Reset Condition (S=0, R=1)
        S = 0; R = 1;
        #10;  // Wait 10 ns to observe the behavior
        $display("Test Reset: S=0, R=1 -> Q_gate=%b, Q_behavior=%b", Q_gate, Q_behavior);

        // Test Hold Condition (S=1, R=1)
        S = 1; R = 1;
        #10;  // Wait 10 ns to observe the behavior
        $display("Test Hold: S=1, R=1 -> Q_gate=%b, Q_behavior=%b", Q_gate, Q_behavior);

        // Test Unused Condition (S=0, R=0) - Optional, if needed
        S = 0; R = 0;
        #10;  // Wait 10 ns to observe the behavior
        $display("Test Unused: S=0, R=0 -> Q_gate=%b, Q_behavior=%b", Q_gate, Q_behavior);

        // Finish Simulation
        $finish;
    end
    
endmodule

`endif
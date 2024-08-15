module GateLevel_SR_Latch(
    input wire s,
    input wire r,
    output wire q
);

wire q_n;

nand (q,s,q_n);
nand (q_n,r,q);
    
endmodule

module Basic_SR_Latch(
    input wire S,
    input wire R,
    output reg Q
);

always @(S, R) begin
    if (S == 1 && R == 0)
        Q <= 0;  // Set to 0 
    else if (S == 0 && R == 1)
        Q <= 1;  // Reset to 1 
    else if (S == 1 && R == 1)
        Q <= Q;  // Hold previous state
    // S = 0, R = 0 - Assuming it maintains previous state if not unused
end

endmodule


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
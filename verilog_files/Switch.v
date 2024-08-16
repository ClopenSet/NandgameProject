module BasicSwitch(
    input wire s,
    input wire d,
    output wire c1,
    output wire c0 
);
    assign c1 = s ? d : 0;
    assign c0 = s ? 0 : d;
endmodule


module GateLevelSwitch(
    input wire s,
    input wire d,
    output wire c1,
    output wire c0 
);

assign c1 = s & d; 
// c0 = ~s & d = ~ (s | ~d) = ~ (s ~& d ~& d)
assign c0 = ~ (s ~& d ~& d);
endmodule

`ifdef TB_SWITCH
`timescale 1ns / 1ps

module tb_Switch;

    // Inputs
    reg s;
    reg d;

    // Outputs
    wire c1_basic, c0_basic;
    wire c1_gate, c0_gate;

    // Instantiate the Basic Switch Module
    BasicSwitch basic_switch (
        .s(s), 
        .d(d), 
        .c1(c1_basic), 
        .c0(c0_basic)
    );

    // Instantiate the Gate Level Switch Module
    GateLevelSwitch gate_switch (
        .s(s), 
        .d(d), 
        .c1(c1_gate), 
        .c0(c0_gate)
    );

    // Initialize all variables
    initial begin
        // Initialize Inputs
        s = 0;
        d = 0;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        $display("Time | s | d | c1_basic | c0_basic | c1_gate | c0_gate");
        $monitor("%4t | %b | %b |   %b     |   %b     |   %b    |   %b", $time, s, d, c1_basic, c0_basic, c1_gate, c0_gate);

        // Test all input combinations
        s = 0; d = 0; #10;
        s = 0; d = 1; #10;
        s = 1; d = 0; #10;
        s = 1; d = 1; #10;

        $finish;
    end
      
endmodule
`endif
module GateLevelSelector(
    input wire d0,
    input wire d1,
    input wire s,
    output q
);
    // s 为 0 时 选择 d0，s 为 1时选择 d1
    // 写dnf，或者考虑 s 和 ~s 作为 “掩码”

    // q = (~s & d0) | (s & d1) =  ~(~s & d0) ~& ~(s & d1) = (~s ~& d0) ~& (s ~& d1)

    assign q = (~s ~& d0) ~& (s ~& d1); 
    
endmodule


module BasicSelector(
    input wire d0,
    input wire d1,
    input wire s,
    output q
);
    assign q = s ? d1 : d0;
endmodule


`ifdef TB_SELECTOR
`timescale 1ns / 1ps

module tb_Selector;

    // Inputs
    reg d0;
    reg d1;
    reg s;

    // Outputs
    wire q1;
    wire q2;

    // Instantiate the Gate Level Selector Module
    GateLevelSelector gls (
        .d0(d0), 
        .d1(d1), 
        .s(s), 
        .q(q1)
    );

    // Instantiate the Basic Selector Module
    BasicSelector bs (
        .d0(d0), 
        .d1(d1), 
        .s(s), 
        .q(q2)
    );

    // Initialize all variables
    initial begin
        // Initialize Inputs
        d0 = 0;
        d1 = 0;
        s = 0;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        $display("Test     |  d0 | d1  | s | q1 (GL)| q2 (Basic) ");
        $monitor("%-8t |  %b  |  %b  | %b |   %b    |    %b", $time, d0, d1, s, q1, q2);

        // Test all input combinations
        d0 = 0; d1 = 0; s = 0; #10;
        d0 = 0; d1 = 0; s = 1; #10;
        d0 = 0; d1 = 1; s = 0; #10;
        d0 = 0; d1 = 1; s = 1; #10;
        d0 = 1; d1 = 0; s = 0; #10;
        d0 = 1; d1 = 0; s = 1; #10;
        d0 = 1; d1 = 1; s = 0; #10;
        d0 = 1; d1 = 1; s = 1; #10;

        $finish;
    end
      
endmodule
`endif
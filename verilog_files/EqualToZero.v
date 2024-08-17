`ifndef EQUALTOZERO_V
`define EQUALTOZERO_V

module BasicEqualToZero(
    input [3:0] a,
    output q
);
    assign q = ( a== 0 );

endmodule

module GateLevelEqualToZero(
    input [3:0] a,
    output q
);
    assign q = ~ (( a[0] | a[1] ) | (a[2] | a[3]));
endmodule

module BasicEqualToZero16(
    input [15:0] a,
    output q
);
    assign q = ( a== 0 );

endmodule
`endif // EQUALTOZERO_V

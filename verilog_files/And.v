`ifndef AND_V
`define AND_V

`include "Invert.v"

module GateLevelAnd (
    input wire a,
    input wire b,
    output wire q
);

nand (qnand,a,b);
BasicInvert invertbasic(qnand,q);

endmodule

module BasicAnd (
    input wire a,
    input wire b,
    output wire q
);
assign q= a & b;

endmodule


`endif // AND_V

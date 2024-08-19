`ifndef OR_V
`define OR_V

`include "Invert.v"

module BasicOr(
    input wire a,
    input wire b,
    output wire q
);
    assign q = a | b;
endmodule

module GateLevelOr(
    input wire a,
    input wire b,
    output wire q
);

GateLevelInvert inverta(a,n_a);
GateLevelInvert invertb(b,n_b); 
nand (q,n_a,n_b);
    
endmodule

`endif // OR_V

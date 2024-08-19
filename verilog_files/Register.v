`ifndef REGISTER_V
`define REGISTER_V


module BasicRegister(
    input wire st,
    input wire clk,
    input wire [15:0] in,
    output reg [15:0] out
);
    reg [15:0] stored_value;

    always @(posedge clk) begin
        if (st) stored_value <= in;
    end

    always @(negedge clk) begin
        out <= stored_value;
    end

endmodule



`include "DataFlipFlop.v"

module GateLevelRegister(
    input wire st,
    input wire clk,
    input wire [15:0] in,
    output reg [15:0] out
);
    genvar i;
    generate;
        for (i = 0;i <= 15; i = i + 1) begin: DFF
            BasicDFF dff (
                .q(out[i]),
                .st(st),
                .d(in[i]),
                .cl(clk)
            );
        end
    endgenerate
endmodule

`endif // REGISTER_V

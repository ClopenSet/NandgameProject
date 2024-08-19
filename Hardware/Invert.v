`ifndef INVERT_V
`define INVERT_V

module BasicInvert(
    input wire a,
    output wire q
);
    assign q = ~ a;
endmodule

module GateLevelInvert(
    input wire a,
    output wire q
);
    nand (q,a,a);
endmodule

`ifdef TB_INVERT

`timescale 1ns / 1ps

module testbench;
    reg a;
    wire q_basic;
    wire q_gatelevel;

    BasicInvert invertbasic (a,q_basic);
    GateLevelInvert invertgatelevel(a,q_gatelevel);

    initial begin
        a = 0;
        # 10;
        a = 1;
        # 10;
        $finish;
    end

    initial begin
        $monitor ("At time %t, a= %b, q_basic = %b, q_gatelevel = %b",$time,a,q_basic,q_gatelevel);
    end

    always @ (*) begin
        # 1; //延迟一段
        if (q_basic != q_gatelevel) begin
            $display ("Mismatch at time %t, a= %b, q_basic = %b, q_gatelevel = %b",$time,a,q_basic,q_gatelevel);
        end

    end


endmodule

`endif
`endif // INVERT_V

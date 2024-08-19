`ifndef CMOS_V
`define CMOS_V

module NMOS(
    input on,
    input i,
    output reg o
);
    always @(*) begin
        if (on == 1)
            o = i;
        else
            o = 1'bz; // 高阻态表示断路
    end
endmodule

module PMOS(
    input off,
    input i,
    output reg o
);
    always @(*) begin
        if (off == 0)
            o = i;
        else
            o = 1'bz; // 高阻态表示断路
    end
endmodule

module Junction(
    input i1,
    input i2,
    output reg o
);
    always @(*) begin
        if (i1 === 1'bz && i2 !== 1'bz)
            o = i2;
        else if (i2 === 1'bz && i1 !== 1'bz)
            o = i1;
        else if (i1 === i2)
            o = i1;
        else
            o = 1'bx; // 表示短路
    end
endmodule

`endif // CMOS_V

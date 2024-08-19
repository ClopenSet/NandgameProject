`ifndef ROM_V
`define ROM_V

module ROM(
    input wire [15:0] Ad,   // 地址输入
    output reg [15:0] data  // 数据输出
);

// 定义一个16位宽、1024深的存储数组
reg [15:0] mem [0:1023];

// 使用 $readmemh 从文件中初始化内存
initial begin
    $readmemh("rom_data.hex", mem);
end

// 在地址 Ad 上读取数据
always @(*) begin
    data = mem[Ad];  // 根据输入的地址 Ad 输出对应的数据
end

endmodule

`ifdef TB_ROM

`timescale 1ns / 1ps

module ROM_tb;

reg [15:0] Ad;           // 测试地址输入
wire [15:0] data;        // 输出数据

// 实例化ROM模块
ROM uut (
    .Ad(Ad),
    .data(data)
);

initial begin
    // 初始化地址
    Ad = 0; #10;  // 第一地址
    $display("Ad = %d, Data = %h", Ad, data);
    
    Ad = 1; #10;  // 第二地址
    $display("Ad = %d, Data = %h", Ad, data);

    Ad = 2; #10;  // 第三地址
    $display("Ad = %d, Data = %h", Ad, data);

    Ad = 3; #10;  // 第四地址
    $display("Ad = %d, Data = %h", Ad, data);
end

endmodule

`endif


`endif // ROM_V
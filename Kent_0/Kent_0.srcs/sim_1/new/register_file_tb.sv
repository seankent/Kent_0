//==============================================
// timescale
//==============================================
`timescale 1ns / 1ps

//==============================================
// register_file_tb
//==============================================
module register_file_tb;

    //==============================
    // dut
    //==============================
    register_file dut
    (
        .clk(clk),
        .rst(rst),
        .we(we),
        .addr_0(addr_0),
        .addr_1(addr_1),
        .addr_2(addr_2),
        .data_0(data_0),
        .data_1(data_1),
        .data_2(data_2)
    );

    //==============================
    // logic
    //==============================
    logic clk;
    logic rst;
    logic we;
    logic [2:0] addr_0;
    logic [2:0] addr_1;
    logic [2:0] addr_2;
    logic [7:0] data_0;
    logic [7:0] data_1;
    logic [7:0] data_2;
    
    //==============================
    // clock
    //==============================
    always begin
        #5 clk = !clk;
    end
    
    //==============================
    // initial
    //==============================
    initial begin
        clk = 0;
        rst = 0;
        we = 1;
        addr_0 = 3'h0;
        addr_1 = 3'h1;
        addr_2 = 3'h0;
        data_2 = 8'h0000;
        
        #10;
        
        addr_2 = 3'h1;
        data_2 = 8'h0001;
        
        #10;
        
        data_2 = 8'h0002;
        
        #100;
    end
    
    
endmodule

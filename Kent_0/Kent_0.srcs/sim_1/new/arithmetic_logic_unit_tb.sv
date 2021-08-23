//==============================================
// timescale
//==============================================
`timescale 1ns / 1ps

//==============================================
// arithmetic_logic_unit_tb
//==============================================
module arithmetic_logic_unit_tb;

    //==============================
    // dut
    //==============================
    arithmetic_logic_unit dut
    (
        .clk(clk),
        .rst(rst),
        .func(func),
        .data_0(data_0),
        .data_1(data_1),
        .data_2(data_2)
    );
    
    //==============================
    // logic
    //==============================
    logic clk;
    logic rst;
    logic [2:0] func;
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
        clk = 1'b0;
        rst = 1'b0;
        func = 3'h0;
        data_0 = 8'h01;
        data_1 = 8'h04;
        
        #10;
        
        func = 3'h1;
        
        #10;
        
        func = 3'h2;
        
        #10;
        
        func = 3'h3;
        
        #10;
        
        func = 3'h4;
        
        #10;
        
        func = 3'h5;
        
        #10;
        
        func = 3'h6;
        
        #10;
        
        func = 3'h7;
        
        #100;
    end
    
    
endmodule

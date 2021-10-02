//==============================================
// timescale
//==============================================
`timescale 1ns / 1ps

//==============================================
// system_tb
//==============================================
module system_tb;

    //==============================
    // dut
    //==============================
    system dut
    (
        .clk(clk),
        .rst(rst),
        .central_processing_unit_clk(central_processing_unit_clk)
    );

    //==============================
    // logic
    //==============================
    logic clk;
    logic rst;
    logic central_processing_unit_clk;
    
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
        
        #10;
        
        rst = 1;
        
        #10;
        
        rst = 0;
        
        #100;


    end
    
    
endmodule

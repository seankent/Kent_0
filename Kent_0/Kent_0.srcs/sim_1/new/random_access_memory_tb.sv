`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/23/2021 08:44:21 PM
// Design Name: 
// Module Name: random_access_memory_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module random_access_memory_tb;

    //==============================
    // dut
    //==============================
    random_access_memory random_access_memory_0
    (
        .clka(clk),
        .wea(wea),
        .addra(addra),
        .dina(dina),
        .douta(douta)
    );
    
    //==============================
    // logic
    //==============================
    logic clk;
    logic wea;
    logic [7:0] addra;
    logic [7:0] dina;
    logic [7:0] douta;
    


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
        wea = 1'b1;
        addra = 8'h00;
        dina = 8'haa;
        
        #10;
        
        addra = 8'h01;
        dina = 8'hbb;
        
        #10;
        
        addra = 8'h00;
        
        #10;
        
        $finish;
    end

endmodule

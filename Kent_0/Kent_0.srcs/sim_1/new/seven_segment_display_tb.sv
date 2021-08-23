//==============================================
// timescale
//==============================================
`timescale 1ns / 1ps

module seven_segment_display_tb;

    //==============================================
    // dut
    //==============================================
    seven_segment_display dut
    (
        .clk(clk),
        .rst(rst),
        .n_0(0), .n_1(1), .n_2(2), .n_3(3), .n_4(4), .n_5(5), .n_6(6), .n_7(7),
        .an(an),
        .ca(ca), .cb(cb), .cc(cc), .cd(cd), .ce(ce), .cf(cf), .cg(cg)
    );

    //==============================
    // logic
    //==============================
    logic clk;
    logic rst;
    logic [7:0] an;
    logic ca, cb, cc, cd, ce, cf, cg;
    
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

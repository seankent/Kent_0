//==============================================
// timescale
//==============================================
`timescale 1ns / 1ps

//==============================================
// central_processing_unit_tb
//==============================================
module central_processing_unit_tb;
    
    //==============================
    // dut
    //==============================
    central_processing_unit central_processing_unit_0
    (
        .clk(clk),
        .rst(rst),
        .ir(ir),
        .pc(pc),
        
        .r_0(r_0), .r_1(r_1), .r_2(r_2), .r_3(r_3), .r_4(r_4), .r_5(r_5), .r_6(r_6), .r_7(r_7)
    );
    
    //==============================
    // parameter
    //==============================
    parameter N = 10;
    
    //==============================
    // logic
    //==============================
    logic clk;
    logic rst;
    logic [15:0] ir;
    logic [7:0] pc;
    logic [15:0] ROM [255:0];
    
    int n;
    
    //==============================
    // debug logic
    //==============================
    logic [7:0] r_0, r_1, r_2, r_3, r_4, r_5, r_6, r_7;
    
    //==============================
    // assign
    //==============================
    assign ir = ROM[pc];
    
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
        $display("Loading ROM.");
        $readmemb("C:/Users/seanj/Documents/test/t_0.txt", ROM);
        
        clk = 1'b1;
        rst = 1'b1;
        
        #5;
        
        rst = 1'b0;
        
        #5;
        
        for (n = 0; n < N; n++) begin
            $display("pc: %h", pc);
            $display("ir: %h", ir);
            #10;
        end
        
        $finish;
    end

endmodule

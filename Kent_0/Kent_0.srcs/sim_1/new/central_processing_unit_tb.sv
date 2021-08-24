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
        .data_0(data_0),
        .data_1(data_1),
        .data_memory_data_2(data_memory_data_2),
        .data_memory_we(data_memory_we),
        
        .r_0(r_0), .r_1(r_1), .r_2(r_2), .r_3(r_3), .r_4(r_4), .r_5(r_5), .r_6(r_6), .r_7(r_7)
    );
    
    //==============================
    // data_memory_0
    //==============================
    data_memory data_memory_0
    (
        .clka(clk),
        .wea(wea),
        .addra(addra),
        .dina(dina),
        .douta(douta)
    );
    
    //==============================
    // program_memory
    //==============================
    program_memory program_memory_0
    (
        .clka(clk),
        .addra(pc),
        .douta(ir_temp)
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
    logic [7:0] data_0;
    logic [7:0] data_1;
    logic [7:0] data_memory_data_2;
    logic data_memory_we;
    
    logic [15:0] ir_temp;
    
    
    logic wea;
    logic [7:0] addra;
    logic [7:0] dina;
    logic [7:0] douta;
    
    logic [15:0] ROM [255:0];
    int n;
    
    //==============================
    // debug logic
    //==============================
    logic [7:0] r_0, r_1, r_2, r_3, r_4, r_5, r_6, r_7;
    
    //==============================
    // assign
    //==============================
    assign addra = data_1;
    assign dina = data_0;
    assign data_memory_data_2 = douta;
    assign wea = data_memory_we;
    
    //==============================
    // ROM read
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
        $readmemb("C:/Users/seanj/Documents/Kent_0/assembler/a.txt", ROM);
        
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

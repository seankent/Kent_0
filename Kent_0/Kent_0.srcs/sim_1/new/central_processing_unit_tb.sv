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
        .clk(central_processing_unit_clk),
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
        .douta(ir)
    );
    
    //==============================
    // parameter
    //==============================
    parameter N = 100;
    
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
    
    //logic [15:0] ir_temp;
    
    
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
    assign addra = data_0;
    assign dina = data_1;
    assign data_memory_data_2 = douta;
    assign wea = data_memory_we & state[5];
    
    //==============================
    // ROM read
    //==============================
    //assign ir = ROM[pc];
    
    //==============================
    // clock
    //==============================
    logic central_processing_unit_clk;
    logic [5:0] state = 6'h20;
    
    assign central_processing_unit_clk = state[0];
    //assign program_memory_clk = (state[1] | state[2]) & clk;
    always begin
        #5 clk = !clk;
    end
    
    always_ff @(posedge clk) begin
        state <= {state[4:0], state[5]};
    end
    
    //==============================
    // initial
    //==============================
    initial begin
        $display("Loading ROM.");
        $readmemb("C:/Users/seanj/Documents/Kent_0/assembler/a.txt", ROM);
        
        clk = 1'b1;
        rst = 1'b1;
        
        #10;
        
        rst = 1'b0;
        
        #9;
        
        for (n = 0; n < N; n++) begin
            $display("pc: %h", pc);
            $display("ir: %h", ir);
            #10;
        end
        
        $finish;
    end

endmodule

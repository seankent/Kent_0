//==============================================
// memory
//==============================================
module memory
(
    input logic clk,
    input logic rst,
    input logic [7:0] addr,
    input logic we,
    input data_wr,
    output data_rd,
    output port_0,
    output port_1,
    output port_2,
    output port_3,
    input x,
);
    
    //==============================
    // parameter
    //==============================
    parameter ADDR_IS = 8'hfb;
    
    //==============================
    // logic
    //==============================
    logic [7:0] memory [255:0];
    logic [7:0] ie;
    logic [7:0] is;
    logic [7:0] data_wr;
    logic [7:0] data_rd;
    logic [7:0] port_0;
    logic [7:0] port_1;
    logic [7:0] port_2;
    logic [7:0] port_3;
 
    //==============================
    // assign
    //==============================
    assign ie = memory[8'hfa];
    assign is = memory[8'hfb];
    assign port_0 = memory[8'hfc];
    assign port_1 = memory[8'hfd];
    assign port_2 = memory[8'hfe];
    assign port_3 = memory[8'hff];
    
    //==============================
    // always_comb
    //==============================
    always_comb begin
        data_rd = memory[addr];
    end
    
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        case (addr)
            
        memory[addr] <= we ? data_wr : memory[addr];
    end
    
endmodule

//==============================================
// data_memory
//==============================================
module data_memory
//(
//    input logic clk,
//    input logic rst,
//    input logic [7:0] addr,
//    input logic we,
//    input data_wr,
//    output data_rd,
//    output port_0,
//    output port_1,
//    output port_2,
//    output port_3
//);
    
//    //==============================
//    // logic
//    //==============================
//    logic [7:0] memory [255:0];
//    logic [7:0] data_wr;
//    logic [7:0] data_rd;
//    logic [7:0] port_0;
//    logic [7:0] port_1;
//    logic [7:0] port_2;
//    logic [7:0] port_3;
//    logic [7:0] ie;
    
//    //==============================
//    // assign
//    //==============================
//    assign port_0 = memory[8'hfc];
//    assign port_1 = memory[8'hfd];
//    assign port_2 = memory[8'hfe];
//    assign port_3 = memory[8'hff];
    
//    //==============================
//    // always_comb
//    //==============================
//    always_comb begin
//        data_rd = memory[addr];
//    end
    
//    //==============================
//    // always_ff
//    //==============================
//    always_ff @(posedge clk) begin
//        memory[addr] <= we ? data_wr : memory[addr];
//    end
    
endmodule
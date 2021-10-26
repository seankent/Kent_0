//==============================================
// instruction_memory
//==============================================
module instruction_memory
(
    input logic clk,
    input logic rst,
    input logic [7:0] addr,
    input logic we,
    input data_wr,
    output data_rd
);
    
    //==============================
    // logic
    //==============================
    logic [15:0] memory [255:0];
    logic [15:0] data_wr;
    logic [15:0] data_rd;
    
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
        memory[addr] <= we ? data_wr : memory[addr];
    end
    
endmodule

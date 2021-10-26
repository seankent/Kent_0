//==============================================
// data_memory
//==============================================
module data_memory
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
    output ie,
    output te,
    output timer_0_N,
    output timer_1_N
);
    //==============================
    // parameter
    //==============================
    parameter ADDR_TIMER_0_N_L = 8'hf6;
    parameter ADDR_TIMER_0_N_H = 8'hf7;
    parameter ADDR_TIMER_1_N_L = 8'hf8;
    parameter ADDR_TIMER_1_N_H = 8'hf8;
    parameter ADDR_TE = 8'hfa;
    parameter ADDR_IE = 8'hfb;
    parameter ADDR_PORT_0 = 8'hfc;
    parameter ADDR_PORT_1 = 8'hfd;
    parameter ADDR_PORT_2 = 8'hfe;
    parameter ADDR_PORT_3 = 8'hff;
    
    //==============================
    // logic
    //==============================
    logic [7:0] memory [255:0];
    logic [7:0] data_wr;
    logic [7:0] data_rd;
    logic [7:0] port_0;
    logic [7:0] port_1;
    logic [7:0] port_2;
    logic [7:0] port_3;
    logic [7:0] ie;
    logic [7:0] te;
    logic [15:0] timer_0_N;
    logic [15:0] timer_1_N;
    
    //==============================
    // assign
    //==============================
    assign timer_0_N = {memory[ADDR_TIMER_0_N_H], memory[ADDR_TIMER_0_N_L]};
    assign timer_1_N = {memory[ADDR_TIMER_1_N_H], memory[ADDR_TIMER_1_N_L]};
    assign te = memory[ADDR_TE];
    assign ie = memory[ADDR_IE];
    assign port_0 = memory[ADDR_PORT_0];
    assign port_1 = memory[ADDR_PORT_1];
    assign port_2 = memory[ADDR_PORT_2];
    assign port_3 = memory[ADDR_PORT_3];
    
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
        if (rst) begin
            memory[ADDR_TE] <= 8'h00;
            memory[ADDR_IE] <= 8'h00;
            memory[ADDR_PORT_0] <= 8'h00;
            memory[ADDR_PORT_1] <= 8'h00;
            memory[ADDR_PORT_2] <= 8'h00;
            memory[ADDR_PORT_3] <= 8'h00;
        end 
        else memory[addr] <= we ? data_wr : memory[addr];
    end
    
endmodule

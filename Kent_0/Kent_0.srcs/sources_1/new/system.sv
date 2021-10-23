//==============================================
// system
//==============================================
module system
(
    input logic clk,
    input logic ext_rst,
    input logic [7:0] pc,
    input [7:0] data_memory_addr,
    input data_memory_we,
    output port_0_we,
    output port_1_we,
    output [7:0] rom_addr,
    output [7:0] program_memory_addr,
    output program_memory_we,
    output rst
    
);

    //==============================
    // parameters
    //==============================
    parameter RESET = 3'h0;
    parameter LOAD_0 = 3'h1;
    parameter LOAD_1 = 3'h2;
    parameter LOAD_2 = 3'h3;
    parameter RUN = 3'h4;
    
    parameter PORT_0_ADDR = 8'hfe;
    parameter PORT_1_ADDR = 8'hff;
    
    
    //==============================
    // logic
    //==============================
    logic [2:0] state;
    logic [7:0] rom_addr;
    logic [7:0] program_memory_addr;
    logic program_memory_we;
    logic rst;
    logic port_0_we;
    logic port_1_we;

    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        if (ext_rst) state <= RESET;
        else begin
            case (state)
                RESET: state <= LOAD_0;
                LOAD_0: state <= LOAD_1;
                LOAD_1: state <= LOAD_2;
                LOAD_2: state <= (rom_addr == 8'hff) ? RUN : LOAD_0;
                RUN: state <= RUN;
            endcase
        end
    end
    
    //==============================
    // always_ff
    //============================== 
    always_ff @(posedge clk) begin
        case (state)
            RESET: rom_addr <= 0'h00;
            LOAD_2: rom_addr <= rom_addr + 1;
        endcase
    end
    
    //==============================
    // always_comb
    //============================== 
    always_comb begin
        rst = 1'b1;
        case (state)
            RUN: rst = 1'b0;
        endcase
    end

    //==============================
    // always_comb
    //============================== 
    always_comb begin
        program_memory_we = 1'b0;
        case (state)
            LOAD_2: program_memory_we = 1'b1;
        endcase
    end
    
    //==============================
    // always_comb
    //============================== 
    always_comb begin
        program_memory_addr = rom_addr;
        case (state)
            RUN: program_memory_addr = pc;
        endcase
    end
    
    //==============================
    // always_comb
    //============================== 
    always_comb begin
        port_0_we = 1'b0;
        case (state)
            RUN: port_0_we = ((data_memory_addr == PORT_0_ADDR) & data_memory_we) ? 1'b1 : 1'b0;
        endcase
    end
    
    //==============================
    // always_comb
    //============================== 
    always_comb begin
        port_1_we = 1'b0;
        case (state)
            RUN: port_1_we = ((data_memory_addr == PORT_1_ADDR) & data_memory_we) ? 1'b1 : 1'b0;
        endcase
    end
    
    
    
endmodule

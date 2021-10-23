//==============================================
// kent_0
//==============================================
module kent_0
(   
    input clk,
    input ext_rst,
    output [7:0] port_0_data,
    output [7:0] port_1_data
);

    //==============================
    // logic
    //==============================
    // system
    logic clk;
    logic rst;
    logic [7:0] pc;
    logic [15:0] ir;
    // data memory interface
    logic [7:0] data_memory_addr;
    logic [7:0] data_memory_data_wr;
    logic [7:0] data_memory_data_rd;
    logic data_memory_we;
    // program memory interface
    logic [7:0] program_memory_addr;
    logic program_memory_we;
    // ROM interface
    logic [7:0] rom_addr;
    logic [15:0] rom_data;
    // port 0 interface
    logic [7:0] port_0_data;
    logic port_0_we;
    // port 1 interface
    logic [7:0] port_1_data;
    logic port_1_we;

    //==============================
    // system_0
    //==============================
    system system_0
    (
        .clk(clk),
        .ext_rst(ext_rst),
        .pc(pc),
        .data_memory_addr(data_memory_addr),
        .data_memory_we(data_memory_we),
        .port_0_we(port_0_we),
        .port_1_we(port_1_we),
        .rom_addr(rom_addr),
        .program_memory_addr(program_memory_addr),
        .program_memory_we(program_memory_we),
        .rst(rst)
    );

    //==============================
    // central_processing_unit_0
    //==============================
    central_processing_unit central_processing_unit_0
    (
        .clk(clk),
        .rst(rst),
        .ir(ir),
        .pc(pc),
        .data_memory_addr(data_memory_addr),
        .data_memory_data_wr(data_memory_data_wr),
        .data_memory_data_rd(data_memory_data_rd),
        .data_memory_we(data_memory_we)
    );
    
    //==============================
    // program_memory
    //==============================
    memory #(.WIDTH(16)) program_memory 
    (
        .clk(clk),
        .rst(rst),
        .addr(program_memory_addr),
        .we(program_memory_we),
        .data_wr(rom_data),
        .data_rd(ir)
    );
    
    //==============================
    // data_memory
    //==============================
    memory data_memory
    (
        .clk(clk),
        .rst(rst),
        .addr(data_memory_addr),
        .we(data_memory_we),
        .data_wr(data_memory_data_wr),
        .data_rd(data_memory_data_rd)
    );
    
    //==============================
    // rom_0
    //==============================
    rom rom_0
    (
        .clka(clk),
        .addra(rom_addr),
        .douta(rom_data)
    );

    //==============================
    // port_0
    //==============================     
    port port_0
    (
        .clk(clk),
        .rst(rst),
        .we(port_0_we),
        .data_wr(data_memory_data_wr),
        .data(port_0_data)
    );

    //==============================
    // port_1
    //==============================    
    port port_1
    (
        .clk(clk),
        .rst(rst),
        .we(port_1_we),
        .data_wr(data_memory_data_wr),
        .data(port_1_data)
    );
    
endmodule

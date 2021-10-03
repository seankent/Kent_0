//==============================================
// kent_0
//==============================================
module kent_0
(   
    input clk,
    input rst,
    output [7:0] port_0_data,
    output [7:0] port_1_data
);

    //==============================
    // logic
    //==============================
    // system
    logic clk;
    logic rst;
    // central_processing_unit, program_memory, data_memory
    logic [15:0] ir;
    logic [7:0] pc;
    logic [7:0] data_0;
    logic [7:0] data_1;
    logic [7:0] data_memory_data_2;
    logic memory_we;
    logic wea;
    logic central_processing_unit_clk;
    logic central_processing_unit_rst;
    logic [7:0] port_0_data;
    logic [7:0] port_1_data;
    logic port_0_we;
    logic prot_1_we;
    
    //==============================
    // assign
    //==============================

    //==============================
    // system_0
    //==============================
    system system_0
    (
        .clk(clk),
        .rst(rst),
        .memory_we(memory_we),
        .data_0(data_0),
        .central_processing_unit_clk(central_processing_unit_clk),
        .central_processing_unit_rst(central_processing_unit_rst),
        .wea(wea),
        .port_0_we(port_0_we),
        .port_1_we(port_1_we)
    );

    //==============================
    // central_processing_unit_0
    //==============================
    central_processing_unit central_processing_unit_0
    (
        .clk(central_processing_unit_clk),
        .rst(central_processing_unit_rst),
        .ir(ir),
        .pc(pc),
        .data_0(data_0),
        .data_1(data_1),
        .data_memory_data_2(data_memory_data_2),
        .memory_we(memory_we)
    );
    
    //==============================
    // program_memory_0
    //==============================
    program_memory program_memory_0
    (
        .clka(clk),
        .addra(pc),
        .douta(ir)
    );
    
    //==============================
    // data_memory_0
    //==============================
    data_memory data_memory_0
    (
        .clka(clk),
        .wea(wea),
        .addra(data_0),
        .dina(data_1),
        .douta(data_memory_data_2)
    );
    
    
    port port_0
    (
        .clk(clk),
        .rst(rst),
        .we(port_0_we),
        .data_0(data_1),
        .data_1(port_0_data)
    );
    
    port port_1
    (
        .clk(clk),
        .rst(rst),
        .we(port_1_we),
        .data_0(data_1),
        .data_1(port_1_data)
    );
    
endmodule

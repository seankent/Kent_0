//==============================================
// central_processing_unit
//==============================================
module central_processing_unit
(
    input logic clk,
    input logic rst,
    input logic [15:0] ir,
    output pc,
    output [7:0] data_0,
    output [7:0] data_1,
    input logic [7:0] data_memory_data_2,
    output memory_we
);

    //==============================
    // logic
    //==============================
    logic [7:0] pc; // program counter
    logic [7:0] pc_plus_one;
    logic [7:0] pc_plus_imm;
    //logic [15:0] ir; // instruction register
    logic [2:0] addr_0, addr_1, addr_2;
    logic [7:0] data_0, data_1, data_2;
    logic [7:0] arithmetic_logic_unit_0_data_2;
    logic [2:0] func; // alu function selection 
    logic [7:0] imm; // 8-bit immediate 
    logic we; // write enable (for register file)
    logic [1:0] pc_sel;
    logic [2:0] ctrl_flow_type;
    logic [1:0] data_2_sel;
    logic eq, ne, lt, le;
    logic memory_we;
    
    //==============================
    // program_counter_0
    //==============================
    program_counter program_counter_0
    (
        .clk(clk),
        .rst(rst),
        .ctrl_flow_type(ctrl_flow_type),
        .eq(eq),
        .ne(ne),
        .lt(lt),
        .le(le),
        .imm(imm),
        .data_0(data_0),
        .pc(pc),
        .pc_plus_one(pc_plus_one),
        .pc_plus_imm(pc_plus_imm)
    );
    
    //==============================
    // decode_0
    //==============================
    decode decode_0
    (
        .clk(clk),
        .rst(rst),
        .ir(ir),
        .addr_0(addr_0), 
        .addr_1(addr_1), 
        .addr_2(addr_2),
        .func(func),
        .imm(imm),
        .we(we),
        .ctrl_flow_type(ctrl_flow_type),
        .data_2_sel(data_2_sel),
        .memory_we(memory_we)
    );
    
    //==============================
    // mux_4_to_1_0
    //==============================
    mux_4_to_1 mux_4_to_1_0
    (
        .clk(clk),
        .rst(rst),
        .sel(data_2_sel),
        .in_0(arithmetic_logic_unit_0_data_2),
        .in_1(imm),
        .in_2(data_memory_data_2),
        .in_3(pc_plus_one),
        .out(data_2)
    );
    
    //==============================
    // register_file_0
    //==============================
    register_file register_file_0
    (
        .clk(clk),
        .rst(rst),
        .we(we),
        .addr_0(addr_0),
        .addr_1(addr_1),
        .addr_2(addr_2),
        .data_0(data_0),
        .data_1(data_1),
        .data_2(data_2)
    );

    //==============================
    // arithmetic_logic_unit
    //==============================
    arithmetic_logic_unit arithmetic_logic_unit_0
    (
        .clk(clk),
        .rst(rst),
        .func(func),
        .data_0(data_0),
        .data_1(data_1),
        .data_2(arithmetic_logic_unit_0_data_2),
        .eq(eq),
        .ne(ne),
        .lt(lt),
        .le(le)
    );
    
endmodule

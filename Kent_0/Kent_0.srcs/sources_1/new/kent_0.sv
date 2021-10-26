//==============================================
// kent_0
//==============================================
module kent_0
(   
    input clk,
    input ext_rst,
    output port_0,
    output port_1,
    output port_2,
    output port_3
);

    //==============================
    // logic
    //==============================
    // system
    logic clk;
    logic rst;
    logic [7:0] pc;
    logic [15:0] ir;
    logic [7:0] is;
    // data memory interface
    logic [7:0] data_memory_addr;
    logic [7:0] data_memory_data_wr;
    logic [7:0] data_memory_data_rd;
    logic data_memory_we;
    // program memory interface
    logic [7:0] instruction_memory_addr;
    logic instruction_memory_we;
    // ROM interface
    logic [7:0] rom_addr;
    logic [15:0] rom_data;
    // ports
    logic [7:0] port_0;
    logic [7:0] port_1;
    logic [7:0] port_2;
    logic [7:0] port_3;
    // interupt enable
    logic [7:0] ie;
    // timer enable
    logic [7:0] te;
    // timer 0
    logic [15:0] timer_0_N;
    logic timer_0_rst;
    logic timer_0_ov;
    // timer 1
    logic [15:0] timer_1_0;
    logic timer_1_rst;
    logic timer_1_ov;
    // interupt logic
    logic intr_0;
    logic intr_1;
    
    //==============================
    // assign
    //==============================
    assign intr_0 = timer_0_ov;
    assign intr_1 = timer_1_ov;

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
        .rom_addr(rom_addr),
        .instruction_memory_addr(instruction_memory_addr),
        .instruction_memory_we(instruction_memory_we),
        .rst(rst),
        .is(is),
        .ie(ie),
        .te(te),
        .timer_0_rst(timer_0_rst),
        .timer_0_ov(timer_0_ov),
        .timer_1_rst(timer_1_rst),
        .timer_1_ov(timer_1_ov),
        .enter_intr(enter_intr),
        .intr_addr(intr_addr)
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
        .data_memory_we(data_memory_we),
        .ie(ie),
        .intr_0(intr_0),
        .intr_1(intr_1)
    );
    
    //==============================
    // instruction_memory_0
    //==============================
    instruction_memory instruction_memory_0
    (
        .clk(clk),
        .rst(rst),
        .addr(instruction_memory_addr),
        .we(instruction_memory_we),
        .data_wr(rom_data),
        .data_rd(ir)
    );
    
    //==============================
    // data_memory_0
    //==============================
    data_memory data_memory_0
    (
        .clk(clk),
        .rst(rst),
        .addr(data_memory_addr),
        .we(data_memory_we),
        .data_wr(data_memory_data_wr),
        .data_rd(data_memory_data_rd),
        .port_0(port_0),
        .port_1(port_1),
        .port_2(port_2),
        .port_3(port_3),
        .ie(ie),
        .te(te),
        .timer_0_N(timer_0_N),
        .timer_1_N(timer_1_N)
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
    // timer_0
    //==============================
    timer timer_0
    (
        .clk(clk),
        .rst(timer_0_rst),
        .N(timer_0_N),
        .ov(timer_0_ov)
    );
    
    //==============================
    // timer_1
    //==============================
    timer timer_1
    (
        .clk(clk),
        .rst(timer_1_rst),
        .N(timer_1_N),
        .ov(timer_1_ov)
    );

endmodule

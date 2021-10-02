//==============================================
// top
//==============================================
module top
(   
    input clk_100mhz, //clock
    input [15:0] sw,         //switches
    input btnc,       //center button
    input btnu,      //up button
    input btnl,       //left button
    input btnr,       //right button
    input btnd,       //down button
    output logic [15:0] led,        //little LEDs above switches
    output logic led16_b,    //blue channel left RGB LED
    output logic led16_g,    //green channel left RGB LED
    output logic led16_r,    //red channel left RGB LED
    output logic led17_b,    //blue channel right RGB LED
    output logic led17_g,    //green channel right RGB LED
    output logic led17_r,    //red channel right RGB LED
    output logic [7:0] an,
    output logic ca, cb, cc, cd, ce, cf, cg
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
    logic data_memory_we;
    logic wea;
    logic central_processing_unit_clk;
    logic central_processing_unit_rst;
    logic we_cycle;
    
    //==============================
    // assign
    //==============================
    assign wea = data_memory_we & we_cycle;

    //==============================
    // system_0
    //==============================
    system system_0
    (
        .clk(clk),
        .rst(rst),
        .central_processing_unit_clk(central_processing_unit_clk),
        .central_processing_unit_rst(central_processing_unit_rst),
        .we_cycle(we_cycle)
    );

    //==============================
    // central_processing_unit_0
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
        .data_memory_we(data_memory_we)
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
    
endmodule
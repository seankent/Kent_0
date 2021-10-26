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
    logic clk;
    logic rst;
    logic btnd_clean;
    logic [7:0] port_0;
    logic [7:0] port_1;
    logic [7:0] port_2;
    logic [7:0] port_3;
        
    //==============================
    // assign
    //==============================
    assign clk = clk_100mhz;
    assign rst = btnd_clean;
    assign led[7:0] = port_0;
    assign led[15:8] = port_1;

    //==============================
    // k0
    //==============================
    kent_0 k0
    (
        .clk(clk),
        .ext_rst(rst),
        .port_0(port_0),
        .port_1(port_1),
        .port_2(port_2),
        .port_3(port_3)
    );
    
    //==============================
    // debouncer_0
    //==============================
    debouncer debouncer_0
    (
        .clk(clk),
        .rst(1'b0),
        .in(btnd),
        .out(btnd_clean)
    );
    
endmodule
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
    logic [15:0] counter_0_count;
    logic btnd_clean;
    logic [15:0] counter_1_count;
    logic ov;
    
    //==============================
    // assign
    //==============================
    assign clk = clk_100mhz;
    assign rst = btnc;
    
    //==============================
    // seven_segment_display_0
    //==============================
    seven_segment_display seven_segment_display_0
    (
        .clk(clk),
        .rst(rst),
        .en(8'h13),
        .n_0(counter_0_count[3:0]), .n_1(counter_0_count[7:4]), .n_2(4'h0), .n_3(4'h0), .n_4(counter_1_count[15:12]), .n_5(4'h0), .n_6(4'h0), .n_7(4'h0),
        .an(an),
        .ca(ca), .cb(cb), .cc(cc), .cd(cd), .ce(ce), .cf(cf), .cg(cg)
    );
    
    //==============================
    // debouncer_0
    //==============================
    debouncer debouncer_0
    (
        .clk(clk),
        .rst(rst),
        .in(btnd),
        .out(btnd_clean)
    );
    
    //==============================
    // counter_0
    //==============================
    counter counter_0
    (
        .clk(clk),
        .rst(rst),
        .evt(btnd_clean),
        .count(counter_0_count)
    );
    
    //==============================
    // timer_0
    //==============================
    timer timer_0
    (
        .clk(clk),
        .rst(rst),
        .N(16'h5F5E),
        .ov(ov)
    );
    
    //==============================
    // counter_1
    //==============================
    counter counter_1
    (
        .clk(clk),
        .rst(rst),
        .evt(ov),
        .count(counter_1_count)
    );
    

    
//    (
//        .clk(clk),
//        .rst(rst),
//        .en(1'b1),
//        .count(timer_0_count)
//    );
    

endmodule
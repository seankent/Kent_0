//==============================================
// clocks
//==============================================
module clocks
(
    input logic clk,
    input logic rst,
    output clk_div_8
);

    //==============================
    // logic
    //==============================
    logic [1:0] count;
    logic clk_div_8;
    
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        if (rst) count <= 2'h0;
        else count <= count + 1;
    end 
    
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        if (rst) clk_div_8 <= 1'b0;
        else if (count[1:0] == 2'b11) clk_div_8 <= ~clk_div_8;
    end 

endmodule

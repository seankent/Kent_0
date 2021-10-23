//==============================================
// port
//==============================================
module port
(
    input logic clk,
    input logic rst,
    input logic we,
    input logic [7:0] data_wr,
    output data
);
    
    //==============================
    // logic
    //==============================
    logic [7:0] data;
    
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        if (rst) data <= 8'h00;
        else data <= we ? data_wr : data; 
    end 
    
endmodule

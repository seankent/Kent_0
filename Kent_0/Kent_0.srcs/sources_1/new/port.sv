//==============================================
// port
//==============================================
module port(
    input logic clk,
    input logic rst,
    input logic we,
    input logic [7:0] data_0,
    output logic [7:0] data_1
    
    );
    
    //==============================
    // logic
    //==============================
    logic [7:0] data_1;
    
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        if (rst) data_1 <= 8'h00;
        else data_1 <= we ? data_0 : data_1; 
    end 
endmodule

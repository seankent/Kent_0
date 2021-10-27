//==============================================
// timer
//==============================================
module timer
(
    input logic clk,
    input logic rst,
    input logic [31:0] N,   // for a period of x clock cycles, set N = x - 1
    output logic ov
);
    
    //==============================
    // logic
    //==============================
    logic [31:0] n;
    
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        ov = (n == N) ? 1'b1 : 1'b0;
    end
    
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        if (rst) n <= 31'h00_00_00_00;
        else n <= (n == N) ? 31'b00_00_00_00 : n + 1;
    end

endmodule


//==============================================
// counter
//==============================================
module counter
(
    input logic clk,
    input logic rst,
    input logic evt,
    output logic [15:0] count
);

    //==============================
    // logic
    //==============================
    logic evt_prev;
    
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        evt_prev <= evt;
    end
    
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        if (rst) count <= 16'h0000;
        else begin
            count <= (evt & ~evt_prev) ? count + 1 : count;
        end
    end
endmodule

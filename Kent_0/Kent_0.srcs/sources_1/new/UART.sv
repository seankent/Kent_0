//==============================================
// UART
//==============================================
module UART
(
    input logic clk,
    input logic rst,
    input logic trig,
    input logic [7:0] data,
    output logic tx
);
    //==============================
    // parameter
    //==============================
    parameter START_BIT = 1'b0;
    parameter STOP_BIT = 1'b1;
    parameter IDLE = 1'b0;

    //==============================
    // logic
    //==============================
    logic [3:0] state;
    logic [9:0] data_tx_shift_buffer;
    
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        if (rst) data_tx_shift_buffer <= 10'b1;
        data_tx_shift_buffer <= {STOP_BIT, data[7:0], START_BIT};
        data_tx_shift_buffer <= {1'b1, data_tx_shift_buffer[9:1]};
    end
    
    
endmodule

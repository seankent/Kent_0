//==============================================
// mux_4_to_1
//==============================================
module mux_4_to_1
(
    input logic clk,
    input logic rst,
    input logic [1:0] sel,
    input logic [7:0] in_0,
    input logic [7:0] in_1,
    input logic [7:0] in_2,
    input logic [7:0] in_3,
    output logic [7:0] out
);
    
    //==============================
    // always_comb
    //==============================
    always_comb begin
        case (sel)
            2'h0: out = in_0;
            2'h1: out = in_1;
            2'h2: out = in_2;
            2'h3: out = in_3;
        endcase
    end
    
endmodule

//==============================================
// register_file
//==============================================
module register_file
(
    input logic clk,
    input logic rst,
    input logic we,
    input logic [2:0] addr_0, 
    input logic [2:0] addr_1, 
    input logic [2:0] addr_2,
    output logic [7:0] data_0,
    output logic [7:0] data_1,
    input logic [7:0] data_2,
    
    output [7:0] r_0,
    output [7:0] r_1,
    output [7:0] r_2,
    output [7:0] r_3,
    output [7:0] r_4,
    output [7:0] r_5,
    output [7:0] r_6,
    output [7:0] r_7
);

    //==============================
    // logic
    //==============================
    logic [7:0] r_0, r_1, r_2, r_3, r_4, r_5, r_6, r_7;

    //==============================
    // assign
    //==============================
    assign r_0 = 8'h00;
     
    //==============================
    // always_comb
    //==============================
    always_comb begin
        case (addr_0)
            3'h0: data_0 = r_0;
            3'h1: data_0 = r_1;
            3'h2: data_0 = r_2;
            3'h3: data_0 = r_3;
            3'h4: data_0 = r_4;
            3'h5: data_0 = r_5;
            3'h6: data_0 = r_6;
            3'h7: data_0 = r_7;
        endcase
    end
    
    //==============================
    // always_comb
    //==============================
    always_comb begin
        case (addr_1)
            3'h0: data_1 = r_0;
            3'h1: data_1 = r_1;
            3'h2: data_1 = r_2;
            3'h3: data_1 = r_3;
            3'h4: data_1 = r_4;
            3'h5: data_1 = r_5;
            3'h6: data_1 = r_6;
            3'h7: data_1 = r_7;
        endcase
    end
    
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        case (addr_2)
            // 3'h0: r_0 <= we ? data_2 : r_0;
            3'h1: r_1 <= we ? data_2 : r_1;
            3'h2: r_2 <= we ? data_2 : r_2;
            3'h3: r_3 <= we ? data_2 : r_3;
            3'h4: r_4 <= we ? data_2 : r_4;
            3'h5: r_5 <= we ? data_2 : r_5;
            3'h6: r_6 <= we ? data_2 : r_6;
            3'h7: r_7 <= we ? data_2 : r_7;
        endcase
    end
    
endmodule

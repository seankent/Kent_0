//==============================================
// arithmetic_logic_unit
//==============================================
module arithmetic_logic_unit
(
    input logic clk,
    input logic rst,
    input logic [2:0] func,
    input logic [7:0] data_0,
    input logic [7:0] data_1,
    output logic [7:0] data_2,
    output logic eq,
    output logic ne,
    output logic lt,
    output logic le
);

    //==============================
    // assign
    //==============================
    assign eq = (data_0 == data_1);
    assign ne = ~eq;
    assign lt = data_0 < data_1;
    assign le = lt & eq;
    
    //==============================
    // always_comb
    //==============================
    always_comb begin
        case (func)
            3'h0: data_2 = data_0 + data_1;
            3'h1: data_2 = data_0 - data_1;
            3'h2: data_2 = data_0 & data_1;
            3'h3: data_2 = data_0 | data_1;
            3'h4: data_2 = data_0 ^ data_1;
            3'h5: data_2 = data_0 << data_1;
            3'h6: data_2 = data_0 >> data_1;
            3'h7: data_2 = 8'h0;
        endcase
    end
    

    
    
endmodule

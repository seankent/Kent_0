//==============================================
// system
//==============================================
module system
(
    input logic clk,
    input logic rst,
    input logic memory_we,
    input logic [7:0] data_0,
    output logic central_processing_unit_clk,
    output logic central_processing_unit_rst,
    output logic wea,
    output logic port_0_we,
    output logic port_1_we
);

    //==============================
    // parameters
    //==============================
    parameter STATE_0 = 3'h0;
    parameter STATE_1 = 3'h1;
    parameter STATE_2 = 3'h2;
    parameter STATE_3 = 3'h3;
    parameter STATE_4 = 3'h4;
    parameter STATE_5 = 3'h5;
    
    
    //==============================
    // logic
    //==============================
    logic [2:0] state;
    logic central_processing_unit_clk;
    logic central_processing_unit_rst;
    logic wea;
    logic port_0_we;
    logic port_1_we;
    
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        if (rst) state <= STATE_0;
        else begin
            case (state)
                STATE_0: state <= STATE_1;
                STATE_1: state <= STATE_2;
                STATE_2: state <= STATE_3;
                STATE_3: state <= STATE_4;
                STATE_4: state <= STATE_5;
                STATE_5: state <= STATE_0;
            endcase
        end
    end 
    
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        if (rst) central_processing_unit_clk <= 1'b0;
        else begin
            case (state)
                STATE_2: central_processing_unit_clk <= 1'b0;
                STATE_5: central_processing_unit_clk <= 1'b1;
            endcase
        end
    end
    
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        if (rst) central_processing_unit_rst <= 1'b1;
        else if (central_processing_unit_clk) central_processing_unit_rst <= 1'b0; 
    end
    
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        if (rst) wea <= 1'b0;
        else begin
            case (state)
                STATE_4: wea <= memory_we ? 1'b1 : 1'b0;
                STATE_5: wea <= 1'b0;
            endcase
        end
    end
    
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        if (rst) port_0_we <= 1'b0;
        else begin
            case (state)
                STATE_4: port_0_we <= (memory_we & (data_0 == 8'hfe)) ? 1'b1 : 1'b0;
                STATE_5: port_0_we <= 1'b0;
            endcase
        end
    end
    
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        if (rst) port_1_we <= 1'b0;
        else begin
            case (state)
                STATE_4: port_1_we <= (memory_we & (data_0 == 8'hff)) ? 1'b1 : 1'b0;
                STATE_5: port_1_we <= 1'b0;
            endcase
        end
    end
    
endmodule

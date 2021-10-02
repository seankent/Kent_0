//==============================================
// system
//==============================================
module system
(
    input logic clk,
    input logic rst,
    output logic central_processing_unit_clk,
    output logic central_processing_unit_rst,
    output we_cycle
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
    logic we_cycle;
    
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
        if (rst) we_cycle <= 1'b0;
        else begin
            case (state)
                STATE_4: we_cycle <= 1'b1;
                STATE_5: we_cycle <= 1'b0;
            endcase
        end
    end
    
endmodule

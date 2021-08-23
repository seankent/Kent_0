//==============================================
// seven_segment_display
//==============================================
module seven_segment_display
(
    input logic clk,
    input logic rst,
    input logic [7:0] en,
    input logic [3:0] n_0, [3:0] n_1, [3:0] n_2, [3:0] n_3, [3:0] n_4, [3:0] n_5, [3:0] n_6, [3:0] n_7,
    output logic [7:0] an,
    output logic ca, cb, cc, cd, ce, cf, cg
);
    
    //==============================
    // binary_to_seven_segment_0
    //==============================
    binary_to_seven_segment binary_to_seven_segment_0
    (
        .clk(clk),
        .rst(rst),
        .n(n),
        .ca(ca), .cb(cb), .cc(cc), .cd(cd), .ce(ce), .cf(cf), .cg(cg)
    );
    
    //==============================
    // logic
    //==============================
    logic [3:0] n;
    logic [15:0] count;
    logic [7:0] state;
    
    //==============================
    // always_comb
    //==============================
    always_comb begin
        case (state)
            8'hfe: n = n_0;
            8'hfd: n = n_1;
            8'hfb: n = n_2;
            8'hf7: n = n_3;
            8'hef: n = n_4;
            8'hdf: n = n_5;
            8'hbf: n = n_6;
            8'h7f: n = n_7;
        endcase
    end
    
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        count <= count + 1;
    end
    
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        if (rst) an <= 8'hff;
        else an <= state | ~en;
    end
    
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        if (rst) state <= 8'hfe;
        else begin
            case (count)
                16'h0000: state <= {state[6:0], state[7]};
                default: state <= state;
            endcase  
        end
    end
    
endmodule

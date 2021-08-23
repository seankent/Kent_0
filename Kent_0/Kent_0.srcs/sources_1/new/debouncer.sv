//==============================================
// counter
//==============================================
module debouncer
(
    input logic clk,
    input logic rst,
    input logic in,
    output logic out
);
    
    //==============================
    // parameter
    //==============================
    parameter DEBOUNCE_COUNT = 20'd1_000_000;

    //==============================
    // logic
    //==============================
    logic [19:0] count;
    logic in_prev;

    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        in_prev <= in;
    end
    
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        if (rst) out <= 1'b0;
        else begin
            out <= (count == DEBOUNCE_COUNT) ? in_prev : out;
        end
    end
    
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        if (rst) count <= 20'd0;
        else begin
            if (in == in_prev) begin
                count <= (count == DEBOUNCE_COUNT) ?  DEBOUNCE_COUNT : count + 1;
            end
            else count <= 20'd0;
        end
    end

endmodule


////==============================================
//// timer
////==============================================
//module timer
//(
//    input logic clk,
//    input logic rst,
//    output logic ov
//);

//    //==============================
//    // parameter
//    //==============================
//    parameter COUNT = 16'hffff;
    
//    //==============================
//    // logic
//    //==============================
//    logic [15:0] count;
    
//    //==============================
//    // always_ff
//    //==============================
//    always_ff @(posedge clk) begin
//        ov = (count == COUNT) ? 1'b1 : 1'b0;
//    end
    
//    //==============================
//    // always_ff
//    //==============================
//    always_ff @(posedge clk) begin
//        if (rst) count <= 16'h0000;
//        else count <= (count == COUNT) ? 16'b0000 : count + 1;
//    end

//endmodule

//==============================================
// timer
//==============================================
module timer
(
    input logic clk,
    input logic rst,
    input logic [15:0] N,   // for a period of x clock cycles, set N = x - 1
    output logic ov
);
    
    //==============================
    // logic
    //==============================
    logic [15:0] n;
    
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
        if (rst) n <= 16'h0000;
        else n <= (n == N) ? 16'b0000 : n + 1;
    end

endmodule

////==============================================
//// timer
////==============================================
//module timer
//(
//    input logic clk,
//    input logic rst,
//    input logic en,
//    output logic [31:0] count
//);

//    //==============================
//    // always_ff
//    //==============================
//    always_ff @(posedge clk) begin
//        if (rst) count <= 32'h0;
//        else count <= en ? count + 1 : count;
//    end

//endmodule

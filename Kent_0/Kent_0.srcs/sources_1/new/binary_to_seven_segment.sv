//==============================================
// binary_to_seven_segment
//==============================================
module binary_to_seven_segment
(
    input logic clk,
    input logic rst,
    input logic [3:0] n,
    output logic ca, cb, cc, cd, ce, cf, cg
);
    //==============================
    // always_comb
    //==============================
    //always_ff @(posedge clk) begin
    always_comb begin
        case (n)
            4'h0: {cg, cf, ce, cd, cc, cb, ca} <= ~7'b011_1111;
            4'h1: {cg, cf, ce, cd, cc, cb, ca} <= ~7'b000_0110;
            4'h2: {cg, cf, ce, cd, cc, cb, ca} <= ~7'b101_1011;
            4'h3: {cg, cf, ce, cd, cc, cb, ca} <= ~7'b100_1111;
            4'h4: {cg, cf, ce, cd, cc, cb, ca} <= ~7'b110_0110;
            4'h5: {cg, cf, ce, cd, cc, cb, ca} <= ~7'b110_1101;
            4'h6: {cg, cf, ce, cd, cc, cb, ca} <= ~7'b111_1101;
            4'h7: {cg, cf, ce, cd, cc, cb, ca} <= ~7'b000_0111;
            4'h8: {cg, cf, ce, cd, cc, cb, ca} <= ~7'b111_1111;
            4'h9: {cg, cf, ce, cd, cc, cb, ca} <= ~7'b110_1111;
            4'ha: {cg, cf, ce, cd, cc, cb, ca} <= ~7'b111_0111;
            4'hb: {cg, cf, ce, cd, cc, cb, ca} <= ~7'b111_1100;
            4'hc: {cg, cf, ce, cd, cc, cb, ca} <= ~7'b011_1001;
            4'hd: {cg, cf, ce, cd, cc, cb, ca} <= ~7'b101_1110;
            4'he: {cg, cf, ce, cd, cc, cb, ca} <= ~7'b111_1001;
            4'hf: {cg, cf, ce, cd, cc, cb, ca} <= ~7'b111_0001;
        endcase
    end
endmodule

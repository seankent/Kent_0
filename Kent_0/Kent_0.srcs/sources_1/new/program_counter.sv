//==============================================
// program_counter
//==============================================
module program_counter
(
    input logic clk,
    input logic rst,
    input logic [2:0] ctrl_flow_type,
    input logic eq,
    input logic ne,
    input logic lt,
    input logic le,
    input logic [7:0] imm,
    input logic [7:0] data_0,
    output logic [7:0] pc,
    output logic [7:0] pc_plus_one,
    output logic [7:0] pc_plus_imm
);

    //==============================
    // parameter
    //==============================
    parameter CTRL_FLOW_TYPE__PC_PLUS_ONE = 3'h0;
    parameter CTRL_FLOW_TYPE__RELATIVE_JUMP = 3'h1;
    parameter CTRL_FLOW_TYPE__INDIRECT_JUMP = 3'h2;
    parameter CTRL_FLOW_TYPE__BEQ = 3'h3;
    parameter CTRL_FLOW_TYPE__BNE = 3'h4;
    parameter CTRL_FLOW_TYPE__BLT = 3'h5;
    parameter CTRL_FLOW_TYPE__BLE = 3'h6;
    
    //==============================
    // assign
    //==============================
    assign pc_plus_one = pc + 1;
    assign pc_plus_imm = pc + imm;
    
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        if (rst) pc <= 8'h00;
        else begin
            case (ctrl_flow_type)
                CTRL_FLOW_TYPE__PC_PLUS_ONE: pc <= pc_plus_one;
                CTRL_FLOW_TYPE__RELATIVE_JUMP: pc <= pc_plus_imm;
                CTRL_FLOW_TYPE__INDIRECT_JUMP: pc <= data_0;
                CTRL_FLOW_TYPE__BEQ: pc <= eq ? pc_plus_imm : pc_plus_one;
                CTRL_FLOW_TYPE__BNE: pc <= ne ? pc_plus_imm : pc_plus_one;
                CTRL_FLOW_TYPE__BLT: pc <= lt ? pc_plus_imm : pc_plus_one;
                CTRL_FLOW_TYPE__BLE: pc <= le ? pc_plus_imm : pc_plus_one;
            endcase
        end
    end

endmodule

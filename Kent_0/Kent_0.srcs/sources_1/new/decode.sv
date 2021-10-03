//==============================================
// decode
//==============================================
module decode
(
    input logic clk,
    input logic rst,
    input logic [15:0] ir,
    output logic [2:0] addr_0, 
    output logic [2:0] addr_1, 
    output logic [2:0] addr_2,
    output logic [2:0] func,
    output logic [7:0] imm,
    output logic we,
    output logic [2:0] ctrl_flow_type,
    output logic [1:0] data_2_sel,
    output logic memory_we
);
    
    //==============================
    // parameter
    //==============================
    parameter F0 = 2'b00;
    parameter F1 = 2'b01;
    parameter F2 = 2'b10;
    parameter F3 = 2'b11;
    parameter INSTR_TYPE__FUNC = 3'h0;
    parameter INSTR_TYPE__LOAD = 3'h1;
    parameter INSTR_TYPE__STORE = 3'h2;
    parameter INSTR_TYPE__JUMP = 3'h3;
    parameter INSTR_TYPE__BRANCH = 3'h4;
    parameter CTRL_FLOW_TYPE__PC_PLUS_ONE = 3'h0;
    parameter CTRL_FLOW_TYPE__RELATIVE_JUMP = 3'h1;
    parameter CTRL_FLOW_TYPE__INDIRECT_JUMP = 3'h2;
    parameter CTRL_FLOW_TYPE__BEQ = 3'h3;
    parameter CTRL_FLOW_TYPE__BNE = 3'h4;
    parameter CTRL_FLOW_TYPE__BLT = 3'h5;
    parameter CTRL_FLOW_TYPE__BLE = 3'h6;
    parameter DATA_2_SEL__ALU = 2'h0;
    parameter DATA_2_SEL__IMM = 2'h1;
    parameter DATA_2_SEL__MEM = 2'h2;
    parameter DATA_2_SEL__PC_PLUS_ONE = 2'h3;

    //==============================
    // logic
    //==============================
    logic [1:0] op;
    logic [2:0] op_ext_0;
    logic [2:0] op_ext_1;
    logic [2:0] instr_type;

    //==============================
    // assign
    //==============================
    assign op = ir[1:0];
    assign op_ext_0 = ir[7:5];
    assign op_ext_1 = ir[4:2];
    assign addr_0 = ir[10:8];
    assign addr_1 = ir[7:5];
    assign addr_2 = ir[4:2];
    assign func = ir[13:11];
    assign imm = (op == F3) ? {ir[4], ir[4], ir[4], ir[15:11]} : ir[15:8];
    
    //==============================
    // always_comb
    //==============================
    always_comb begin
        case (op)
            F0: instr_type = INSTR_TYPE__FUNC;
            F1: instr_type = op_ext_0[0] ? INSTR_TYPE__JUMP : INSTR_TYPE__LOAD;
            F2: instr_type = INSTR_TYPE__STORE;
            F3: instr_type = INSTR_TYPE__BRANCH;
        endcase
    end
    
    //==============================
    // always_comb
    //==============================
    always_comb begin
        case (instr_type)
            INSTR_TYPE__FUNC: 
                begin
                    we = 1'b1;
                    data_2_sel = DATA_2_SEL__ALU;
                    ctrl_flow_type = CTRL_FLOW_TYPE__PC_PLUS_ONE;
                    memory_we = 1'b0;
                end
            INSTR_TYPE__LOAD: 
                begin
                    we = 1'b1;
                    data_2_sel = op_ext_0[1] ? DATA_2_SEL__MEM : DATA_2_SEL__IMM;
                    ctrl_flow_type = CTRL_FLOW_TYPE__PC_PLUS_ONE;
                    memory_we = 1'b0;
                end
            INSTR_TYPE__STORE: 
                begin
                    we = 1'b0;
                    data_2_sel = DATA_2_SEL__ALU;
                    ctrl_flow_type = CTRL_FLOW_TYPE__PC_PLUS_ONE;
                    memory_we = 1'b1;
                end
            INSTR_TYPE__JUMP: 
                begin
                    we = 1'b1;
                    data_2_sel = DATA_2_SEL__PC_PLUS_ONE;
                    ctrl_flow_type = op_ext_0[1] ? CTRL_FLOW_TYPE__INDIRECT_JUMP : CTRL_FLOW_TYPE__RELATIVE_JUMP;
                    memory_we = 1'b0;
                end
            INSTR_TYPE__BRANCH: 
                begin
                    we = 1'b0;
                    data_2_sel = DATA_2_SEL__ALU;
                    case (op_ext_1[1:0])
                        2'h0: ctrl_flow_type = CTRL_FLOW_TYPE__BEQ;
                        2'h1: ctrl_flow_type = CTRL_FLOW_TYPE__BNE;
                        2'h2: ctrl_flow_type = CTRL_FLOW_TYPE__BLT;
                        2'h3: ctrl_flow_type = CTRL_FLOW_TYPE__BLE;
                    endcase
                    memory_we = 1'b0;
                end
        endcase
    end

    
    //==============================
    // always_comb
    //==============================

endmodule

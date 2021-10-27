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
    output logic [7:0] pc_plus_imm,
    input [7:0] ie,
    input intr_0,
    input intr_1
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
    parameter CTRL_FLOW_TYPE__RETI = 3'h7;
    
    parameter INTERUPT_0_ADDR = 8'hfe;
    parameter INTERUPT_1_ADDR = 8'hff;
    
    //==============================
    // logic
    //==============================
    logic [7:0] isr;    // interupt status register
    logic [7:0] irr;    // interupt return register
    logic [7:0] pc_no_interupt;
    logic enter_intr_0; 
    logic exit_intr_0;
    logic enter_intr_1; 
    logic exit_intr_1;
    logic busy;
    logic enter;
    logic exit;
    
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
        else if (enter) begin
            case (1'b1)
                enter_intr_0: pc <= INTERUPT_0_ADDR;
                enter_intr_1: pc <= INTERUPT_1_ADDR;
            endcase
        end
        else begin
            case (ctrl_flow_type)
                CTRL_FLOW_TYPE__PC_PLUS_ONE: pc <= pc_plus_one;
                CTRL_FLOW_TYPE__RELATIVE_JUMP: pc <= pc_plus_imm;
                CTRL_FLOW_TYPE__INDIRECT_JUMP: pc <= data_0;
                CTRL_FLOW_TYPE__BEQ: pc <= eq ? pc_plus_imm : pc_plus_one;
                CTRL_FLOW_TYPE__BNE: pc <= ne ? pc_plus_imm : pc_plus_one;
                CTRL_FLOW_TYPE__BLT: pc <= lt ? pc_plus_imm : pc_plus_one;
                CTRL_FLOW_TYPE__BLE: pc <= le ? pc_plus_imm : pc_plus_one;
                CTRL_FLOW_TYPE__RETI: pc <= irr;
            endcase
        end
    end
    
    //==============================
    // always_comb
    //==============================
    always_comb begin
        case (ctrl_flow_type)
            CTRL_FLOW_TYPE__PC_PLUS_ONE: pc_no_interupt <= pc_plus_one;
            CTRL_FLOW_TYPE__RELATIVE_JUMP: pc_no_interupt <= pc_plus_imm;
            CTRL_FLOW_TYPE__INDIRECT_JUMP: pc_no_interupt <= data_0;
            CTRL_FLOW_TYPE__BEQ: pc_no_interupt <= eq ? pc_plus_imm : pc_plus_one;
            CTRL_FLOW_TYPE__BNE: pc_no_interupt <= ne ? pc_plus_imm : pc_plus_one;
            CTRL_FLOW_TYPE__BLT: pc_no_interupt <= lt ? pc_plus_imm : pc_plus_one;
            CTRL_FLOW_TYPE__BLE: pc_no_interupt <= le ? pc_plus_imm : pc_plus_one;
        endcase
    end
    
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        if (rst) isr <= 8'h00;
        else begin
        
            isr[0] <= (intr_0 & ie[0]) ? 1'b1 : (enter_intr_0 ? 1'b0 : isr[0]);
            isr[1] <= (intr_1 & ie[1]) ? 1'b1 : (enter_intr_1 ? 1'b0 : isr[1]);
            isr[4] <= enter_intr_0 ? 1'b1 : (exit_intr_0 ? 1'b0 : isr[4]);
            isr[5] <= enter_intr_1 ? 1'b1 : (exit_intr_1 ? 1'b0 : isr[5]);
        end
    end 
    
    //==============================
    // always_comb
    //==============================
    always_comb begin
        exit_intr_0 = isr[4] & (ctrl_flow_type == CTRL_FLOW_TYPE__RETI);
        exit_intr_1 = isr[5] & (ctrl_flow_type == CTRL_FLOW_TYPE__RETI);
        busy = |isr[7:4];
        exit = |{exit_intr_1, exit_intr_0};
        enter_intr_0 = 1'b0;
        enter_intr_1 = 1'b0;
        case (1'b1)
            isr[0]: enter_intr_0 = ~busy | exit;
            isr[1]: enter_intr_1 = ~busy | exit;
        endcase
        enter = |{enter_intr_1, enter_intr_0};
    end
 
    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        irr <= (enter & ~busy) ? pc_no_interupt : irr;
    end 
    

endmodule

//    //==============================
//    // always_ff
//    //==============================
//    always_ff @(posedge clk) begin
//        if (rst) pc <= 8'h00;
//        else if (enter_intr) pc <= intr_addr;
//        else begin
//            case (ctrl_flow_type)
//                CTRL_FLOW_TYPE__PC_PLUS_ONE: pc <= pc_plus_one;
//                CTRL_FLOW_TYPE__RELATIVE_JUMP: pc <= pc_plus_imm;
//                CTRL_FLOW_TYPE__INDIRECT_JUMP: pc <= data_0;
//                CTRL_FLOW_TYPE__BEQ: pc <= eq ? pc_plus_imm : pc_plus_one;
//                CTRL_FLOW_TYPE__BNE: pc <= ne ? pc_plus_imm : pc_plus_one;
//                CTRL_FLOW_TYPE__BLT: pc <= lt ? pc_plus_imm : pc_plus_one;
//                CTRL_FLOW_TYPE__BLE: pc <= le ? pc_plus_imm : pc_plus_one;
//            endcase
//        end
//    end

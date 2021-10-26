//==============================================
// system
//==============================================
module system
(
    input logic clk,
    input logic ext_rst,
    input logic [7:0] pc,
    input [7:0] data_memory_addr,
    input data_memory_we,
    output [7:0] rom_addr,
    output [7:0] instruction_memory_addr,
    output instruction_memory_we,
    output rst,
    output [7:0] is,
    input [7:0] ie,
    input [7:0] te,
    output timer_0_rst,
    input timer_0_ov,
    output timer_1_rst,
    input timer_1_ov,
    output enter_intr,
    output intr_addr
);

    //==============================
    // parameters
    //==============================
    parameter RESET = 3'h0;
    parameter LOAD_0 = 3'h1;
    parameter LOAD_1 = 3'h2;
    parameter LOAD_2 = 3'h3;
    parameter RUN = 3'h4;
    
    parameter PORT_0_ADDR = 8'hfc;
    parameter PORT_1_ADDR = 8'hfd;
    parameter PORT_2_ADDR = 8'hfe;
    parameter PORT_3_ADDR = 8'hff;
    
   // interupt addresses
    parameter INTR_ADDR_0 = 8'hf8;
    parameter INTR_ADDR_1 = 8'hfa;
    // interupt states
    parameter IDLE = 2'h0;
    parameter INTR_0 = 2'h1;
    parameter INTR_1 = 2'h2;
    
    //==============================
    // logic
    //==============================
    logic [2:0] state;
    logic [7:0] rom_addr;
    logic [7:0] instruction_memory_addr;
    logic instruction_memory_we;
    logic rst;
    logic timer_0_rst;
    logic timer_1_rst;
    logic [7:0] is;
    logic [1:0] intr_state;
    logic [1:0] intr_state_next;
    logic set_intr_0;
    logic set_intr_1;
    logic clear_intr_0;
    logic clear_intr_1;
    logic pending_intr_0;
    logic pending_intr_1;
    logic enter_intr;
    logic exit_intr;
    logic [7:0] intr_addr;

    //==============================
    // always_ff
    //==============================
    always_ff @(posedge clk) begin
        if (ext_rst) state <= RESET;
        else begin
            case (state)
                RESET: state <= LOAD_0;
                LOAD_0: state <= LOAD_1;
                LOAD_1: state <= LOAD_2;
                LOAD_2: state <= (rom_addr == 8'hff) ? RUN : LOAD_0;
                RUN: state <= RUN;
            endcase
        end
    end
    
    //==============================
    // always_ff
    //============================== 
    always_ff @(posedge clk) begin
        case (state)
            RESET: rom_addr <= 0'h00;
            LOAD_2: rom_addr <= rom_addr + 1;
        endcase
    end
    
    //==============================
    // always_comb
    //============================== 
    always_comb begin
        rst = 1'b1;
        case (state)
            RUN: rst = 1'b0;
        endcase
    end

    //==============================
    // always_comb
    //============================== 
    always_comb begin
        instruction_memory_we = 1'b0;
        case (state)
            LOAD_2: instruction_memory_we = 1'b1;
        endcase
    end
    
    //==============================
    // always_comb
    //============================== 
    always_comb begin
        instruction_memory_addr = rom_addr;
        case (state)
            RUN: instruction_memory_addr = pc;
        endcase
    end
    
    //==============================
    // always_comb
    //============================== 
    always_comb begin
        timer_0_rst = rst | ~te[0];
    end
    
    //==============================
    // always_comb
    //============================== 
    always_comb begin
        timer_1_rst = rst | ~te[1];
    end
   
    //==============================
    // always_comb
    //============================== 
    always_comb begin
        set_intr_0 = ie[0] & ie[1] & timer_0_ov;
        set_intr_1 = ie[0] & ie[2] & timer_1_ov;
        clear_intr_0 = (intr_state == INTR_0) & (pc == INTR_ADDR_0 + 1);
        clear_intr_1 = (intr_state == INTR_1) & (pc == INTR_ADDR_1 + 1);  
        pending_intr_0 = set_intr_0 | (is[0] & ~clear_intr_0); 
        pending_intr_1 = set_intr_1 | (is[1] & ~clear_intr_1);
        enter_intr = (intr_state == IDLE | exit_intr) & (pending_intr_0 | pending_intr_1);
        exit_intr = clear_intr_0 | clear_intr_1;
        
        intr_addr = INTR_ADDR_0;
        case (1)
            pending_intr_0: intr_addr = INTR_ADDR_0;
            pending_intr_1: intr_addr = INTR_ADDR_1;
        endcase
        
        intr_state_next = IDLE;
        case (1)
            pending_intr_0: intr_state_next = INTR_0;
            pending_intr_1: intr_state_next = INTR_1;
        endcase
    end
    
    //==============================
    // always_ff
    //============================== 
    always_ff @(posedge clk) begin
        if (rst) is <= 8'h00;
        else begin  
            is[0] <= set_intr_0 ? 1'b1 : clear_intr_0 ? 1'b0 : is[0];
            is[1] <= set_intr_1 ? 1'b1 : clear_intr_1 ? 1'b0 : is[1];
        end
    end
    
    //==============================
    // always_comb
    //============================== 
    always_ff @(posedge clk) begin
        if (rst) intr_state <= IDLE;
        else intr_state <= (enter_intr | exit_intr) ? intr_state_next : intr_state;  
    end
    
    

endmodule

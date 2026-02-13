module bc_reg_file
import bc_pkg::*;
(
  input  logic                       clk_i,
  input  logic                       rstn_i

  input  logic                       branch_instr_i,
  input  logic                       branch_misspredict_i.

  /// ROB PORT ///

  input  logic                       rob_commit_rq_i,
  input  logic [ RF_TAG_WIDTH - 1:0] rob_comitted_str_i,
  input  logic [RF_ADDR_WIDTH - 1:0] rob_commit_addr_i,

  input  logic                       rob_dispatch_rq_i,
  input  logic [ RF_TAG_WIDTH - 1:0] rob_dispatch_str_i,
  input  logic [RF_ADDR_WIDTH - 1:0] rob_dispatch_op1_addr_i,
  input  logic [RF_ADDR_WIDTH - 1:0] rob_dispatch_op2_addr_i,
  input  logic [RF_ADDR_WIDTH - 1:0] rob_dispatch_rd_addr_i,

  /// RS PORT ///

  input  logic                       rs_read_req,
  input  logic [RF_ADDR_WIDTH - 1:0] rs_op1_addr_i,
  input  logic [RF_ADDR_WIDTH - 1:0] rs_op2_addr_i,

  output logic                       rs_op1_valid_o,
  output logic                       rs_op2_valid_o,
  output logic [ RF_TAG_WIDTH - 1:0] rs_op1_tag_o,
  output logic [ RF_TAG_WIDTH - 1:0] rs_op2_tag_o,
  output logic [   DATA_WIDTH - 1:0] rs_op1_data_o,
  output logic [   DATA_WIDTH - 1:0] rs_op2_data_o,
);

////   LOCAL VARIABLES   ////

//// MODULES INITIATIONS ////

bc_reg_storage     bc_reg_storage_inst (
  .clk_i                ( clk_i                ),
  .raddr_port1_i        ( raddr_port1_i        ),
  .rdata_port1_o        ( rdata_port1_o        ),
  .raddr_port2_i        ( raddr_port2_i        ),
  .rdata_port2_o        ( rdata_port2_o        ),
  .waddr_i              ( waddr_i              ),
  .wdata_i              ( wdata_i              ),
  .wvalid_i             ( wvalid_i             )
);

bc_reg_aloc_table  bc_reg_aloc_table_inst (
  .clk_i                ( clk_i                ),
  .rstn_i               ( rstn_i               ),
  .branch_misspredict_i ( branch_misspredict_i ),
  .branch_instr_i       ( branch_instr_i       ),
  .update_tag_i         ( update_tag_i         ),
  .new_tag_addr_i       ( new_tag_addr_i       ),
  .rs_op1_addr_i        ( rs_op1_addr_i        ),
  .rs_op2_addr_i        ( rs_op2_addr_i        ),
  .new_tag_i            ( new_tag_i            ),
  .op1_valid_o          ( op1_valid_o          ),
  .op1_valid_o          ( op2_valid_o          ),
  .op1_tag_o            ( op1_tag_o            ),
  .op2_tag_o            ( op2_tag_o            ),
  .read_addr_i          ( read_addr_i          ),
  .tag_not_empty_o      ( tag_not_empty_o      ),
  .commit_addr_i        ( commit_addr_i        ),
  .rob_str_i            ( rob_str_i            ),
  .commit_req_i         ( rob_commit_req       ),
  .commit_valid_o       ( commit_valid_o       )
);

////     INNER LOGIC     ////

////     OUTPUT PORTS    ////

////  SIMULATION ASSERT  ////


endomodule
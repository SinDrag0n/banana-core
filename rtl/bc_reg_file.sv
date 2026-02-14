module bc_reg_file
import bc_pkg::*;
(
  input  logic                       clk_i,
  input  logic                       rstn_i,

  input  logic                       branch_instr_i,
  input  logic                       branch_misspredict_i,

  /// ROB PORT ///

  input  logic                       rob_commit_rq_i,
  input  logic [ RF_TAG_WIDTH - 1:0] rob_commit_tag_i,
  input  logic [RF_ADDR_WIDTH - 1:0] rob_commit_addr_i,
  input  logic [   DATA_WIDTH - 1:0] rob_commit_data_i,

  input  logic                       rob_dispatch_rq_i,
  input  logic [ RF_TAG_WIDTH - 1:0] rob_dispatch_tag_i,
  input  logic [RF_ADDR_WIDTH - 1:0] rob_dispatch_op1_addr_i,
  input  logic [RF_ADDR_WIDTH - 1:0] rob_dispatch_op2_addr_i,
  input  logic [RF_ADDR_WIDTH - 1:0] rob_dispatch_rd_addr_i,

  /// RS PORT ///

  input  logic                       rs_read_rq_i,
  input  logic [RF_ADDR_WIDTH - 1:0] rs_op1_addr_i,
  input  logic [RF_ADDR_WIDTH - 1:0] rs_op2_addr_i,

  output logic                       rs_op1_valid_o,
  output logic                       rs_op2_valid_o,
  output logic [ RF_TAG_WIDTH - 1:0] rs_op1_tag_o,
  output logic [ RF_TAG_WIDTH - 1:0] rs_op2_tag_o,
  output logic [   DATA_WIDTH - 1:0] rs_op1_data_o,
  output logic [   DATA_WIDTH - 1:0] rs_op2_data_o
);

////   LOCAL VARIABLES   ////

// Commit logic
logic commit_allow;

// Register storage read ports

logic [RF_ADDR_WIDTH - 1:0] raddr_port1;
logic [RF_ADDR_WIDTH - 1:0] raddr_port2;

logic [   DATA_WIDTH - 1:0] rdata_port1;
logic [   DATA_WIDTH - 1:0] rdata_port2;

logic [ RF_TAG_WIDTH - 1:0] rtag_port1;
logic [ RF_TAG_WIDTH - 1:0] rtag_port2;

logic                       rvalid_port1;
logic                       rvalid_port2;

//// MODULES INITIATIONS ////

bc_reg_storage     bc_reg_storage_inst (
  .clk_i                  ( clk_i                  ),
  .raddr_port1_i          ( raddr_port1            ),
  .rdata_port1_o          ( rdata_port1            ),
  .raddr_port2_i          ( raddr_port2            ),
  .rdata_port2_o          ( rdata_port2            ),
  .waddr_i                ( rob_commit_addr_i      ),
  .wdata_i                ( rob_commit_data_i      ),
  .wvalid_i               ( commit_allow           )
);

bc_reg_rename_table  bc_reg_rename_table_inst (
  .clk_i                  ( clk_i                  ),
  .rstn_i                 ( rstn_i                 ),
  .branch_misspredict_i   ( branch_misspredict_i   ),
  .branch_instr_i         ( branch_instr_i         ),
  .rob_dispatch_rq_i      ( rob_dispatch_rq_i      ),
  .rob_dispatch_tag_i     ( rob_dispatch_tag_i     ),
  .rob_dispatch_rd_addr_i ( rob_dispatch_rd_addr_i ),
  .rob_commit_addr_i      ( rob_commit_addr_i      ),
  .rob_commit_tag_i       ( rob_commit_tag_i       ),
  .rob_commit_rq_i        ( rob_commit_rq_i        ),
  .commit_allow_o         ( commit_allow           ),
  .rs_read_rq_i           ( rs_read_rq_i           ),
  .op1_addr_i             ( raddr_port1            ),
  .op2_addr_i             ( raddr_port2            ),
  .op1_valid_o            ( rvalid_port1           ),
  .op2_valid_o            ( rvalid_port2           ),
  .op1_tag_o              ( rtag_port1             ),
  .op2_tag_o              ( rtag_port2             )
);

////     INNER LOGIC     ////

always_comb begin
  if ( rob_dispatch_rq_i ) begin
    raddr_port1    = rob_dispatch_op1_addr_i;
    raddr_port2    = rob_dispatch_op2_addr_i;
  end
  else if ( rs_read_rq_i ) begin
    raddr_port1    = rs_op1_addr_i;
    raddr_port2    = rs_op2_addr_i;
  end
  else begin
    raddr_port1    = 'x;
    raddr_port2    = 'x;
  end
end

////     OUTPUT PORTS    ////

assign rs_op1_data_o  = rdata_port1;
assign rs_op2_data_o  = rdata_port2;

assign rs_op1_valid_o = rvalid_port1;
assign rs_op2_valid_o = rvalid_port2;

assign rs_op1_tag_o   = rtag_port1;
assign rs_op2_tag_o   = rtag_port2;

////  SIMULATION ASSERT  ////


endmodule
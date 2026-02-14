module bc_reg_rename_table
import bc_pkg::*;
(
  input  logic                       clk_i,
  input  logic                       rstn_i,

  input  logic                       branch_misspredict_i,
  input  logic                       branch_instr_i,

  input  logic                       rob_dispatch_rq_i,
  input  logic [ RF_TAG_WIDTH - 1:0] rob_dispatch_tag_i,
  input  logic [RF_ADDR_WIDTH - 1:0] rob_dispatch_rd_addr_i,

  input  logic [RF_ADDR_WIDTH - 1:0] rob_commit_addr_i,
  input  logic                       rob_commit_tag_i,
  input  logic                       rob_commit_rq_i,
  output logic                       commit_allow_o,

  input  logic                       rs_read_rq_i,

  input  logic [RF_ADDR_WIDTH - 1:0] op1_addr_i,
  input  logic [RF_ADDR_WIDTH - 1:0] op2_addr_i,

  output logic [ RF_TAG_WIDTH - 1:0] op1_valid_o,
  output logic [ RF_TAG_WIDTH - 1:0] op2_valid_o,

  output logic [ RF_TAG_WIDTH - 1:0] op1_tag_o,
  output logic [ RF_TAG_WIDTH - 1:0] op2_tag_o
);

////   LOCAL VARIABLES   ////

logic [RF_TAG_WIDTH - 1:0] tag         [RF_REGS_NUM - 1:0]; // consider using struct with valid and data
logic [RF_TAG_WIDTH - 1:0] tag_archive [RF_REGS_NUM - 1:0];


////     INNER LOGIC     ////

always_ff @( posedge clk_i ) begin
  if ( ~rstn_i ) begin
    tag <= {default: '0};
  end
  else begin
    if ( rob_dispatch_rq_i )
      tag[rob_dispatch_rd_addr_i] <= rob_dispatch_tag_i;
    if ( rob_commit_rq_i ) begin
      if ( rob_commit_tag_i == tag[rob_commit_addr_i] )
        tag[rob_commit_addr_i] <= RF_TAG_WIDTH'( '0 );
    end
    if ( branch_misspredict_i )
      tag <= tag_archive;
  end
end

always_ff @( posedge clk_i ) begin
  if ( ~rstn_i ) begin
    tag_archive <= {default: '0};
  end
  else begin
    if ( branch_instr_i ) begin
      tag_archive <= tag;
    end
  end
end

////     OUTPUT PORTS    ////

assign op1_valid_o = ( tag[op1_addr_i] != 0 ) & ( rob_dispatch_rq_i | rs_read_rq_i );
assign op2_valid_o = ( tag[op2_addr_i] != 0 ) & ( rob_dispatch_rq_i | rs_read_rq_i );

assign op1_tag_o = tag[op1_addr_i] & op1_valid_o;
assign op2_tag_o = tag[op2_addr_i] & op2_valid_o;

assign commit_allow_o = rob_commit_rq_i & ( tag[rob_commit_addr_i] == rob_commit_tag_i );

////  SIMULATION ASSERT  ////

endmodule
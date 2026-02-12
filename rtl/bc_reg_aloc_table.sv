module bc_reg_aloc_table
import bc_pkg::*;
(
  input  logic                      clk_i,
  input  logic                      rstn_i,

  // input  logic                      flush_i,
  input  logic                      branch_misspredict_i,
  input  logic                      branch_instr_i,

  /// UPDATE TAG WITH NEW INSTRUCTION ///
  input  logic                       update_tag_i,
  input  logic [RF_ADDR_WIDTH - 1:0] new_tag_addr_i,
  input  logic [RF_ADDR_WIDTH - 1:0] rs_op1_addr_i,
  input  logic [RF_ADDR_WIDTH - 1:0] rs_op2_addr_i,
  input  logic [ RF_TAG_WIDTH - 1:0] new_tag_i,

  output logic [ RF_TAG_WIDTH - 1:0] op1_valid_o,
  output logic [ RF_TAG_WIDTH - 1:0] op2_valid_o,

  /// GET TAG FOR RS ///
  output logic [ RF_TAG_WIDTH - 1:0] op1_tag_o,
  output logic [ RF_TAG_WIDTH - 1:0] op2_tag_o,

  /// CHECK IF IT IS ACTUAL DATA IN RF ///
  input  logic [RF_ADDR_WIDTH - 1:0] read_addr_i,
  output logic                       tag_not_empty_o

  /// CLEAR TAG AFTER COMMIT ///
  input  logic [RF_ADDR_WIDTH - 1:0] commit_addr_i,
  input  logic                       rob_str_i,
  input  logic                       commit_req_i,
  output logic                       commit_valid_o
);

////   LOCAL VARIABLES   ////

logic [RF_TAG_WIDTH - 1:0] tag         [RF_REGS_NUM - 1:0];
logic [RF_TAG_WIDTH - 1:0] tag_archive [RF_REGS_NUM - 1:0];


////     INNER LOGIC     ////

always_ff @( posedge clk_i ) begin
  if ( ~rstn_i ) begin
    for ( int i = 0; i < RF_REGS_NUM; i++ ) begin
      tag[i] <= RF_TAG_WIDTH'( '0 );
    end
  end
  else begin
    if ( update_tag_i )
      tag[new_tag_addr_i] <= new_tag_i;
    if ( commit_req_i ) begin
      if ( rob_str_i == tag[commit_addr_i] )
        tag[commit_addr_i] <= RF_TAG_WIDTH'( '0 );
    end
    if ( branch_misspredict_i )
      tag <= tag_archive;
  end
end

always_ff @( posedge clk_i ) begin
  if ( ~rstn_i ) begin
    for ( int i = 0; i < RF_REGS_NUM; i++ ) begin
      tag_archive[i] <= RF_TAG_WIDTH'( '0 );
    end
  end
  else begin
    if ( branch_instr_i ) begin
      for ( int i = 0; i < RF_REGS_NUM; i++ ) begin
        tag_archive[i] <= tag[i];
      end
    end
  end
end

// always_comb begin
//   if ( update_tag_i ) begin
//     if ( tag[rs_op1_addr_i] != 0 ) op1_valid_o = 1'b0;
//     else                           op1_valid_o = 1'b1;
//     if ( tag[rs_op1_addr_i] != 0 ) op2_valid_o = 1'b0;
//     else                           op2_valid_o = 1'b1;
//   end
//   else begin
//     op1_valid_o = 1'b0;
//     op2_valid_o = 1'b0;
//   end
// end

////     OUTPUT PORTS    ////

assign op1_valid_o = ( tag[rs_op1_addr_i] != 0 ) & update_tag_i;
assign op2_valid_o = ( tag[rs_op2_addr_i] != 0 ) & update_tag_i;

assign op1_tag_o = tag[rs_op1_addr_i] & op1_valid_o;
assign op2_tag_o = tag[rs_op2_addr_i] & op2_valid_o;

assign commit_valid_o = commit_req_i & (tag)

// Future optimisation - if opN_tag_o is empty => we can send data to RS same moment so we dont need to wait it in RS

////  SIMULATION ASSERT  ////

endmodule
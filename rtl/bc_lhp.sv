module bc_lhp
import bc_pkg::*;
(
  input  logic                    clk_i,
  input  logic                    rstn_i,

  input  logic [ADDR_WIDTH - 1:0] instr_pc_i,
  input  logic                    predict_req_i,
  input  logic                    branch_prediction_o,

  input  logic [ADDR_WIDTH - 1:0] update_req_i,
  input  logic                    update_pc_i,
  input  logic                    branch_res
);

////   LOCAL VARIABLES   ////

logic [BP_LHT_PATTERN_WIDTH - 1:0] lht [BP_LHP_ENTRIES - 1:0];
logic [   BP_LHT_ADDR_WIDTH - 1:0] lht_prd_index;
logic [   BP_LHT_ADDR_WIDTH - 1:0] lht_upd_index;

logic [1:0] pht [BP_PHT_ENTRIES - 1:0];
logic [   BP_PHT_ADDR_WIDTH - 1:0] pht_prd_index;
logic [   BP_PHT_ADDR_WIDTH - 1:0] pht_upd_index;


////     INNER LOGIC     ////

assign lht_prd_index = instr_pc_i [2 + BP_LHT_ADDR_WIDTH - 1:2];
assign lht_upd_index = update_pc_i[2 + BP_LHT_ADDR_WIDTH - 1:2];

always_ff @( posedge clk_i ) begin
  if ( ~rstn_i ) begin
    lht <= '{default: '0};
  end
  else begin
    if ( update_req_i ) lht[lht_upd_index] <= {lht[lht_upd_index][BP_LHT_PATTERN_WIDTH - 2:0], branch_res};
  end
end

assign pht_prd_index = pht[lht_prd_index];
assign pht_upd_index = pht[lht_upd_index];

always_ff @( posedge clk_i ) begin
  if ( ~rstn_i ) begin
    pht <= '{default '0};
  end
  else begin
    if ( update_req_i ) begin
      if ( branch_res & pht[pht_upd_index] != 2'b11 )
        pht[pht_upd_index] <= pht[pht_upd_index] + 1;
      if ( ~branch_res & pht[pht_upd_index] != 2'b00 )
        pht[pht_upd_index] <= pht[pht_upd_index] - 1;
    end
  end
end

////    OUTPUT PORTS     ////

assign branch_prediction_o = ( predict_req_i ) ? ( pht[pht_prd_index][1] ) : ( 0 );

////  SIMULATION ASSERT  ////


endmodule
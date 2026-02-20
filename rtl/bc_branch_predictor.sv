module bc_branch_predictor
import bc_pkg::*;
(
  input  logic                    clk_i,
  input  logic                    rstn_i,
  input  logic                    flush_i,

  input  logic [ADDR_WIDTH - 1:0] instr_pc_i,
  input  logic                    predict_req_i,
  input  logic                    branch_prediction_o,

  input  logic [ADDR_WIDTH - 1:0] update_req_i,
  input  logic                    update_pc_i,
  input  logic                    branch_res
);

////   LOCAL VARIABLES   ////

logic lhp_predict;
logic ghp_predict;

logic [1:0] selector;

//// MODULES INITIATIONS ////

bc_lhp  bc_lhp_inst (
  .clk_i                ( clk_i               ),
  .rstn_i               ( rstn_i              ),
  .instr_pc_i           ( instr_pc_i          ),
  .predict_req_i        ( predict_req_i       ),
  .branch_prediction_o  ( branch_prediction_o ),
  .update_req_i         ( update_req_i        ),
  .update_pc_i          ( update_pc_i         ),
  .branch_res           ( branch_res          )
);

bc_ghp  bc_ghp_inst (
  .clk_i                ( clk_i               ),
  .rstn_i               ( rstn_i              ),
  .instr_pc_i           ( instr_pc_i          ),
  .predict_req_i        ( predict_req_i       ),
  .branch_prediction_o  ( branch_prediction_o ),
  .update_req_i         ( update_req_i        ),
  .update_pc_i          ( update_pc_i         ),
  .branch_res           ( branch_res          )
);

fifo fifo_inst(
  // NEED IMPLEMENTED FIFO
  // .data_o    ( prediction )


);

fifo_simple # (
  .FIFO_DATA_WIDTH  ( FIFO_DATA_WIDTH ),
  .WORD_FIFO_DEPTH  ( WORD_FIFO_DEPTH ),
  .EGRESS           ( 1'b0            )
)
fifo_simple_inst (
  .clk_i    (clk_i),
  .rstn_i   (rstn_i),
  .flush_i  (flush_i),
  .data_i   (data_i),
  .push_i   (push_i),
  .pop_i    (pop_i),
  .data_o   (data_o),
  .full_o   (full_o),
  .empty_o  (empty_o)
);


////     INNER LOGIC     ////

always_ff @( posedge clk_i or negedge rstn_i ) begin
  if ( ~rstn_i ) begin
    selector <= 2'b0;
  end
  else begin
    if ( update_req_i ) begin
      if ( branch_res & pht[pht_upd_index] != 2'b11 )
        selector <= selector + 1;
      if ( ~branch_res & pht[pht_upd_index] != 2'b00 )
        selector <= selector - 1;
    end
  end
end

////    OUTPUT PORTS     ////

assign selector[1] ? lhp_predict : ghp_predict;

////  SIMULATION ASSERT  ////


endmodule
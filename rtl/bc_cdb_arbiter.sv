module bc_sdb_arbiter
import bc_pkg::*;
(
  input  logic [CDB_USERS - 1:0] req_i,
  output logic [CDB_USERS - 1:0] grant_o
);

logic [CDB_USERS - 1:0] higher_pri_reqs;

assign higher_pri_reqs[0] = 1'b0;
assign higher_pri_reqs[CDB_USERS-1:1] = higher_pri_reqs[CDB_USERS-2:0] | req_i[CDB_USERS-2:0];
assign grant_o[CDB_USERS-1:0] = req_i[CDB_USERS-1:0] & ~higher_pri_reqs[CDB_USERS-1:0];


endmodule
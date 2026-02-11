module bc_sdb
import bc_pkg::*;
(
  input  logic clk_i,
  input  logic rstn_i,

  output  rs_cdb_port_t         rs_ports [RS_NUM - 1:0],

  input   func_block_cdb_port_t fb_ports [CDB_USERS - 1:0],

  output  rob_cdb_port_t        rob_port
);

////   LOCAL VARIABLES   ////

logic [   DATA_WIDTH - 1:0] data_bus;
logic [RF_ADDR_WIDTH - 1:0] addr_bus;

logic [CDB_USERS - 1:0] reqs;
logic [CDB_USERS - 1:0] grants;

//// MODULES INITIATIONS ////

bc_sdb_arbiter bus_arbiter (
  .req_i    (  reqs  ),
  .grant_o  ( grants )
);

////     INNER LOGIC     ////


for (genvar i = 0; i < RS_NUM; i++) begin
  assign reqs = fb_ports.cdb_valid;
end

always_comb begin : bus_mux
  case( grants )
  CDB_USERS'('b01): begin
    data_bus = fb_ports[0].func_block_wr_data;
    addr_bus = fb_ports[0].func_block_wr_addr;
  end // func_block1 broadcast
  CDB_USERS'('b10): begin
    data_bus = fb_ports[1].func_block_wr_data;
    addr_bus = fb_ports[1].func_block_wr_addr;
  end // func_block2 broadcast
  default: begin
    data_bus = 'x;
    addr_bus = 'x;
  end
  endcase
end

////     OUTPUT PORTS    ////
for (genvar i = 0; i < RS_NUM; i++) begin
  assign rs_ports[i].rs_rd_addr = addr_bus;
  assign rs_ports[i].rs_rd_data = data_bus;
  assign rs_ports[i].cdb_valid  = |grants;
end

assign rob_port.rob_rd_addr = addr_bus;
assign rob_port.rob_rd_data = data_bus;
assign rob_port.cdb_valid  = |grants;


endmodule
module bc_reg_storage
import bc_pkg::*;
(
  input logic                        clk_i,

  input  logic [RF_ADDR_WIDTH - 1:0] raddr_port1_i,
  output logic [   DATA_WIDTH - 1:0] rdata_port1_o,

  input  logic [RF_ADDR_WIDTH - 1:0] raddr_port2_i,
  output logic [   DATA_WIDTH - 1:0] rdata_port2_o,

  input  logic [RF_ADDR_WIDTH - 1:0] waddr_i,
  input  logic [   DATA_WIDTH - 1:0] wdata_i,
  input  logic                       wvalid_i
);


////   LOCAL VARIABLES   ////

logic [DATA_WIDTH - 1:0] reg_storage [RF_REGS_NUM - 1:0];

////     INNER LOGIC     ////

always_ff @( posedge clk_i ) if ( wvalid_i ) reg_storage[waddr_i] <= wdata_i;

////     OUTPUT PORTS    ////

assign rdata_port1_o = reg_storage[raddr_port1_i];
assign rdata_port2_o = reg_storage[raddr_port2_i];

endmodule

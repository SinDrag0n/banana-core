package bc_pkg;

parameter int unsigned DATA_WIDTH        = 32;
parameter int unsigned INSTR_WIDTH       = 32;
parameter int unsigned ADDR_WIDTH        = 32;

parameter int unsigned ROB_ENTRIES       = 8;

parameter int unsigned RF_REGS_NUM       = 32;
parameter int unsigned RF_ADDR_WIDTH     = $clog2( RF_REGS_NUM );
parameter int unsigned RF_TAG_WIDTH      = $clog2( ROB_ENTRIES );

parameter int unsigned CDB_USERS         = 2;

parameter int unsigned RS_NUM            = 2;

parameter int unsigned BP_LHT_ENTRIES       = 1024;
parameter int unsigned BP_LHT_ADDR_WIDTH    = $clog2(BP_LHP_ENTRIES);
parameter int unsigned BP_LHT_PATTERN_WIDTH = 10;

parameter int unsigned BP_PHT_ENTRIES       = 1 << BP_LHP_PATTERN_WIDTH;
parameter int unsigned BP_PHT_ADDR_WIDTH    = $clog2(BP_LHP_ENTRIES);

parameter int unsigned BP_GHT_ENTRIES       = BP_LHT_ADDR_WIDTH;


typedef struct packed {
  logic [RF_ADDR_WIDTH - 1:0] rs_rd_addr;
  logic [   DATA_WIDTH - 1:0] rs_rd_data;
  logic                       cdb_valid;
} rs_cdb_port_t;

typedef struct packed {
  logic [RF_ADDR_WIDTH - 1:0] rob_rd_addr;
  logic [   DATA_WIDTH - 1:0] rob_rd_data;
  logic                       cdb_valid;
} rob_cdb_port_t;

typedef struct packed {
  logic [RF_ADDR_WIDTH - 1:0] func_block_wr_addr;
  logic [   DATA_WIDTH - 1:0] func_block_wr_data;
  logic                       cdb_valid;
} func_block_cdb_port_t;


endpackage
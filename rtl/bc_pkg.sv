package bc_pkg;

parameter int unsigned DATA_WIDTH    = 32;
parameter int unsigned INSTR_WIDTH   = 32;

parameter int unsigned RF_REGS_NUM   = 32;
parameter int unsigned RF_ADDR_WIDTH = 32;

parameter int unsigned CDB_USERS     = 2;

parameter int unsigned RS_NUM        = 2;

parameter int unsigned RF_TAG_WIDTH     = $clog2( RS_NUM + 1 );



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
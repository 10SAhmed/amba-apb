///////////////////////////////////////////////////////////////////////////////
//
// Filename       : amba_apb.sv
// Author         : Saad Ahmed
// Creation Date  : 16-Mar-2025
// ----------------------------------------------------------------------------
//
// DESCRIPTION
// ===========
//
// It is a design of AMBA APB 3 Protocol slave module
//
///////////////////////////////////////////////////////////////////////////////

module amba_apb #(
  parameter ADDR  = 32    ,
  parameter DATA  = 32    ,
  parameter STRB  = DATA/8,
  parameter DEPTH = 1024
) (
  input  logic            p_clk   , // Clock
  input  logic            p_rst   , // Active high sync reset
  input  logic            p_sel_1 , // select line for slave
  input  logic            p_ena   , // enables the transfer
  input  logic            p_write , // indicates write operation when HIGH and read opeartaion when LOW
  input  logic [ADDR-1:0] p_addr  , // address for read/write
  input  logic [DATA-1:0] p_wdata , // data to write
  input  logic [STRB-1:0] p_strb  , // strobe
  output                  p_ready , // slave is ready
  output                  p_slverr, // slave error response
  output logic [DATA-1:0] p_rdata , // data to read by master
);

  // memory declaration
  logic [DATA-1:0] mem[DEPTH];

endmodule : amba_apb
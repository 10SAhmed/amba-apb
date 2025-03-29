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
  output logic            p_ready , // slave is ready
  output logic            p_slverr, // slave error response
  output logic [DATA-1:0] p_rdata   // data to read by master
);

  // memory declaration
  logic [DATA-1:0] mem[DEPTH];

  always_ff @(posedge p_clk) begin
    if(p_rst) begin
      p_slverr <= 1'b0;
      p_ready  <= 1'b0;
    end else if (p_sel_1) begin
      p_ready <= 1'b1;   // can be delayed but for now it won't
    end
  end

  always_comb begin
    p_rdata  = (p_ready & !p_write) ? mem[p_addr] : 'd0;
    p_slverr = (p_ready & !p_write) ?
      (
        (|p_strb) ? 1'b1 : 1'b0
      ) : 1'b0;
  end

  always_comb begin
    if (p_ready & p_write) begin
      case (p_strb)
        'd15    : mem[p_addr] = p_wdata;
        'd14    : mem[p_addr] = {p_wdata[31:08], 8'h00};
        'd13    : mem[p_addr] = {p_wdata[31:16], 8'h00, p_wdata[07:00]};
        'd12    : mem[p_addr] = {p_wdata[31:16], 16'h00_00};
        'd11    : mem[p_addr] = {p_wdata[31:24], 8'h00, p_wdata[15:00]};
        'd10    : mem[p_addr] = {p_wdata[31:24], 8'h00, p_wdata[15:08], 8'h00};
        'd09    : mem[p_addr] = {p_wdata[31:24], 16'h00_00, p_wdata[07:00]};
        'd08    : mem[p_addr] = {p_wdata[31:24], 24'h00_00_00};
        'd07    : mem[p_addr] = {8'h00, p_wdata[23:00]};
        'd06    : mem[p_addr] = {8'h00, p_wdata[23:08], 8'h00};
        'd05    : mem[p_addr] = {8'h00, p_wdata[23:16], 8'h00, p_wdata[07:00]};
        'd04    : mem[p_addr] = {8'h00, p_wdata[23:16], 16'h00_00};
        'd03    : mem[p_addr] = {16'h00_00, p_wdata[15:00]};
        'd02    : mem[p_addr] = {16'h00_00, p_wdata[15:08], 8'h00};
        'd01    : mem[p_addr] = {24'h00_00_00, p_wdata[07:00]};
        default : mem[p_addr] = 32'h00_00_00_00;
      endcase
    end
  end
endmodule : amba_apb
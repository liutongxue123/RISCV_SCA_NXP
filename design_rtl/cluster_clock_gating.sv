module cluster_clock_gating
(
    input  logic clk_i,
    input  logic en_i,
    input  logic test_en_i,
    output logic clk_o
  );

  //----------------------------------------------------------------------------
  // Signal declarations
  //----------------------------------------------------------------------------

  // Clock gating terms
  wire   clk_en;
  reg    clk_en_latch;
  wire   clk_gated;

  // Optimization terms
  wire   opt_clk_gated;
  wire   opt_mst_clk_en;
  wire   opt_mst_disable;
  wire   opt_clk;


  //----------------------------------------------------------------------------
  // Clock gate removal
  //
  //   Do not change this section
  //----------------------------------------------------------------------------

  assign opt_clk_gated   = clk_gated;
  assign opt_mst_clk_en  = en_i;
  assign opt_mst_disable = test_en_i;
  assign opt_clk         = clk_i;


`ifdef CMOS090_LP9TM1_CORE_H
  sgclkn_seq_hvt_8 sgclkn_seq_hvt_8 (
          .gckb (clk_gated),
          .ckb  (opt_clk),
          .g    (opt_mst_clk_en),
          .se   (opt_mst_disable)
          );
`else // CMOS090_LP9TM1_CORE_H
  assign clk_en = opt_mst_clk_en | opt_mst_disable;

  always @(opt_clk or clk_en)
    if (opt_clk == 1'b0)
      clk_en_latch <= clk_en;

  assign clk_gated = opt_clk & clk_en_latch;

`endif // CMOS090_LP9TM1_CORE_H

  //----------------------------------------------------------------------------
  // Output assignments
  //----------------------------------------------------------------------------

  assign clk_o = opt_clk_gated;


endmodule

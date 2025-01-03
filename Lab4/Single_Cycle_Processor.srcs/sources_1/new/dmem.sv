`timescale 1ns / 1ps

module dmem (input  logic        clk, we,
             input  logic[31:0]  a, wd,
             output logic[31:0]  rd);

   logic  [31:0] RAM[63:0];
   
   // initialize ram with zeros
   initial begin
      for (int i = 0; i < 64; i++) begin
         RAM[i] = 32'h0;
      end
   end
  
   assign rd = RAM[a[31:2]];    // word-aligned  read (for lw)

   always_ff @(posedge clk)
     if (we)
       RAM[a[31:2]] <= wd;      // word-aligned write (for sw)

endmodule


`timescale 1ns / 1ps
module datapath (input  logic clk, reset, memtoreg, pcsrc, alusrc, regdst,
                 input  logic regwrite, jump, 
		         input  logic[2:0]  alucontrol, 
                 output logic zero, 
		         output logic[31:0] pc, 
	             input  logic[31:0] instr,
                 output logic[31:0] aluout, writedata, 
	             input  logic[31:0] readdata,
	             input logic XnorFlag, BconFlag
	             );

  logic [4:0]  writereg;
  logic [31:0] pcnext, pcnextbr, pcplus4, pcbranch;
  logic [31:0] signimm, signimmsh, srca, srcb, result;
  
  logic [31:0] srca_output_of_regFile, result_before_mux; 
  logic [31:0] added4, lasttwobit;
  logic nZero, aluzero;
  logic [31:0] zeroExtended, xnorOutput;

  
 
  // next PC logic
  flopr #(32) pcreg(clk, reset, pcnext, pc);
  adder       pcadd1(pc, 32'b100, pcplus4);
  sl2         immsh(signimm, signimmsh);
  adder       pcadd2(pcplus4, signimmsh, pcbranch);
  mux2 #(32)  pcbrmux(pcplus4, pcbranch, pcsrc,
                      pcnextbr);
  mux2 #(32)  pcmux(pcnextbr, {pcplus4[31:28], 
                    instr[25:0], 2'b00}, jump, pcnext);

// register file logic
   regfile     rf (clk, regwrite, instr[25:21], instr[20:16], writereg,
                   result, srca_output_of_regFile, writedata);

   mux2 #(5)    wrmux (instr[20:16], instr[15:11], regdst, writereg);
   mux2 #(32)  resmux (aluout, readdata, memtoreg, result_before_mux);
   signext         se (instr[15:0], signimm);

  // ALU logic
   mux2 #(32)  srcbmux (writedata, signimm, alusrc, srcb);
   alu         alu (srca, srcb, alucontrol, aluout, aluzero);
   
   // xnori logic
   zeroext zeroext1(instr[15:0], zeroExtended);
   xnor_gate xnor_gate1(srca_output_of_regFile, zeroExtended, xnorOutput);
   mux2 #(32) xnorMux(result_before_mux, xnorOutput, XnorFlag, result);
   
   // bcon logic

   adder add4 (srca_output_of_regFile, 32'd4, added4);
   mux2 #(32)  bconmux (srca_output_of_regFile, added4, BconFlag, srca);
   
   assign lasttwobit = ~(writedata[1] | writedata[0]); // nor last two bits
   
   assign nZero = lasttwobit & aluzero;
   mux2 #(1)  zeromux (aluzero, nZero, BconFlag, zero);   
   
   
endmodule

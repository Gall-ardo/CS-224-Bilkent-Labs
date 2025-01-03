module controller(input  logic[5:0] op, funct,
                  input  logic     zero,
                  output logic     memtoreg, memwrite,
                  output logic     pcsrc,
                  output logic     alusrc,
                  output logic     regdst, regwrite,
                  output logic     jump,
                  output logic[2:0] alucontrol,
                  output logic	   XnorFlag,
		          output logic	   BconFlag
		          );

   logic [1:0] aluop;
   logic       branch;

   maindec md (op, memtoreg, memwrite, branch, alusrc, regdst, regwrite, 
		 jump, aluop, XnorFlag, BconFlag);

   aludec  ad (funct, aluop, alucontrol);

   assign pcsrc = branch & zero;

endmodule
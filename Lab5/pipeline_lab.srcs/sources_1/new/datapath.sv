`timescale 1ns / 1ps

module datapath (input  logic clk, reset,
                input logic RegWriteD, MemtoRegD, MemWriteD,
                input  logic[2:0]  ALUControlD, 
                input logic ALUSrcD, RegDstD, BranchD, jump,	         
                input logic stallF, stallD, ForwardAD, ForwardBD, FlushE,   
                input logic [1:0] ForwardAE, ForwardBE,
                
                output logic [4:0] RsD, RtD, RsE, RtE,
                output logic [4:0] WriteRegE, WriteRegM, WriteRegW, 
                output logic [5:0] opcode, func,
                output logic RegWriteW, RegWriteM, RegWriteE, MemtoRegE, MemtoRegM,

                output logic MemWriteE,                 
                output logic[31:0] ALUOutE, WriteDataE, pc, PC_prime,
                output logic [4:0] writereg
                ); 


	logic EqualD, MemWriteM, ftodclear;
	logic PcSrcD, MemtoRegW;										
    logic [31:0] PC, PCF, instrF, instrD, PcSrcA, PcSrcB, PcPlus4F, PcPlus4D, EqualD1, EqualD2;
    logic [31:0] PcBranchD, ALUOutW, ReadDataW, ResultW, RD1, RD2;
    logic [4:0] RdD;

    logic [31:0] PCbranch, SignImmD, SignImmShifted, SrcAE, SrcBE, SrcBEwImm, ALUOutM, WriteDataM, ReadDataM;
    
    logic [2:0] ALUControlE;
    logic ALUSrcE, RegDstE;
    logic [31:0] Read1E, Read2E;
    logic [4:0] RdE;
    logic [31:0] SignImmE;
	
	
	mux2 #(32) m21 (ALUOutW, ReadDataW, MemtoRegW, ResultW);
	
	PipeWtoF pWtoF(PC, ~stallF, clk, reset, PCF);						

    assign pc = PCF;
    assign PC_prime = PC;

    assign PcPlus4F = PCF + 4;                                   
  	mux2 #(32) m22(PcPlus4F, PcBranchD, PcSrcD, PCbranch); 
    mux2 #(32) m23(PCbranch, { PcPlus4D[31:28], instrD[25:0], 2'b00}, jump, PC);


	imem im1(PCF[7:2], instrF);	

    assign ftodclear = PcSrcD | jump;

	PipeFtoD pFtoD(instrF, PcPlus4F, ~stallD, clk, ftodclear, reset, instrD, PcPlus4D); 

	regfile rf(clk, reset, RegWriteW, instrD[25:21], instrD[20:16],
	            WriteRegW, ResultW, RD1, RD2);				

    signext immsignext (instrD[15:0], SignImmD);
    sl2 shiftimm (SignImmD, SignImmShifted);
    adder branchadder (SignImmShifted, PcPlus4D, PcBranchD);

    mux2 #(32) m24 (RD1, ALUOutM, ForwardAD, EqualD1);
    mux2 #(32) m25 (RD2, ALUOutM, ForwardBD, EqualD2);
    
    
    assign EqualD = EqualD1 == EqualD2;
    assign PcSrcD = BranchD && EqualD;

    assign opcode = instrD[31:26];
    assign func = instrD[5:0];

    assign RsD = instrD[25:21];
    assign RtD = instrD[20:16];
    assign RdD = instrD[15:11];

    assign writereg = RtE;

    mux2 #(5) m26 (RtE, RdE, RegDstE, WriteRegE);
     
    mux4 #(32) m41 (Read1E, ResultW, ALUOutM, 0, ForwardAE, SrcAE);
    mux4 #(32) m42 (Read2E, ResultW, ALUOutM, 0, ForwardBE, SrcBE);

    mux2 #(32) m27 (SrcBE, SignImmE, ALUSrcE, SrcBEwImm);
    
    alu alu (SrcAE, SrcBEwImm, 
               ALUControlE, 
               ALUOutE);
               
    assign WriteDataE = SrcBE;


    dmem dmem (clk, MemWriteM,ALUOutM, WriteDataM , ReadDataM);
             
PipeDtoE pipedtoe (
    .clk(clk),
    .clear(FlushE),
    .reset(reset),
    .RegWriteD(RegWriteD),
    .RegWriteE(RegWriteE),
    .MemtoRegD(MemtoRegD),
    .MemtoRegE(MemtoRegE),
    .MemWriteD(MemWriteD),
    .MemWriteE(MemWriteE),
    .ALUControlD(ALUControlD),
    .ALUControlE(ALUControlE),
    .ALUSrcD(ALUSrcD),
    .ALUSrcE(ALUSrcE),
    .RegDstD(RegDstD),
    .RegDstE(RegDstE),
    .RsDataD(RD1),
    .RsDataE(Read1E),
    .RtDataD(RD2),
    .RtDataE(Read2E),
    .RsD(RsD),
    .RsE(RsE),
    .RtD(RtD),
    .RtE(RtE),
    .RdD(RdD),
    .RdE(RdE),
    .SignImmD(SignImmD),
    .SignImmE(SignImmE)
);
           
PipeEtoM pipeetom (
    .clk(clk),
    .reset(reset),
    .RegWriteE(RegWriteE),
    .RegWriteM(RegWriteM),
    .MemtoRegE(MemtoRegE),
    .MemtoRegM(MemtoRegM),
    .MemWriteE(MemWriteE),
    .MemWriteM(MemWriteM),
    .ALUOutE(ALUOutE),
    .ALUOutM(ALUOutM),
    .WriteDataE(WriteDataE),
    .WriteDataM(WriteDataM),
    .WriteRegE(WriteRegE),
    .WriteRegM(WriteRegM)
);

PipeMtoW pipemtow (
    .clk(clk),
    .reset(reset),
    .RegWriteM(RegWriteM),
    .RegWriteW(RegWriteW),
    .MemtoRegM(MemtoRegM),
    .MemtoRegW(MemtoRegW),
    .ReadDataM(ReadDataM),
    .ReadDataW(ReadDataW),
    .ALUOutM(ALUOutM),
    .ALUOutW(ALUOutW),
    .WriteRegM(WriteRegM),
    .WriteRegW(WriteRegW)
);



endmodule



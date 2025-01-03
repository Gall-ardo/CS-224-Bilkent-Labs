`timescale 1ns / 1ps

module mips (input  logic        clk, reset,
             output logic [31:0] writedata, dataaddr,
             output logic        memwrite, regwrite,
             output logic [31:0] pc, PC_prime,
             output logic lwstall, branchstall, branch,
             output logic [4:0] writereg, rsD, rtD, regdst
           
             );

    logic        memtoreg, pcsrc, zero, alusrc, regWriteD, jump;
    logic [2:0]  alucontrol;
    logic [5:0]  op, funct;
    
    logic stallF, stallD, ForwardAD, ForwardBD, FlushE, RegWriteW, RegWriteM, MemtoRegE, MemtoRegM, MemWriteD;
    logic [1:0] ForwardAE, ForwardBE;

    logic [4:0] rsE, rtE, WriteRegE, WriteRegM, WriteRegW;

    datapath dp (clk, reset,
                regWriteD, memtoreg, MemWriteD,
                alucontrol, 
                alusrc, regdst, branch, jump,	         
                stallF, stallD, ForwardAD, ForwardBD, FlushE,   
                ForwardAE, ForwardBE,
                
                rsD, rtD, rsE, rtE,
                WriteRegE, WriteRegM, WriteRegW, 
                op, funct,
                RegWriteW, RegWriteM, regwrite, MemtoRegE, MemtoRegM,
                
                memwrite,                 
                dataaddr, writedata,
                pc, PC_prime, writereg
                );

    controller cont (op, funct,
    
                  memtoreg, MemWriteD,
                  alusrc,
                  regdst, regWriteD,
                  jump,
                  alucontrol,
                  branch);

    HazardUnit hu ( 
                branch,
                WriteRegW, WriteRegM, WriteRegE,
                RegWriteW, RegWriteM, regwrite, MemtoRegE, MemtoRegM,
                rsE,rtE,
                rsD,rtD,
                ForwardAD,ForwardBD,
                ForwardAE,ForwardBE,
                FlushE,stallD,stallF,
                
                lwstall, branchstall
    );

endmodule


`timescale 1ns / 1ps
module PipeDtoE(
    input  logic        clk,
    input  logic        clear,
    input  logic        reset,
    input  logic        RegWriteD,
    output logic        RegWriteE,
    input  logic        MemtoRegD,
    output logic        MemtoRegE,
    input  logic        MemWriteD,
    output logic        MemWriteE,
    input  logic [2:0]  ALUControlD,
    output logic [2:0]  ALUControlE,
    input  logic        ALUSrcD,
    output logic        ALUSrcE,
    input  logic        RegDstD,
    output logic        RegDstE,
    input  logic [31:0] RsDataD, 
    output logic [31:0] RsDataE,
    input  logic [31:0] RtDataD, 
    output logic [31:0] RtDataE, 
    input  logic [4:0]  RsD,
    output logic [4:0]  RsE,
    input  logic [4:0]  RtD,
    output logic [4:0]  RtE,
    input  logic [4:0]  RdD,
    output logic [4:0]  RdE,
    input  logic [31:0] SignImmD,
    output logic [31:0] SignImmE
);
   always_ff @(posedge clk or posedge reset) begin
       if (reset || clear) begin
           {RegWriteE, MemtoRegE, MemWriteE, ALUControlE, ALUSrcE, RegDstE, 
            RsDataE, RtDataE, RsE, RtE, RdE, SignImmE} <= '0;
       end else begin
           {RegWriteE, MemtoRegE, MemWriteE, ALUControlE, ALUSrcE, RegDstE,
            RsDataE, RtDataE, RsE, RtE, RdE, SignImmE} <=
           {RegWriteD, MemtoRegD, MemWriteD, ALUControlD, ALUSrcD, RegDstD,
            RsDataD, RtDataD, RsD, RtD, RdD, SignImmD};
       end
   end

endmodule
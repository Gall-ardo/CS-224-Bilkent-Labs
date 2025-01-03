`timescale 1ns / 1ps
module PipeMtoW(
   input  logic        clk,
   input  logic        reset,
   input  logic        RegWriteM,
   output logic        RegWriteW,
   input  logic        MemtoRegM,
   output logic        MemtoRegW,
   input  logic [31:0] ReadDataM,
   output logic [31:0] ReadDataW,
   input  logic [31:0] ALUOutM,
   output logic [31:0] ALUOutW,
   input  logic [4:0]  WriteRegM,
   output logic [4:0]  WriteRegW
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            {RegWriteW, MemtoRegW, ReadDataW, ALUOutW, WriteRegW} <= '0;
        end else begin
            {RegWriteW, MemtoRegW, ReadDataW, ALUOutW, WriteRegW} <= 
            {RegWriteM, MemtoRegM, ReadDataM, ALUOutM, WriteRegM};
        end
    end

endmodule
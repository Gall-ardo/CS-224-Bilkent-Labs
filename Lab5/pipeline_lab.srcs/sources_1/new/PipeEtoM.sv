`timescale 1ns / 1ps

module PipeEtoM(
   input  logic        clk,
   input  logic        reset,
   input  logic        RegWriteE,
   output logic        RegWriteM,
   input  logic        MemtoRegE,
   output logic        MemtoRegM,
   input  logic        MemWriteE,
   output logic        MemWriteM,
   input  logic [31:0] ALUOutE,
   output logic [31:0] ALUOutM,
   input  logic [31:0] WriteDataE,
   output logic [31:0] WriteDataM,
   input  logic [4:0]  WriteRegE,
   output logic [4:0]  WriteRegM
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            {RegWriteM, MemtoRegM, MemWriteM, ALUOutM, WriteDataM, WriteRegM} <= '0;
        end else begin
            {RegWriteM, MemtoRegM, MemWriteM, ALUOutM, WriteDataM, WriteRegM} <= 
            {RegWriteE, MemtoRegE, MemWriteE, ALUOutE, WriteDataE, WriteRegE};
        end
    end

endmodule
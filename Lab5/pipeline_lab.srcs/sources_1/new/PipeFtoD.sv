`timescale 1ns / 1ps

module PipeFtoD(input logic[31:0] instr, PcPlus4F,
                input logic EN, clk, clear, reset,
                output logic[31:0] instrD, PcPlus4D);

                always_ff @(posedge clk or posedge reset)
                    if (reset | clear) 
                        begin
                        instrD <= 0;
                        PcPlus4D <= 0;
                        end
                    else 
                        if(EN)
                        begin
                        instrD<=instr;
                        PcPlus4D<=PcPlus4F;
                        end
                
endmodule

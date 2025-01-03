`timescale 1ns / 1ps
module top_tb();
    // Test signals
    logic clk;
    logic reset;
    logic [31:0] writedata, dataadr;
    logic [31:0] readdata;
    logic memwrite;
    
    // Register monitoring signals
    logic [31:0] reg2, reg3, reg4, reg5, reg7;  // Registers to monitor
    
    // Instantiate the top module
    top dut(clk, reset, writedata, dataadr, readdata, memwrite);
    
    // Access registers for monitoring
    assign reg2 = dut.mips.dp.rf.rf[2];  // $2
    assign reg3 = dut.mips.dp.rf.rf[3];  // $3
    assign reg4 = dut.mips.dp.rf.rf[4];  // $4
    assign reg5 = dut.mips.dp.rf.rf[5];  // $5
    assign reg7 = dut.mips.dp.rf.rf[7];  // $7
    
    // Clock generation
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end
    
    // Test stimulus
    initial begin
        // Display header
        $display("\n=== MIPS Processor Test with BCON and XNORI ===\n");
        $display("Time\tPC\t\tInstruction\tOperation\t$2\t$3\t$4\t$5\t$7");
        $display("----\t--\t\t-----------\t---------\t--\t--\t--\t--\t--");
        
        // Initialize with reset
        reset = 1;
        @(posedge clk);
        @(posedge clk);
        reset = 0;
        
        // Monitor execution
        repeat(100) begin
            @(negedge clk); // Sample after register updates
            
            // Enhanced display with instruction type identification
            case(dut.instr[31:26])
                6'b110101: begin // BCON
                    $display("%0t\t%h\t%h\tBCON\t\t%h\t%h\t%h\t%h\t%h", 
                            $time, dut.pc, dut.instr,
                            reg2, reg3, reg4, reg5, reg7);
                end
                
                6'b110100: begin // XNORI
                    $display("%0t\t%h\t%h\tXNORI\t\t%h\t%h\t%h\t%h\t%h", 
                            $time, dut.pc, dut.instr,
                            reg2, reg3, reg4, reg5, reg7);
                end
                
                6'b000010: begin // J instruction
                    $display("%0t\t%h\t%h\tJUMP\t\t%h\t%h\t%h\t%h\t%h", 
                            $time, dut.pc, dut.instr,
                            reg2, reg3, reg4, reg5, reg7);
                    // Check if we've reached the loop jump (PC = 70 and jumping to 48)
                    if (dut.pc == 32'h70) begin
                        $display("\n=== Program reached final loop at PC = %h ===", dut.pc);
                        $display("Simulation finished");
                        $finish;
                    end
                end
                            
                default:
                    $display("%0t\t%h\t%h\tOther\t\t%h\t%h\t%h\t%h\t%h", 
                            $time, dut.pc, dut.instr,
                            reg2, reg3, reg4, reg5, reg7);
            endcase
        end
        
        // If we somehow miss the loop detection
        $display("\nSimulation timeout - %d cycles completed", 100);
        $display("Simulation finished");
        $finish;
    end
    
    // Memory write monitor
    always @(negedge clk) begin
        if(memwrite) begin
            $display("Memory write at %0t: Address=%h, Data=%h", 
                    $time, dataadr, writedata);
        end
    end
    
endmodule
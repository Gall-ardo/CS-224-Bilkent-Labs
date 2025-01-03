`timescale 1ns / 1ps
module mips_tb();
    logic        clk, reset;
    logic [31:0] writedata, dataaddr;
    logic        memwrite, regwrite;
    logic [31:0] pc, PC_prime;
    logic        lwstall, branchstall, branch;
    logic [4:0]  writereg, rsD, rtD, regdst;

    // Coverage group declaration
    covergroup control_coverage @(posedge clk);
        regwrite_cp: coverpoint regwrite;
        memwrite_cp: coverpoint memwrite;
        branch_cp:   coverpoint branch;
        stall_cp:    coverpoint {lwstall, branchstall} {
            bins no_stall = {2'b00};
            bins lw_stall = {2'b10};
            bins br_stall = {2'b01};
        }
    endgroup
    // Declare coverage instance as automatic
    control_coverage cov;

    // Instantiate device under test
    mips dut(clk, reset, writedata, dataaddr, memwrite, regwrite,
             pc, PC_prime, lwstall, branchstall, branch,
             writereg, rsD, rtD, regdst);

    // Generate clock
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

    // Initialize coverage and start simulation
    initial begin
        // Create coverage instance
        cov = new();

        // Initialize Inputs
        reset = 1;

        // Wait 100 ns for global reset
        #100;
        reset = 0;

        // Monitor pipeline stages and hazards
        repeat(50) begin
            @(posedge clk);
            $display("Time=%0t:", $time);
            $display("PC=%h PC_prime=%h", pc, PC_prime);

            // Pipeline and Control Signals
            $display("Control Signals:");
            $display("  MemWrite=%b RegWrite=%b Branch=%b", 
                    memwrite, regwrite, branch);

            // Hazard Detection
            $display("Hazard Status:");
            $display("  LWstall=%b BranchStall=%b", 
                    lwstall, branchstall);

            // Register Information
            $display("Register Info:");
            $display("  WriteReg=%d rsD=%d rtD=%d RegDst=%d", 
                    writereg, rsD, rtD, regdst);

            // Memory Access
            if(memwrite) begin
                $display("Memory Write:");
                $display("  Address=%h Data=%h", 
                        dataaddr, writedata);
            end

            $display("----------------------------------------");
        end

        $finish;
    end

    // Optional: Assertions to verify proper hazard handling
    property no_simultaneous_stalls;
        @(posedge clk) not(lwstall && branchstall);
    endproperty
    assert property(no_simultaneous_stalls);

    // Monitor changes in key signals
    always @(regwrite, memwrite, branch) begin
        $display("Time=%0t: Signal Change", $time);
        $display("  RegWrite=%b MemWrite=%b Branch=%b", 
                regwrite, memwrite, branch);
    end

    // Add VCD dump
    initial begin
        $dumpfile("mips_tb.vcd");
        $dumpvars(0, mips_tb);
    end

endmodule
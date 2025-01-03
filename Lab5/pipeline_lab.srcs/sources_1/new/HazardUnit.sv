`timescale 1ns / 1ps


module HazardUnit( 
                input logic branchD,
                input logic [4:0] WriteRegW, WriteRegM, WriteRegE,
                input logic RegWriteW, RegWriteM, RegWriteE, MemtoRegE, MemtoRegM,
                input logic [4:0] rsE,rtE,
                input logic [4:0] rsD,rtD,
                output logic ForwardAD,ForwardBD,
                output logic [2:0] ForwardAE,ForwardBE,
                output logic FlushE,StallD,StallF, lwstall, branchstall

    );
        
    always_comb begin   
        lwstall = MemtoRegE & ( rtE == rsD | rtE == rtD );
        branchstall = (branchD & RegWriteE & ( WriteRegE == rsD | WriteRegE == rtD ))
                                    |
                      (branchD & MemtoRegM & ( WriteRegM == rsD | WriteRegM == rtD ));
        StallF = lwstall | branchstall;
        StallD = lwstall | branchstall;
        FlushE = lwstall | branchstall;
        ForwardAD = RegWriteM & ( rsD != 0 & rsD == WriteRegM );
        ForwardBD = RegWriteM & ( rtD != 0 & rtD == WriteRegM );
        
        if ( rsE != 0 & rsE == WriteRegM & RegWriteM ) begin
            ForwardAE = 2'b10;
        end
        else if ( rsE != 0 & rsE == WriteRegW & RegWriteW ) begin
            ForwardAE = 2'b01;
        end
        else begin
            ForwardAE = 2'b00;
        end
        
        if ( rtE != 0 & rtE == WriteRegM & RegWriteM ) begin
            ForwardBE = 2'b10;
        end
        else if ( rtE != 0 & rtE == WriteRegW & RegWriteW ) begin
            ForwardBE = 2'b01;
        end
        else begin
            ForwardBE = 2'b00;
        end
    end
endmodule
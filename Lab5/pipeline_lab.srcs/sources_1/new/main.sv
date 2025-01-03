`timescale 1ns / 1ps
module main(
    input logic clk,             // 100 MHz clock from BASYS3
    input logic btnC,           // Center button for reset
    input logic btnU,           // Up button for clock pulse
    output logic [6:0] seg,     // 7-segment display segments
    output logic dp,            // Decimal point
    output logic [3:0] an,      // 7-segment display digit select
    output logic [15:0] LED     // LEDs for control signals
);
    // Internal signals
    logic clk_pulse, reset_pulse;  // Debounced clock and reset signals
    logic [31:0] writedata, dataaddr;  
    logic memwrite, regwrite;          
    logic [31:0] pc, PC_prime;         
    logic lwstall, branchstall, branch;
    logic [4:0] writereg, rsD, rtD, regdst;
    
    // Generate clock pulse from button press
    pulse_controller clock_pulse_ctrl(
        .CLK(clk),
        .sw_input(btnU),
        .clear(btnC),
        .clk_pulse(clk_pulse)
    );

    // Generate reset pulse from button press
    pulse_controller reset_pulse_ctrl(
        .CLK(clk),
        .sw_input(btnC),
        .clear(1'b0),
        .clk_pulse(reset_pulse)
    );

    // Instantiate MIPS processor
    mips mips_proc(
        .clk(clk_pulse),
        .reset(reset_pulse),
        .writedata(writedata),      // RF[rt] in Execute stage
        .dataaddr(dataaddr),        // ALU result in Execute stage
        .memwrite(memwrite),        // Control signal in Decode stage
        .regwrite(regwrite),        // Control signal in Decode stage
        .pc(pc),
        .PC_prime(PC_prime),
        .lwstall(lwstall),
        .branchstall(branchstall),
        .branch(branch),
        .writereg(writereg),
        .rsD(rsD),
        .rtD(rtD),
        .regdst(regdst)
    );

    logic [3:0] display_digits [3:0];
    
    assign display_digits[0] = writedata[3:0];
    assign display_digits[1] = writedata[7:4];
    
    assign display_digits[2] = dataaddr[3:0];
    assign display_digits[3] = dataaddr[7:4];

    display_controller display_ctrl(
        .clk(clk),                 
        .in0(display_digits[0]),      
        .in1(display_digits[1]),   
        .in2(display_digits[2]),   
        .in3(display_digits[3]),
        .seg(seg),
        .dp(dp),
        .an(an)
    );

    // LED output assignments for Decode stage control signals
    assign LED[0] = memwrite;    // Memory write signal from Decode stage
    assign LED[1] = regwrite;    // Register write signal from Decode stage
    assign LED[2] = branch;      // Branch signal
    assign LED[3] = lwstall;     // Load-word stall
    assign LED[4] = branchstall; // Branch stall
    assign LED[15:5] = 11'b0;    // Unused LEDs
endmodule
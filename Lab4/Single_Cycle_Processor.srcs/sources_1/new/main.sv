`timescale 1ns / 1ps
module main(
    input  logic        CLK,               // 100MHz clock from Basys3
    input  logic        button_clk,        // Clock button
    input  logic        button_reset,      // Reset button
    output logic        memwrite_led,      // LED for memwrite signal
    output logic [6:0]  seg,              // 7-segment segments
    output logic [3:0]  an,               // 7-segment digit select
    output logic        dp                 // 7-segment decimal point
);
    // Internal signals
    logic mips_clk;                        // Debounced clock
    logic mips_reset;                      // Debounced reset
    logic clear = 0;                       // Clear signal for pulse controllers
    logic [31:0] writedata, dataadr, readdata;
    logic memwrite;

    logic [3:0] display_val3, display_val2, display_val1, display_val0;
    
    assign display_val3 = writedata[7:4];  // Left digits show writedata
    assign display_val2 = writedata[3:0];
    assign display_val1 = dataadr[7:4];    // Right digits show dataadr
    assign display_val0 = dataadr[3:0];

    // Instantiate two pulse controllers
    pulse_controller clock_pulse(
        .CLK(CLK),
        .sw_input(button_clk),
        .clear(clear),
        .clk_pulse(mips_clk)
    );

    pulse_controller reset_pulse(
        .CLK(CLK),
        .sw_input(button_reset),
        .clear(clear),
        .clk_pulse(mips_reset)
    );

    // Instantiate modules
    top top(
        .clk(mips_clk),
        .reset(mips_reset),
        .writedata(writedata), 
        .dataadr(dataadr), 
        .readdata(readdata),           
        .memwrite(memwrite)
    );

    // Instantiate the display controller
    display_controller display_ctrl(
        .clk(CLK),
        .in3(display_val3),
        .in2(display_val2),
        .in1(display_val1),
        .in0(display_val0),
        .seg(seg),
        .dp(dp),
        .an(an)
    );

    // Connect memwrite to LED
    assign memwrite_led = memwrite;

endmodule
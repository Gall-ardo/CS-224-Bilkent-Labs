`timescale 1ns / 1ps

module imem ( input logic [7:0] addr, output logic [31:0] instr);

// imem is modeled as a lookup table, a stored-program byte-addressable ROM
	always_comb
	   case (addr)		   	// word-aligned fetch
//		address		instruction
//		-------		-----------
		8'h00: instr = 32'h20020005;  	// disassemble, by hand 
		8'h04: instr = 32'h2003000c;  	// or with a program,
		8'h08: instr = 32'h2067fff7;  	// to find out what
		8'h0c: instr = 32'h00e22025;  	// this program does!
		8'h10: instr = 32'h00642824;
		8'h14: instr = 32'h00a42820;
		8'h18: instr = 32'h10a7000a;
		8'h1c: instr = 32'h0064202a;
		8'h20: instr = 32'h10800001;
		8'h24: instr = 32'h20050000;
		8'h28: instr = 32'h00e2202a;
		8'h2c: instr = 32'h00853820;
		8'h30: instr = 32'h00e23822;
		8'h34: instr = 32'hac670044;
		8'h38: instr = 32'h8c020050;
		8'h3c: instr = 32'h08000011;
		8'h40: instr = 32'h20020001;
		8'h44: instr = 32'hac020054;
		
		8'h48: instr = 32'hd4650005;    // bcon 3 5 5
        8'h4c: instr = 32'hd4a70004;    // bcon  5 7 4

        8'h50: instr = 32'h2004003c;    // addi 4 0 60
        8'h54: instr = 32'h20050040;    // addi 5 0 64
        8'h58: instr = 32'hd4850002;    // bcon 4 5 2

        8'h5c: instr = 32'h2004003c;    // addi 4 0 60
        8'h60: instr = 32'h2004003c;    // addi 4 0 60
        8'h64: instr = 32'h2004ae32;    // addi 4 0 ae32. should branch here

        8'h68: instr = 32'hd0a7ffff;    // xnori 7 5 ffff
        8'h6c: instr = 32'hd0a70f0f;    // xnori 7 5 0f0f   
        8'h70: instr = 32'hd0a7a23e;    // xnori 7 5 a23e

		8'h74: instr = 32'h0800001d;	// j 48, so it will loop here
	     default:  instr = {32{1'bx}};	// unknown address
	   endcase
endmodule
module alu_tb;
    // Signals declaration
    logic [31:0] a, b;
    logic [2:0]  alucont;
    logic [31:0] result;
    logic zero;
    
    // Instantiate the ALU
    alu dut(
        .a(a),
        .b(b),
        .alucont(alucont),
        .result(result),
        .zero(zero)
    );
    
    // Test stimulus
    initial begin
        // Test case 1: Addition
        a = 32'h5;
        b = 32'h3;
        alucont = 3'b010;
        #10;
        if (result !== 32'h8) $error("Addition failed: %h + %h = %h", a, b, result);
        
        // Test case 2: Subtraction
        a = 32'h5;
        b = 32'h3;
        alucont = 3'b110;
        #10;
        if (result !== 32'h2) $error("Subtraction failed: %h - %h = %h", a, b, result);
        
        // Test case 3: AND
        a = 32'hF0F0;
        b = 32'hFF00;
        alucont = 3'b000;
        #10;
        if (result !== 32'hF000) $error("AND failed: %h & %h = %h", a, b, result);
        
        // Test case 4: OR
        a = 32'hF0F0;
        b = 32'h0F0F;
        alucont = 3'b001;
        #10;
        if (result !== 32'hFFFF) $error("OR failed: %h | %h = %h", a, b, result);
        
        // Test case 5: Set Less Than (true case)
        a = 32'h3;
        b = 32'h5;
        alucont = 3'b111;
        #10;
        if (result !== 32'h1) $error("SLT failed: %h < %h should be true", a, b);
        
        // Test case 6: Set Less Than (false case)
        a = 32'h5;
        b = 32'h3;
        alucont = 3'b111;
        #10;
        if (result !== 32'h0) $error("SLT failed: %h < %h should be false", a, b);
        
        // Test case 7: Zero flag (when result is zero)
        a = 32'h5;
        b = 32'h5;
        alucont = 3'b110;  // Subtraction that results in zero
        #10;
        if (!zero) $error("Zero flag not set when result is zero");
        
        // Test case 8: Invalid operation
        a = 32'h5;
        b = 32'h3;
        alucont = 3'b011;  // Invalid operation code
        #10;
        
        $display("All tests completed!");
        $finish;
    end
    
    // Optional: Waveform generation
    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);
    end
endmodule
module alu(input  logic [31:0] a, b, 
           input  logic [2:0]  alucont, 
           output logic [31:0] result,
           output logic zero);             
    always_comb begin
    result = 32'b0;
    
        case(alucont)
            3'b010: result = a + b;
            3'b110: result = a - b;
            3'b000: result = a & b;
            3'b001: result = a | b;
            3'b111: result = (a < b) ? 32'h00000001 : 32'h00000000;
            default: result = {32{1'bx}};
        endcase
    end
    
    assign zero = (result == 0) ? 1'b1 : 1'b0;
endmodule
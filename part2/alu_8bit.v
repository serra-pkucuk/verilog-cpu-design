module alu_8bit(
    input [7:0] A,
    input [7:0] B,
    input [2:0] opcode,
    output reg [7:0] result,
    output reg carry, overflow, zero, sign
);

    always @(*) begin
        carry = 0;
        overflow = 0;
        zero = 0;
        sign = 0;
        
        case(opcode)
            3'b000: {carry, result} = A + B;
            3'b001: result = A - B;
            3'b010: result = A & B;
            3'b011: result = A | B;
            3'b100: result = ~A;
            3'b101: result = A ^ B;
            default: result = 8'b0;
        endcase

        zero = (result == 8'b0);
        sign = result[7];
    end
endmodule

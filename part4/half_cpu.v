module half_cpu(
    input clk,
    input rst,
    output [15:0] result_out
);
    reg [3:0] pc;
    wire [15:0] instruction;

    reg [15:0] imem [0:15];
    assign instruction = imem[pc];

    wire [2:0] opcode = instruction[15:13];
    wire [3:0] rd     = instruction[12:9];
    wire [3:0] rs1    = instruction[8:5];
    wire [3:0] rs2    = instruction[4:1];

    reg [15:0] reg_file [0:15];
    wire [15:0] val1 = reg_file[rs1];
    wire [15:0] val2 = reg_file[rs2];
    reg [15:0] alu_out;

    always @(*) begin
        case(opcode)
            3'b000: alu_out = val1 + val2;
            3'b001: alu_out = val1 - val2;
            3'b010: alu_out = val1 << val2[3:0];
            3'b011: alu_out = val1 >> val2[3:0];
            3'b100: alu_out = val1 & val2;
            3'b101: alu_out = val1 | val2;
            3'b110: alu_out = ~val1;
            3'b111: alu_out = val1 ^ val2;
            default: alu_out = 16'b0;
        endcase
    end

    always @(posedge clk) begin
        if (rst) begin
            pc <= 4'b0;
        end else begin
            reg_file[rd] <= alu_out;
            pc <= pc + 1;
        end
    end

    assign result_out = alu_out;
endmodule

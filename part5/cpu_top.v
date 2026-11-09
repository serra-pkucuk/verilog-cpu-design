module cpu_top(
    input clk,
    input btn_rst,
    output [6:0] seg,
    output [3:0] an
);
    wire slow_clk;
    wire rst;
    wire [15:0] cpu_out;

    reg [15:0] clk_div;
    always @(posedge clk) clk_div <= clk_div + 1;
    assign slow_clk = clk_div[15];

    reg dff1, dff2;
    always @(posedge clk) begin
        dff1 <= btn_rst;
        dff2 <= dff1;
    end
    assign rst = dff2;

    half_cpu cpu_inst(
        .clk(slow_clk),
        .rst(rst),
        .result_out(cpu_out)
    );

    reg [3:0] hex_val;
    reg [3:0] an_reg;
    wire [1:0] scan_cnt = clk_div[14:13];

    always @(*) begin
        case(scan_cnt)
            2'b00: begin an_reg = 4'b1110; hex_val = cpu_out[3:0]; end
            2'b01: begin an_reg = 4'b1101; hex_val = cpu_out[7:4]; end
            2'b10: begin an_reg = 4'b1011; hex_val = cpu_out[11:8]; end
            2'b11: begin an_reg = 4'b0111; hex_val = cpu_out[15:12]; end
            default: begin an_reg = 4'b1111; hex_val = 4'b0; end
        endcase
    end
    assign an = an_reg;

    reg [6:0] seg_reg;
    always @(*) begin
        case(hex_val)
            4'h0: seg_reg = 7'b1000000;
            4'h1: seg_reg = 7'b1111001;
            4'h2: seg_reg = 7'b0100100;
            4'h3: seg_reg = 7'b0110000;
            4'h4: seg_reg = 7'b0011001;
            4'h5: seg_reg = 7'b0010010;
            4'h6: seg_reg = 7'b0000010;
            4'h7: seg_reg = 7'b1111000;
            4'h8: seg_reg = 7'b0000000;
            4'h9: seg_reg = 7'b0010000;
            4'hA: seg_reg = 7'b0001000;
            4'hB: seg_reg = 7'b0000011;
            4'hC: seg_reg = 7'b1000110;
            4'hD: seg_reg = 7'b0100001;
            4'hE: seg_reg = 7'b0000110;
            4'hF: seg_reg = 7'b0001110;
            default: seg_reg = 7'b1111111;
        endcase
    end
    assign seg = seg_reg;
endmodule

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

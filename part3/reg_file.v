module reg_file(
    input clk,
    input we,
    input [3:0] addr,
    input [15:0] data_in,
    output [15:0] data_out
);
    reg [15:0] mem [0:15];

    assign data_out = mem[addr];

    always @(posedge clk) begin
        if (we)
            mem[addr] <= data_in;
    end
endmodule

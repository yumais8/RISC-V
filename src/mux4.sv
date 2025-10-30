module mux4 (
    logic input [31:0] option0,
    logic input [31:0] option1,
    logic input [31:0] option2,
    logic input [31:0] option3,
    logic input [1:0] select,
    logic output [31:0] output
);

always_comb begin
    case(select)
        2'b00: output = option0;
        2'b01: output = option1;
        2'b10: output = option2;
        2'b11: output = option3;
        default: output = 32'b0;
    endcase
end

endmodule
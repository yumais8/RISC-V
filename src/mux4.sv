module mux4 (
    input logic [31:0] option0,
    input logic [31:0] option1,
    input logic [31:0] option2,
    input logic [31:0] option3,
    input logic [1:0] select,
    output logic [31:0] mux_out
);

always_comb begin
    case(select)
        2'b00: mux_out = option0;
        2'b01: mux_out = option1;
        2'b10: mux_out = option2;
        2'b11: mux_out = option3;
        default: mux_out = 32'b0;
    endcase
end

endmodule

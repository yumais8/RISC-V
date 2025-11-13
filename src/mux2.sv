module mux2(
    input logic[31:0] data1,
    input logic[31:0] data2,
    input logic select,
    output logic[31:0] out_data
);

always_comb begin
    case(select)
        1'b0: out_data = data1;
        1'b1: out_data = data2;
        default: out_data = 32'b1;
    endcase
end

endmodule;
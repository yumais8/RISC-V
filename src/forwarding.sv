module forwarding(
    input logic [4:0] rs1_ex,
    input logic [4:0] rs2_ex,
    input logic [4:0] rd_mem,
    input logic [4:0] rd_wb,
    input logic [1:0] wb_sel_mem,
    input logic [1:0] wb_sel_wb,
    output logic [1:0] rs1_fwd_mux_sel,
    output logic [1:0] rs2_fwd_mux_sel,
    output logic stall
);

always_comb begin
    rs1_fwd_mux_sel = 2'b00;
    rs2_fwd_mux_sel = 2'b00;
    stall   = 1'b0;

    if(rd_wb != 5'b0) begin
        if(rd_wb == rs1_ex) rs1_fwd_mux_sel = (wb_sel_wb == 2'b01) ? 2'b11   // load  -> mem_data_wb, mem at wb stage, option 4
                                                            : 2'b10;    // calculation -> alu out at wb stage, option3
        if(rd_wb == rs2_ex) rs2_fwd_mux_sel = (wb_sel_wb == 2'b01) ? 2'b11
                                                            : 2'b10;
        end

    if(rd_mem != 5'b0) begin
        if (wb_sel_mem == 2'b01) begin
            // Load in MEM feeding EX -> stall
            if (rd_mem == rs1_ex || rd_mem == rs2_ex)   // is loading, and also reusing the register, and hazard exists
                stall = 1'b1;
        end else begin
            if (rd_mem == rs1_ex) rs1_fwd_mux_sel = 2'b01;  // alu forward only
            if (rd_mem == rs2_ex) rs2_fwd_mux_sel = 2'b01;
        end
    end
end

endmodule
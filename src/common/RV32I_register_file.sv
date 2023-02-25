module RV32I_register_file #(parameter NUM_OF_SETS = 32, parameter DATA_BUS_WIDTH = 32) (
	//Inputs
	input wire clk, rst,
	input wire wr_enable,
	input wire [$clog2(NUM_OF_SETS)-1:0] rd_addr_1, rd_addr_2, rd_addr_3, wr_addr,
	input wire [DATA_BUS_WIDTH-1:0] wr_data,
	//Outputs
	output wire [DATA_BUS_WIDTH-1:0] rd_data_1, rd_data_2, rd_data_3
);

	//Declaring the Registers array
	reg [DATA_BUS_WIDTH-1:0] registers [NUM_OF_SETS-1:0];
	
	//Read is async
	assign rd_data_1 = 	rd_addr_1 == '0 ?
						'0 : registers[rd_addr_1];
	assign rd_data_2 = 	rd_addr_2 == '0 ?
						'0 : registers[rd_addr_2];
	assign rd_data_3 = 	rd_addr_3 == '0 ?
						'0 : registers[rd_addr_3];

	//Write is synced, ignore address '0
	generate
	always @(posedge clk, posedge rst) begin
		if (rst) begin
			for (int i=0; i<NUM_OF_SETS; i=i+1) begin : quartus_generate_fix
				registers[i] <= '0;
			end
		end else begin
			if (wr_enable)
				registers[wr_addr] <= wr_data;
		end
	end
	endgenerate

endmodule : RV32I_register_file
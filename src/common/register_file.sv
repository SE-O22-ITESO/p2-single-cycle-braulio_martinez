module register_file #(parameter NUM_OF_SETS = 32, parameter DATA_BUS_WIDTH = 32) (
	//Inputs
	input wire clk, rst,
	input wire wr_enable,
	input wire [$clog2(NUM_OF_SETS)-1:0] rd_addr, wr_addr,
	input wire [DATA_BUS_WIDTH-1:0] wr_data,
	//Outputs
	output wire [DATA_BUS_WIDTH-1:0] rd_data
);

	//Declaring the Registers array
	reg [DATA_BUS_WIDTH-1:0] registers [NUM_OF_SETS-1:0];
	
	//Read is async
	assign rd_data	 = 	registers[rd_addr];

	//Write is synced
	always @(posedge clk)
		if (wr_enable)
			registers[wr_addr] <= wr_data;

endmodule : register_file
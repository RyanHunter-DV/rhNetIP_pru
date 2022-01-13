module syncFifo8x242 (
	iClk,
	iRstn,
	iWe,
	iRe,
	iWData,
	oFull,
	oEmpty,
	oRData
); // {

	input iClk, iRstn;
	input iWe,iRe;
	input [241:0] iWData;
	output oFull, oEmpty;
	output [241:0] oRData;


	reg [2:0] rPtr,wPtr,rCount;
	reg [241:0] mem [7:0];

	assign oRData = mem[rPtr];
	assign oFull  = (rCount != 3'h0) ? 1'b1:1'b0;
	assign oEmpty = (rCount == 3'h0) ? 1'b1:1'b0;

	always @(posedge iClk or negedge iRstn) begin //{
		if (~iRstn) begin // {
			wPtr <= 3'h0;
			rPtr <= 3'h0;
			rCount <= 3'h0;
		// }
		end else begin // {
			if (iWe) wPtr <= wPtr + 1'b1;
			if (iRe) rPtr <= rPtr + 1'b1;
			if (iWe) mem[wPtr] <= iWData;
			if (iWe&~iRe) rCount <= rCount + 1'b1;
			else if (~iWe&iRe) rCount <= rCount - 1'b1;
			else rCount <= rCount;
		end // }
	end // }



endmodule // }



module drc_top(

	iClk,
	iResetN,

	DRC_PEC_pktDisValid,
	DRC_PEC_pktDisType,
	DRC_PEC_pktDisData,
	DRC_PEC_pktDisAddr,
	DRC_PEC_pktDisPort,

	DRC_DAMC_lookupValid,
	DRC_DAMC_lookupDeviceAddr,
	DRC_DAMC_lookupRspValid,
	DRC_DAMC_lookupRspPortID,

); // {

	input iClk, iResetN;

	// ports with PEC // {
	input DRC_PEC_pktDisValid;
	input [5:0] DRC_PEC_pktDisType;
	input [127:0] DRC_PEC_pktDisData;
	input [15:0] DRC_PEC_pktDisAddr;
	input [4:0] DRC_PEC_pktDisPort;
	// }

	// ports with DAMC // {
	output DRC_DAMC_lookupValid;
	output [15:0] DRC_DAMC_lookupDeviceAddr;
	input DRC_DAMC_lookupRspValid;

	// port id 0 indicates the invalid portID
	// so port id should assigned from value 1
	input [4:0] DRC_DAMC_lookupRspPortID;
	// }


	// packet type define //{
	parameter UPREQ = ;
	parameter DOWNREQ = ;
	parameter UPRSP = ;
	parameter DOWNRSP = ;
	//}


	// packet type selection logic // {

	wire uploadRequestValid;
	wire downloadRequestValid;
	wire uploadResponseValid;
	wire downloadResponseValid;

	assign uploadRequestValid = (DRC_PEC_pktDisType&{6{DRC_PEC_pktDisValid}}) == UPREQ ? 1'b1:1'b0;
	assign downloadRequestValid = (DRC_PEC_pktDisType&{6{DRC_PEC_pktDisValid}}) == DOWNREQ ? 1'b1:1'b0;
	assign uploadResponseValid = (DRC_PEC_pktDisType&{6{DRC_PEC_pktDisValid}}) == UPRSP ? 1'b1:1'b0;
	assign downloadResponseValid = (DRC_PEC_pktDisType&{6{DRC_PEC_pktDisValid}}) == DOWNRSP ? 1'b1:1'b0;

	// }



	// upload/download request, lookup server logic //{
	reg lookupReqValid;
	reg [15:0] lookupReqAddr;


	assign DRC_DAMC_lookupValid = lookupReqValid;
	assign DRC_DAMC_lookupDeviceAddr = lookupReqAddr;

	wire lookupValidFlag;
	lookupValidFlag=uploadRequestValid|downloadRequestValid|uploadResponseValid|downloadResponseValid;


	always @(posedge iClk or negedge iResetN) begin //{
		if (~iResetN) begin //{
			lookupReqValid <= 1'b0;
			lookupReqAddr <= 16'h0;
		//}
		end else begin //{
			if (lookupValidFlag) begin //{
				lookupReqValid <= 1'b1;
				lookupReqAddr <= DRC_PEC_pktDisAddr;
			//}
			end else begin //{
				// clear lookup request
				lookupReqValid <= 1'b0;
				lookupReqAddr <= 16'h0;
			end //}
		end //}
	end //}
	//}

	// lookup response logic //{
	wire deviceUnreachableFlag;

	assign deviceUnreachableFlag = (DRC_DAMC_lookupRspValid&(&DRC_DAMC_lookupRspPortID))? 1'b1:1'b0;

	//}


	// unreachable response generate logic //{

	reg unreachableRspValid;
	// not needed, reg [5:0] unreachableRspType;
	reg [4:0] unreachableRspPort;
	reg [15:0] unreachableRspAddr;

	
	always @(posedge iClk or negedge iResetN) begin //{
		if (~iResetN) begin //{
			unreachableRspValid <= 1'b0;
			unreachableRspPort <= 5'h0;
			unreachableRspAddr <= 16'h0;
		//}
		end else begin //{
			if (lookupValidFlag) begin //{
				// record the portID from client
				unreachableRspPort <= DRC_PEC_pktDisPort;
				unreachableRspValid <= 1'b0;
			//}
			end else if (deviceUnreachableFlag) begin //{
				unreachableRspValid <= 1'b1;
			//}
			end else begin //{
				unreachableRspValid <= 1'b0;
			end //}
		end //}
	end //}
	//}


	// packet assemble logic //{
	// }



endmodule // }

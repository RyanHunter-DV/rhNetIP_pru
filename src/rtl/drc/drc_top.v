

module drc_top(

	iClk,
	iResetN,

	DRC_PEC_pktDisValid,
	DRC_PEC_pktDisType,
	DRC_PEC_pktDisData,
	DRC_PEC_pktDisAddr, // target address
	DRC_PEC_pktDisPort, // source port

	DRC_DAMC_lookupValid,
	DRC_DAMC_lookupDeviceAddr,
	DRC_DAMC_lookupRspValid,
	DRC_DAMC_lookupRspPort,

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
	input [4:0] DRC_DAMC_lookupRspPort;
	// }


	// packet type define //{
	// TODO, using tmp definition
	parameter UPREQ   = 1;
	parameter DOWNREQ = 2;
	parameter UPRSP   = 3;
	parameter DNRSP   = 4;
	parameter UPDAT   = 5;
	//}


	// packet type selection logic // {

	wire uploadReqVldFlag;
	wire uploadDataVldFlag;
	wire downloadReqVldFlag;
	wire uploadResponseValid;
	wire downloadResponseValid;

	assign uploadReqVldFlag      = (DRC_PEC_pktDisType&{6{DRC_PEC_pktDisValid}}) == UPREQ ? 1'b1:1'b0;
	assign uploadDataVldFlag     = (DRC_PEC_pktDisType&{6{DRC_PEC_pktDisValid}}) == UPDAT ? 1'b1:1'b0;
	assign downloadReqVldFlag    = (DRC_PEC_pktDisType&{6{DRC_PEC_pktDisValid}}) == DOWNREQ ? 1'b1:1'b0;
	assign uploadResponseValid   = (DRC_PEC_pktDisType&{6{DRC_PEC_pktDisValid}}) == UPRSP ? 1'b1:1'b0;
	assign downloadResponseValid = (DRC_PEC_pktDisType&{6{DRC_PEC_pktDisValid}}) == DNRSP ? 1'b1:1'b0;

	// }


	// request record logic ##{{{
	// request info is recorded next cycle after pktDis* is valid
	reg [15:0] recordUpReqSrcAddr;
	reg [4:0] recordUpReqSrcPort;
	reg [127:0] recordUpReqSrcData;
	// TODO

	always @(posedge iClk or negedge iResetN) begin //{
		if (~iResetN) begin //{
		//}
		end else begin //{
			if (uploadReqVldFlag) begin //{
				// record uploadReq info
				recordUpReqSrcData <= DRC_PEC_pktDisData;
				// TODO
			end //}
		end //}
	end //}
	// ##}}}

	// upload/download request, lookup logic //{
	reg lookupReqValid;
	reg [15:0] lookupReqAddr;


	assign DRC_DAMC_lookupValid = lookupReqValid;
	assign DRC_DAMC_lookupDeviceAddr = lookupReqAddr;

	wire lookupValidFlag;
	assign lookupValidFlag=uploadReqVldFlag|downloadReqVldFlag|uploadResponseValid|downloadResponseValid;



	always @(posedge iClk or negedge iResetN) begin //{
		if (~iResetN) begin //{
			lookupReqValid <= 1'b0;
			lookupReqAddr <= 16'h0;
		//}
		end else begin //{
			if (lookupValidFlag) begin //{
				lookupReqValid <= 1'b1;
				lookupReqAddr <= DRC_PEC_pktDisAddr;
				// TODO, recordIncomeSrcAddr <= DRC_PEC_pktDisAddr;
				// TODO, recordIncomeSrcData <= DRC_PEC_pktDisData;
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
	wire deviceReachableFlag;

	// portID == 0 means device unreachable. This flag is usable for all looking
	// up responses from DAMC
	assign deviceUnreachableFlag = (DRC_DAMC_lookupRspValid&~(&DRC_DAMC_lookupRspPort))? 1'b1:1'b0;
	assign deviceReachableFlag = ~deviceUnreachableFlag;

	//}


	// unreachable response generate logic //##{{{

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
				// don't need unreachableRspAddr
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
	//##}}}





	// route request logic, to convert request information ##{{{
	// supports uploading/downloading request
	// receiving reachableFlag from lookup response logic

	reg routeOutcomeVld;
	reg [15:0]  routeOutcomeSrcAddr;
	reg [127:0] routeOutcomeData;
	reg [4:0]   routeOutcomeDestPort;

	always @(posedge iClk or negedge iResetN) begin //{
		if (~iResetN) begin //{
			routeOutcomeVld <= 1'b0;
			routeOutcomeSrcAddr <= 16'h0;
			routeOutcomeData <= 128'h0;
			routeOutcomeDestPort <= 5'h0;
		//}
		end else begin //{
			if (deviceReachableFlag) begin //{
				routeOutcomeVld <= 1'b1;
				routeOutcomeSrcAddr <= recordIncomeSrcAddr;
				routeOutcomeData <= recordIncomeSrcData;
				routeOutcomeDestPort <= DRC_DAMC_lookupRspPort;
			end //}
			// TODO, to de-assert the routeOutcom* signals
		end //}
	end //}
	// ##}}}


	pkt_ass_block upab(
	);



endmodule // }

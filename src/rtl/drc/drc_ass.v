// this is an internal logic of drc_top, it's only used for easy reading,
// the circuit are same
`define PARAM URCHRP=6'h6,RSHRQ=6'h7,UPRSP=6'h3,DNRSP=6'h4
module pkt_ass_block #(`PARAM) (
); //{

	input iUnreachableRspVld;
	input [15:0] iUnreachableRspSrcAddr;
	input [4:0] iUnreachableRspTargtPort; // target port is the src port

	input iRefreshReqVld;
	input iUploadRspVld;
	input iDownloadRspVld;



	output [5:0] oAssPktType;
	output oAssPktVld;
	output [15:0] oAssPktSrcAddr;
	output [4:0] oAssPktTargtPort;
	output [127:0] oAssPktData;


	reg [5:0] rAssPktType;
	reg rAssPktVld;
	reg [15:0] rAssPktSrcAddr;
	reg [4:0] rAssPktTargtPort;
	reg [127:0] rAssPktData;

	assign oAssPktType = rAssPktType;
	assign oAssPktVld  = rAssPktVld;
	assign oAssPktSrcAddr = rAssPktSrcAddr;
	assign oAssPktTargtPort = rAssPktTargtPort;
	assign oAssPktData = rAssPktData;


	/*
	// src //

	component :pkt_ass_block do ##{
		urch = 'Unreachable'
		iport 'i'+urch+'RspVld'
		iport 'i'+urch+'RspSrcAddr',16
		iport :iRefreshReqVld
		...
	end ##}


	seqblock :iClk, :iResetN do ##{
		reset do ##{
			## TODO
		end ##}
		condition do ##{
			branch :b1, 'iUnreachableRspVld' do ##{
				assign :rAssPktType,URCHRP
				assign :rAssPktVld,1
				assign :rAssPktSrcAddr,:iUnreachableRspSrcAddr
			end ##}
		end ##}
	end ##}

	## combinational connected
	autoConnect << {
		:oAssPktType => :rAssPktType
	}


	/////////
	*/

	// select package type
	always @(posedge iClk or negedge iResetN) begin //{
		if (~iResetN) begin //{
			rAssPktType <= 6'h0;
			rAssPktVld  <= 1'b0;
			rAssPktSrcAddr <= 16'h0;
			rAssPktTargtPort <= 5'h0;
			rAssPktData <= 128'h0;
		//}
		end else begin //{
			if (iUnreachableRspVld) begin
				rAssPktType <= URCHRP;
				rAssPktVld  <= 1'b1;
				rAssPktSrcAddr <= iUnreachableRspSrcAddr;
				rAssPktTargtPort <= iUnreachableRspTargtPort;
				rAssPktData <= 128'h0;
			end else if (iUploadRspVld) begin
				rAssPktType <= UPRSP;
				rAssPktVld  <= 1'b1;
				// TODO
			end else if (iDownloadRspVld) begin
				rAssPktType <= DNRSP;
				rAssPktVld  <= 1'b1;
				// TODO
			end else if (iRefreshReqVld) begin
				rAssPktType <= RSHRQ;
				rAssPktVld  <= 1'b1;
				// TODO
			end else begin
				// clear
				rAssPktType <= 6'h0;
				rAssPktVld  <= 1'b0;
				// TODO
			end
		end //}
	end //}




endmodule //}

`undef PARAM

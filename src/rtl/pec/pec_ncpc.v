module pec_ncpc (
); // {

	// TODO, tx part?

	parameter PDW  = 256;
	parameter PIDW = 16;

	input iClk,iRstn;

	input iRxFifoRe;
	output [241:0] oRxFifoRDat;
	output oRxFifoEmpty;

	input ncp_p0RxVld;
	input [5:0] ncp_p0RxPktType;
	input [31:0] ncp_p0RxSrcIP;
	input [31:0] ncp_p0RxTargIP;
	input [PIDW-1:0] ncp_p0RxPktID;
	input [4:0] ncp_p0RxSize; // 0->1byte..1fh->32bytes
	input [PDW-1:0]  ncp_p0RxData;
	output ncp_p0RxAck;

	input ncp_p1RxVld;
	input [5:0] ncp_p1RxPktType;
	input [31:0] ncp_p1RxSrcIP;
	input [31:0] ncp_p1RxTargIP;
	input [PIDW-1:0] ncp_p1RxPktID;
	input [4:0] ncp_p1RxSize; // 0->1byte..1fh->32bytes
	input [PDW-1:0]  ncp_p1RxData;
	output ncp_p1RxAck;

	input ncp_p2RxVld;
	input [5:0] ncp_p2RxPktType;
	input [31:0] ncp_p2RxSrcIP;
	input [31:0] ncp_p2RxTargIP;
	input [PIDW-1:0] ncp_p2RxPktID;
	input [4:0] ncp_p2RxSize; // 0->1byte..1fh->32bytes
	input [PDW-1:0]  ncp_p2RxData;
	output ncp_p2RxAck;

	input ncp_p3RxVld;
	input [5:0] ncp_p3RxPktType;
	input [31:0] ncp_p3RxSrcIP;
	input [31:0] ncp_p3RxTargIP;
	input [PIDW-1:0] ncp_p3RxPktID;
	input [4:0] ncp_p3RxSize; // 0->1byte..1fh->32bytes
	input [PDW-1:0]  ncp_p3RxData;
	output ncp_p3RxAck;

	// TODO, till to p15, need support maximum 16 ncp ports.

	wire [3:0] arbSelOneHot;
	wire [241:0] arbOutData;
	wire fifoWe;
	wire fifoFull;
	wire [241:0] fifoWData;

	assign fifoWe = |arbSelOneHot;
	assign fifoWData = arbOutData;

	assign ncp_p0RxAck = (~fifoFull)&arbSelOneHot[0];
	assign ncp_p1RxAck = (~fifoFull)&arbSelOneHot[1];
	assign ncp_p2RxAck = (~fifoFull)&arbSelOneHot[2];
	assign ncp_p3RxAck = (~fifoFull)&arbSelOneHot[3];

	pec_ncpc_arb uarb (
		.iEn ({ncp_p3RxVld,ncp_p2RxVld,ncp_p1RxVld,ncp_p0RxVld}),
		// p0 set
		.iSrc0 ({ncp_p0RxPktType,ncp_p0RxSrcIP,ncp_p0RxTargIP,ncp_p0RxPktID,4'h0,ncp_p0RxData}),
		// p1 set
		.iSrc1 ({ncp_p1RxPktType,ncp_p1RxSrcIP,ncp_p1RxTargIP,ncp_p1RxPktID,4'h1,ncp_p1RxData}),
		// p2 set
		.iSrc2 ({ncp_p2RxPktType,ncp_p2RxSrcIP,ncp_p2RxTargIP,ncp_p2RxPktID,4'h2,ncp_p2RxData}),
		// p3 set
		.iSrc3 ({ncp_p3RxPktType,ncp_p3RxSrcIP,ncp_p3RxTargIP,ncp_p3RxPktID,4'h3,ncp_p3RxData}),
		.oSel(arbSelOneHot),
		.oData(arbOutData)
	);


	syncFifo8x242 rxfifo (
		.iClk  (iClk),
		.iRstn (iRstn),
		.iWe   (fifoWe),
		.iWData(fifoWData),
		.iRe   (iRxFifoRe),
		.oRData(oRxFifoRDat),
		.oFull (fifoFull),
		.oEmpty(oRxFifoEmpty)
	);



endmodule // }

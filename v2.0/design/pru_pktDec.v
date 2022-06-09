`ifndef pru_pktDec__v
`define pru_pktDec__v

/*
receive packet every cycle, decode and convert to different types,
- programming packets directed to pru_regCtrl
- connect/disconnect response from server port direct to pru_center
- upload/download request/response will be directed to pru_route
*/

module pru_pktDec(
); // {

	parameter PW=128;

	// arbIn_pktDec ports, for receiving packets to decode.
	output pktDec_arbIn_read;
	input  arbIn_pktDec_empty;
	input [PW-1:0] arbIn_pktDec_pkt;

	// pktDec_regCtrl ports, sending programming requests, reg requests
	output pktDec_regCtrl_sel;
	output pktDec_regCtrl_write;
	output [7:0]  pktDec_regCtrl_addr;
	output [31:0] pktDec_regCtrl_wdata;

	//


endmodule // }

`endif

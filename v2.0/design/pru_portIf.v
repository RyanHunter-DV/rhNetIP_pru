`ifndef pru_portIf__v
`define pru_portIf__v

// module to do port handshake actions, 

module pru_portIf(
	iClk,iRstn,
	// ports to device
	iPort_vld,
	iPort_pkt,
	iPort_ack,
	oPort_ack,
	oPort_vld,
	oPort_pkt,
	// ports to arbIn
	portIf_arbIn_vld,
	portIf_arbIn_pkt,
	arbIn_portIf_ack
); // {

	parameter PW=128;

	input iClk,iRstn;

	input iPort_vld,iPort_ack;
	input [PW-1:0] iPort_pkt;

	output oPort_vld,oPort_ack;
	output[PW-1:0] oPort_pkt;

	// ports to arbIn, send out received packets for arbitration
	//
	input  arbIn_portIf_ack;
	output portIf_arbIn_vld;
	output [PW-1:0] portIf_arbIn_pkt;


	// TODO
	// MARKER




endmodule // }

`endif

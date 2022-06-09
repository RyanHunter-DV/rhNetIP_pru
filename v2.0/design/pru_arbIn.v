`ifndef pru_arbIn__v
`define pru_arbIn__v

/*
This module will receive packets from 16 portIf, and store them
in fifo, pru_pktDec will receive packets when fifo has items, and 
read it from fifo.
*/

module pru_arbIn(
	iClk,iRstn,
	/*dass start*/
	16.times do |i|
		raw "portIf_#{i}_arbIn_vld,"
		raw "portIf_#{i}_arbIn_pkt,"
		raw "arbIn_portIf_#{i}_ack,"
	end
	/*dass end*/
	pktDec_arbIn_read,
	arbIn_pktDec_empty,
	arbIn_pktDec_pkt
); // {

	parameter PW=128;

	/*dass start*/
	16.times do |i|
		raw "input portIf_#{i}_arbIn_vld;"
		raw "input [PW-1:0] portIf_#{i}_arbIn_pkt;"
		raw "output arbIn_portIf_#{i}_ack;"
	end
	/*dass end*/

	// ports connected to pru_pktDec, 
	input  pktDec_arbIn_read;
	output arbIn_pktDec_empty;
	output [PW-1:0] arbIn_pktDec_pkt;



	// TODO




endmodule // }

`endif

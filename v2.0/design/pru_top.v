module pru_top(
	iClk,iRstn,
	/*dass start*/
	16.times do |i|
		raw "iPort_#{i}_vld,"
		raw "oPort_#{i}_ack,"
		raw "iPort_#{i}_pkt,"
		raw "oPort_#{i}_vld,"
		raw "iPort_#{i}_ack,"
		raw "oPort_#{i}_pkt,"
	end
	/*dass end*/
); // {

	parameter PW=128;

	input iClk,iRstn;

	// device ports, connect to different devices
	/*dass start*/

	16.times do |i|
		raw "input iPort_#{i}_vld;"
		raw "input [PW-1:0] iPort_#{i}_pkt;"
		raw "output oPort_#{i}_ack;"
		raw "output oPort_#{i}_vld;"
		raw "input  iPort_#{i}_ack;"
		raw "output [PW-1:0] oPort_#{i}_pkt;"
	end

	/*dass end*/


	// download/upload head packet format
	// [127:122]- pkt type
	// [121:114]- data size
	// [63:32]  - src address
	// [31:0]   - trgt address

	// port module that active handshake behavior
	/*dass start*/
	16.times do |i|
		raw "pru_portIf uport#{i}("
		raw ".iPort_vld(iPort_#{i}_vld),"
		raw ".iPort_pkt(iPort_#{i}_pkt),"
		raw ".oPort_ack(oPort_#{i}_ack),"
		raw ".oPort_vld(oPort_#{i}_vld),"
		raw ".oPort_pkt(oPort_#{i}_pkt),"
		raw ".iPort_ack(iPort_#{i}_ack),"
		raw ".portIf_arbIn_vld(portIf_#{i}_arbIn_vld),"
		raw ".portIf_arbIn_pkt(portIf_#{i}_arbIn_pkt),"
		raw ".arbIn_portIf_ack(arbIn_portIf_#{i}_ack),"
		raw ");"
	end
	/*dass end*/

	pru_portIf uport_sesrver(
		.iPort_vld(iPort_server_vld),
		.iPort_pkt(iPort_server_pkt),
		.oPort_ack(oPort_server_ack),
		.oPort_vld(oPort_server_vld),
		.oPort_pkt(oPort_server_pkt),
		.iPort_ack(iPort_server_ack),
		.portIf_arbIn_vld(portIf_arbIn_server_vld),
		.portIf_arbIn_pkt(portIf_arbIn_server_pkt),
		.arbIn_portIf_ack(arbIn_portIf_server_ack)
	);



	pru_arbIn uarbIn(
		// port from uport*
	);



endmodule // }

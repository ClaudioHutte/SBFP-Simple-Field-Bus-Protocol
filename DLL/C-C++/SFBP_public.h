

/**************************************************************************************

   SIMPLE FIELD BUS PROTOCOL CONSTANTS
   ===================================
   Public library for linking SFBP.DLL
   This library contains only definitions and structures.
   
	  SFBP Protocol Library
	  =====================

	  Copyright (c) 2004 Claudio H. Ghiotto - Soft&Media

	  This software is provided 'as-is', without any express or implied warranty.
	  In no event will the authors be held liable for any damages arising from the use of this software.

	  Permission is granted to anyone to use this software for any purpose,
	  including commercial applications, and to alter it and redistribute it freely,
	  subject to the following restrictions:

	  1. The origin of this software must not be misrepresented;
		 you must not claim that you wrote the original software.
		 If you use this software in a product, an acknowledgment in the product
		 documentation or UI is appreciated but not required.

	  2. Altered source versions must be plainly marked as such,
		 and must not be misrepresented as being the original software.

	  3. This notice may not be removed or altered from any source distribution.

	  4. If a product uses the Software, it is recommended that the “SFBP” logo 
		 be displayed in a visible location. The logo is provided free of charge 
		 and available for use under the same license terms.


***************************************************************************************/

#define BROADCASTADDR		0				// broadcast address is zero
#define STARTMARKER			254		  	  	// packet start marker byte
#define TYPE_DATAGRAM		1
#define TYPE_CONNECTED		0
#define TYPE_STREAM			2				// similar to TYPE_CONNECTED but makes use of the NEXT bit in packets for firmware versions equal or above to 1.x

#define PDU		6		// PDU (message payload data unit) definition in emulator
#define PKDU	11		// Packed Data Unit

// base packet
///////////////////////////////////////////////
struct _BasePacket {
	unsigned char srcAddr;
	unsigned char destAddr;
	unsigned char pckinfo;
	unsigned char status;
	unsigned char chk;
	unsigned char calcChk;
	unsigned char datalen;
	unsigned char progrlen;
};


#define RETRYSENDCOUNT          5       // number of time to retry send on failure
#define WAITBEFORERETRYSEND		25//5	// milliseconds to wait between attempt of send on failure

#define PACKETWIDTH			56//	14	// milliseconds to wait after a addressed heading frame of a packet has been received

//#define ACKREPLYTIMEOUT			50	// milliseconds to wait before timeout ack reply @9600bps
#define ACKREPLYTIMEOUT			25	// milliseconds to wait before timeout ack reply @19200bps
// gPacketTimeout is related to the sum of ACKREPLYTIMEOUT with PACKETWIDTH

#define TIMEWAITONBUSY		300			// milliseconds to wait after a failure in send because channel busy

// transmission control
#define OPCODE_ACK		0x10	// localize the bit set if ACK is set, not set is SYN
#define OPCODE_NEXT 	0x08	// localize the bit set if NEXT is set, not set is LAST

// opcode options
//   bit 3-2-1 (8 options):
//       0   reserved
//       1   control packet
//		 2   data packet
//		 3   time set
//		 4   time get
//       5   reserved
//       6   system packet (see remarks and limits)
//       7   reserved
#define OPCODE_ECHO						0
#define OPCODE_CTRL_PACKET 		   		1
#define OPCODE_DATA_PACKET				2
#define OPCODE_TIME_SET					3
#define OPCODE_TIME_GET					4
#define OPCODE_SYSTEM					6
//
//
#define PCK_CTRL_LONLY                  0x20    // this is the only one packet or last packet of a series
#define PCK_CTRL_REQRPLY                0x02    // requires reply, if not set packet is intended as a datagram
// remark: when both PCK_CTRL_LONLY and PCK_CTRL_REQRPLY are set and datalen is zero a PING must be performed,
//         when only PCK_CTRL_LONLY and datalen are zero then packet has ACKnowledge meaningful.
#define PCK_CTRL_ERR                    0x04    // error while receiving packet
//#define PCK_CTRL_                     0x08    // reserved
//#define PCK_CTRL_                     0x10    // reserved
#define PCK_CTRL_PARITY                 0x01    // parity, if set sum of four received bytes must be even.
// internal status - these bits are not available on the real transmitted packet
#define PCK_calcparity                  0x40    // calculated parity, useful to be compared with PCK_CTRL_PARITY
//
// packet status
////////////////
#define FFL_VOID                        0    // when whole status is zero then packet is still empty
#define FFL_srcAddrOK                   1    // source address received
#define FFL_destAddrOK                  2    // dest address received
#define FFL_LObyteOK                    3    // first low byte received
#define FFL_basepacketOK                4    // high byte received (so base packet is fully received)
#define FFL_CRClow                      5    // low order byte of CRC received

////////////////
//#define DS_TXON							0x01	// character is trasmitting
#define DS_RECEIVING					0x0002	// busy in receive (used in _DoTasks() )
#define DS_WAITINGACK  					0x0004	// awaiting for ack
#define DS_SENDING						0x0008	// busy to send
#define DS_ACKOK						0x0010	// reply by remote peer with ACK
#define DS_RCVBUFREADY					0x0020	// a char is available in the UDR register

#define DS_CHECKECHO					0x0040	// must check echo
//#define DS_...						0x0080	// free
#define DS_ECHOOK						0x0100	// echo received ok
// specific for the windows driver nsccom
#define DS_WAIT_FIRMWAREINFO			0x0200	// wait personalizzato
#define DS_WAIT_CTRLOK					0x0400
#define DS_WAIT_ERRINFO					0x0800
#define DS_WAIT_RESPONSE				0x1000
#define DS_WAIT_ECHO					0x2000
#define DS_WAITINGFOR_CTRLOK			0x4000


#define RCV_MODE_on                  0x02  // device is listening for incoming data


////////////////////////////
// indexes of data in packet
////////////////////////////
#define PI_STARTMARKER	0
#define PI_DESTADDR		1
#define PI_SRCADDR		2
#define PI_OPCODE		3
#define PI_CHKCTRLPCK	4	// checksum of control packet (SFBP 2)
#define PI_DATAOFFSET	4
#define PI_CHKSUM		10
////////////////////////////

// initialization of checksum
#define INITCHK			23
#define INITCHKROT		46	// checksum first process

///////////////////////////////////////////////////////////////////////////////////////////////////////
// PREDEFINED TYPES OF MESSAGES (CONTROL TYPE PACKETS)
//////////////////////////////////////////////////////
// CTRLTYPE 0: if a control type value is zero then treat as no control packet, instead data packet
#define CTRLTYPE_USER_DATA	0		// user defined or system packet with meaning of data packet (not ctrl packet)
//
#define CTRLTYPE_SETTARGET	1		// set target where to send ctrl packets (see sendtarget as well)
#define CTRLTYPE_SETOUT		2		// set output with received first two bytes as data and following two bytes as mask
#define CTRLTYPE_DUMPERR	5		// send back the error stored in eeprom, if any
#define CTRLTYPE_GETIN		6		// send back the last status of inputs
#define CTRLTYPE_GETOUT		7		// send back the last status of outputs
#define CTRLTYPE_RPC_0PARAM	8		// remote procedure call, zero parameters
#define CTRLTYPE_RPC_MAXPARAM	12	// max count of arguments for RPC equal to CTRLTYPE_RPC_0PARAM+4 
#define CTRLTYPE_SYSTEM		0x80	// bit set used for system controls (see below and see function SendCTRL)
									// packet sent via SendCTRL with the highest bit set are considered as 
									// NON System but interpreted to be sent as datagrams.
// till 42 reserved space
#define	CTRLTYPE_USER		43		// user defined ctrl packets, connected - available range: CTRLTYPE_USER + 84
#define CTRLTYPE_USERD		141		// user defined ctrl packets, datagram - available range: CTRLTYPE_USERD + 84
//
// 226 and up, system packets as the followings:
#define CTRLTYPE_SETSERIAL	240		// set the serial code (only in non SMALL)
#define CTRLTYPE_GETSTORE	241		// send back 5 byte of data stored in eeprom memory, beginning from the location specified by the first two bytes (LSB, MSB); the byte 5 returned hold the length of data (0 to 5)
#define CTRLTYPE_OK			242		// sent in response to a sequenced operation such as the one required by CTRLTYPE_STORE
#define CTRLTYPE_STORE		243		// require to store following data packets in eeprom
#define CTRLTYPE_PRGSTATE	244		// reprogram responde, only if PFLASH is defined (program in flash)
#define CTRLTYPE_RSTADDR	245		// reset address to null
#define CTRLTYPE_LNGCLICKSTATE	246		// as for CTRLTYPE_INSTATE
#define CTRLTYPE_CLICKSTATE	247		// as for CTRLTYPE_INSTATE
#define CTRLTYPE_INSTATE	248		// in response to getin (or for settarget) a packet with this type is returned
#define CTRLTYPE_OUTSTATE	249		// on out change if settarget has been set, or in response to a getout, a packet with this type is returned
#define CTRLTYPE_GETSERIAL	250		// send back the serial number and current address
#define CTRLTYPE_SETADDR	251		// set address by serial number
#define CTRLTYPE_CLEARERR	252		// clear error block memory
#define CTRLTYPE_REPROGRAM	253		// set to program memory with next received data packets, data specify how many packets are expected
#define CTRLTYPE_REBOOT		254		// reboot device if first byte is set to 55, otherwise it stop user program (and can only be resumed by a reboot)
//////////////////////////////////////





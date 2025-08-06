/* **************************************************************************** *\
	SFBP INCLUDE LIBRARY
	====================
	(C)2004 Claudio H. G. - Soft&Media
	
	Public library for linking SFBP.DLL
	This library contains only definitions, structures and the exported function prototypes.

	  This software is provided 'as-is', without any express or implied warranty.
	  In no event will the authors be held liable for any damages arising from the
	  use of this software.

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
	
	
	Company: Soft&Media
	Language: C
	
	This file is designed to be included in other projects that use SFBP.dll
	
	It is derived from the nsccom1.h header, stripped of the private sections.
	
\* **************************************************************************** */


/* 
	NSC Interpreter specific error codes.
	-------------------------------------
	You can respond with these error codes in the NSC OS w/out interpreter.
*/
#define	errSTACKOVERFLOW		1
#define	errSTACKUNDERFLOW		2	// math stack errors
//old	errSubscriptOutOfRange	3
#define errUNRECOGNIZEDSTATEMNT	4
#define errOUTOFMEMORY			5
#define errOutOfFunctionStack	6
#define errStackOverFlowed		7	// memory stack overflow: not math stack!
#define errRcvProgramError		8
#define errFLASHFAIL			9
#define errACCESSVIOLATION		10
#define errINVALIDPROGRAM		11
#define errFLASHFAILURE			13
#define errUNRECOVERABLE		19	// max error number below of it any error is considered as unrecoverable
#define errDivisionByZero		20
#define errRPCFailed			21
#define	errSubscriptOutOfRange	22
#define errREADDRESS			240	// not an error, set when a readdressing is issued, this error is resetted if a new program is then uploaded
#define errVirgin1				254 // virgin device, serial code has been set, never programmed.
#define errVIRGIN				255 // <== this mean no error was written to eeprom and is interpreted as VIRGIN device!


const struct ERRTABLE {
	unsigned char errcode;
	char *errstring;
}
Errors[] = 
{
/*	error code							error string			*/
/*	----------							------------			*/
	0								,	"No errors",
	errUNRECOGNIZEDSTATEMNT			,	"Unrecognized Statement",
	3								,	"Subscript out of range",		// used in version below 0.9
	errSTACKUNDERFLOW				,	"Math stack underflow",
	errStackOverFlowed				,	"Out of Memory: stack overflowed",
	errSTACKOVERFLOW				,	"Math stack overflow",
	errRcvProgramError				,	"Reprogram error",
	errOUTOFMEMORY					,	"Out of memory",
	errOutOfFunctionStack			,	"Out of function stack: too nested function calls",
	errREADDRESS					,	"STOPPED",
	errDivisionByZero				,	"Division by zero",
	errRPCFailed					,	"RPC failed",
	errSubscriptOutOfRange			,	"Subscript out of range",
	errFLASHFAIL					,	"Flash programming error: bad address",
	errFLASHFAILURE					,	"Flash failure! Flash memory can\'t be written",
	errACCESSVIOLATION				,	"Memory access violation",
	errINVALIDPROGRAM				,	"Invalid program or not programmed",
	errVirgin1						,	"Virgin device",
	errVIRGIN						,	"Virgin device, MISSING SERIAL CODE!"
};
const int errTableCount = sizeof(Errors) / sizeof(ERRTABLE);
/* END OF NSC SPECIFIC ERROR CODES */

enum PROGRAMERRORS {
	PRGERR_NONE				=0,
	PRGERR_BADCALL			=1,
	PRGERR_COMCLOSED		=2,
	PRGERR_NETWORKFAILURE	=3,
	PRGERR_NORESPONSE		=4,
	PRGERR_SERIALMISMATCH	=5,
	PRGERR_INVALIDTARGET	=6,
	PRGERR_NOTSUPPORTED		=7,
	PRGERR_CHANNELBUSY		=8
} ;

enum ADAPTERIDS {
	NSC_ADAPTER_SIMPLE		= 0,
	NSC_ADAPTER_FAST		= 1
} ;

enum PROTOCOLS {
	PROTO_SFBP_1	=	1,
	PROTO_SFBP_2	=	2
} ;

enum SENDRESULTS {
	SEND_FAILED			=	0,
	SEND_OK 			=	1,
	SEND_BUSY			=	2,
	SEND_DEVICECLOSED	=	16,
	SEND_BADCALL		=	99
} ;


// enumerates actions made through _DoRemoteAction()
//
enum ACTIONLIST {
	ACTL_REBOOT,
	ACTL_CLEARERR,
	ACTL_STOP,
	ACTL_SETADDR,
	ACTL_RESETCOMM,
	ACTL_REPROGRAM
};

// exported functions
	long __stdcall IsOpen(void);
	void __stdcall SetProtocol(long nNewValue);
	void __stdcall SetClientHWND(long nNewValue);
	long __stdcall GetLastProgramError(void);
	long __stdcall GetEchoCheck(void);
	void __stdcall SetEchoCheck(short bNewValue);
	void __stdcall CloseCOM(void);
	void __stdcall SaveSettings();
	void __stdcall SetInt(short value, short index);
	void __stdcall SetByte(short value, short index);
	void __stdcall ClearBuffer(void);
	void __stdcall SetOut(short outIndex, short outValue);
	short __stdcall GetInt(long pBuf, short index);
	short __stdcall GetByte(long pBuf, short index);
	short __stdcall GetType(long pBuf);
	long __stdcall SendData(short destAddress, long packetMode, long opcode, long lpData, short cbData);
	long __stdcall MakeMap(void);
	long __stdcall Send(short destAddress, long msgType, long packetMode);
	long __stdcall GetFirmwareInfo(short Address);
	long __stdcall GetRemoteError(short Address);
	long __stdcall ClearRemoteError(short Address);
	long __stdcall Reboot(short Address);
	long __stdcall Stop(short Address);
	long __stdcall ResetComm(short Address);
	long __stdcall Program(LPCTSTR Serial, short Address, short devID, short versmin, short versmaj, long lpData, long cbData);
	long __stdcall Query(short Address, long lpData, short silent, short queryID);
	void __stdcall SetType(short type);
	long __stdcall Restart(void);
	long __stdcall ProgramDirect(LPCTSTR Serial, short Address, short devID, short versmin, short versmaj, long lpData, long cbData);
	long __stdcall SetAddrID(LPCTSTR Serial, short Address, short progress);
	long __stdcall OpenCOM(long hWnd);
	long __stdcall TestStream(short data, short size);
	long __stdcall sendRaw(long lpData, long datalen, short* chk, short FirstIsStartMarker);


	void __stdcall SetRXbuffer(short RXb); 
	void __stdcall SetTXbuffer(short TXb);
	void __stdcall SetCOMPort(short port);
	void __stdcall SetBps(long bps);
	void __stdcall SetFrameSize(short framesize);
	void __stdcall SetSpy(short spymode);
	void __stdcall SetLocalAddress(short addr);
	void __stdcall SetAdapterID(long adapterID) ;
	void __stdcall SetAutoEcho(short autoecho);
	void __stdcall MapAbort(void) ;
	void __stdcall SetNoAck(short noack); 
	void __stdcall SetPacketTimeout(short pckTimeout);
	void __stdcall SetBusyTimeout(short busytimeout);
	void __stdcall FreezeEvents(short bFreeze);
	void __stdcall SetResponseMsg(long respMsg);
	void __stdcall SetNoErrMsgBox(short noErrMsgBox);


	long __stdcall copystring(char* src, char* dest, long size);


	typedef void (__stdcall *pFireCOMerror)(); 
	typedef void (__stdcall *pFireDataReady)(short srcAddress, short destAddress, short datalen, short msgType, long pBuf, long pckType);
	typedef void (__stdcall *pFireMapProgress)(short level);
	typedef void (__stdcall *pFireMap)(short Address, LPCTSTR Serial, short devID, short MinorVersion, short MajorVersion);
	typedef void (__stdcall *pFireFirmwareInfo)(short Address, void* Serial, short devID, void* Device, short MinorVersion, short MajorVersion, void* Version);
	typedef void (__stdcall *pFireRemoteError)(short Address, short ErrorCode, LPCTSTR ErrorString);
	typedef void (__stdcall *pFireProgramProgress)(short level, LPCTSTR status);
	typedef void (__stdcall *pFireQueryReply)(short Address, long lpData, short queryID);
	typedef void (__stdcall *pFireProgramCompleted)();
	typedef void (__stdcall *pFireNetError)(short ErrCode, LPCTSTR ErrMsg);

	void __stdcall SetCallbackEvents(
										pFireCOMerror			mFireCOMerror,
										pFireDataReady			mFireDataReady,
										pFireMapProgress		mFireMapProgress,
										pFireMap				mFireMap,
										pFireFirmwareInfo		mFireFirmwareInfo,
										pFireRemoteError		mFireRemoteError,
										pFireProgramProgress	mFireProgramProgress,
										pFireQueryReply			mFireQueryReply,
										pFireProgramCompleted	mFireProgramCompleted,
										pFireNetError			mFireNetError
									);

	//////////////////////////////////////////
	// return common default settings
	long __stdcall getSpy();
	short __stdcall getLocalAddr();
	long __stdcall getNoAck();
	long __stdcall getAutoEcho();
	long __stdcall getAdapterID();
	short __stdcall getPacketTimeout();
	short __stdcall getBusyTimeout();
	
	short __stdcall GetRXbuffer();
	short __stdcall GetTXbuffer();
	short __stdcall GetCOMPort();
	long __stdcall GetBps();
	short __stdcall GetFrameSize();
	//////////////////////////////////////////



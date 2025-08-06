/*
  SFBP Protocol Support Library
  =============================

  Copyright (c) 2004 Claudio H. G. - Soft&Media
			(c) 2025 Claudio H. G.

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

*/

using System;
using System.Runtime.InteropServices;
using System.Text;

namespace MyProject.Helpers
{
    public static class NSCCOMhelper
    {
		
        public static int mApplicationPort;
        public static int mDefaultPort;

        public enum PacketType
        {
            None = 0,
            Data = 1,
            Ctrl = 2,
            Echo = 4,
            TimeGet = 5,
            TimeSet = 6,
            DataEven = 7
        }

        public enum BitPerSeconds
        {
            Bps9600 = 9600,
            Bps14400 = 14400,
            Bps19200 = 19200,
            Bps38400 = 38400,
            Bps57600 = 57600
        }

        public enum AdapterID
        {
            Simple = 0,
            Fast = 1
        }

        public enum PacketMode
        {
            Connected = 0,
            Datagram = 1,
            Stream = 2
        }

        public enum OpCodes
        {
            Echo = 0,
            CtrlPacket = 1,
            DataPacket = 2,
            TimeSet = 3,
            TimeGet = 4,
            System = 6
        }

        public enum SendResult
        {
            Failed = 0,
            Ok = 1,
            Busy = 2,
            DeviceClosed = 16,
            BadCall = 99
        }

        public enum CtrlTypes
        {
            SetTarget = 1,
            SetOut = 2,
            DumpErr = 5,
            GetIn = 6,
            GetOut = 7,
            User = 43,
            UserDatagram = 141,
            LongClickState = 246,
            ClickState = 247,
            InState = 248,
            OutState = 249
        }

        public enum RespMsgs
        {
            DisableResponse = 0,
            CtrlTypeOk = 242
        }

        public enum Proto
        {
            SFBP1 = 1,
            SFBP2 = 2
        }

        public enum ProgramErrors
        {
            None = 0,
            BadCall = 1,
            ComClosed = 2,
            NetworkFailure = 3,
            NoResponse = 4,
            SerialMismatch = 5
        }

		// Function prototypes
		// ===================
		private const string DllName = "SFBP.dll"; // Ensure it's accessible

		// Basic status/control
		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern int IsOpen();

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void SetProtocol(int newValue);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void SetClientHWND(int hwnd);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern int GetLastProgramError();

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern int GetEchoCheck();

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void SetEchoCheck(short value);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern int OpenCOM(int hWnd);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void CloseCOM();

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void SaveSettings();

		// Data Transfer and Buffers
		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void SetInt(short value, short index);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void SetByte(short value, short index);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void ClearBuffer();

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void SetOut(short outIndex, short outValue);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern short GetInt(IntPtr pBuf, short index);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern short GetByte(IntPtr pBuf, short index);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern short GetType(IntPtr pBuf);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern int SendData(short destAddress, int packetMode, int opcode, IntPtr data, short cbData);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern int Send(short destAddress, int msgType, int packetMode);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern int SendRaw(IntPtr data, int datalen, ref short chk, short firstIsStartMarker);

		// Firmware / Device Communication
			[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern int GetFirmwareInfo(short address);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern int GetRemoteError(short address);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern int ClearRemoteError(short address);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern int Reboot(short address);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern int Stop(short address);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern int ResetComm(short address);

		// Programming
		[DllImport(DllName, CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Ansi)]
		public static extern int Program(string serial, short address, short devID, short versmin, short versmaj, IntPtr data, int cbData);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Ansi)]
		public static extern int ProgramDirect(string serial, short address, short devID, short versmin, short versmaj, IntPtr data, int cbData);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Ansi)]
		public static extern int SetAddrID(string serial, short address, short progress);

		// Queries and Maps
		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern int Query(short address, IntPtr lpData, short silent, short queryID);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void SetType(short type);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern int Restart();

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern int MakeMap();

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void MapAbort();

		// COM Port and IO Settings
		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern int TestStream(short data, short size);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void SetRXbuffer(short value);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void SetTXbuffer(short value);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void SetCOMPort(short port);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void SetBps(int bps);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void SetFrameSize(short size);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void SetSpy(short mode);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void SetLocalAddress(short addr);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void SetAdapterID(int adapterID);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void SetAutoEcho(short autoEcho);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void SetNoAck(short noAck);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void SetPacketTimeout(short timeout);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void SetBusyTimeout(short timeout);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void FreezeEvents(short freeze);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void SetResponseMsg(int respMsg);

		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void SetNoErrMsgBox(short noMsgBox);

		// Utilities
		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern int CopyString(byte[] src, byte[] dest, int size);

		// Delegate Declarations for Callbacks
		// Use these if the DLL expects function pointers (callbacks) to be registered.
		[UnmanagedFunctionPointer(CallingConvention.StdCall)]
		public delegate void FireCOMError();

		[UnmanagedFunctionPointer(CallingConvention.StdCall)]
		public delegate void FireDataReady(short srcAddr, short destAddr, short dataLen, short msgType, IntPtr pBuf, int pckType);

		[UnmanagedFunctionPointer(CallingConvention.StdCall)]
		public delegate void FireMapProgress(short level);

		[UnmanagedFunctionPointer(CallingConvention.StdCall, CharSet = CharSet.Ansi)]
		public delegate void FireMap(short address, string serial, short devID, short minorVersion, short majorVersion);

		[UnmanagedFunctionPointer(CallingConvention.StdCall)]
		public delegate void FireFirmwareInfo(short address, IntPtr serial, short devID, IntPtr device, short minorVersion, short majorVersion, IntPtr version);

		[UnmanagedFunctionPointer(CallingConvention.StdCall, CharSet = CharSet.Ansi)]
		public delegate void FireRemoteError(short address, short errorCode, string errorStr);

		[UnmanagedFunctionPointer(CallingConvention.StdCall, CharSet = CharSet.Ansi)]
		public delegate void FireProgramProgress(short level, string status);

		[UnmanagedFunctionPointer(CallingConvention.StdCall)]
		public delegate void FireQueryReply(short address, IntPtr lpData, short queryID);

		[UnmanagedFunctionPointer(CallingConvention.StdCall)]
		public delegate void FireProgramCompleted();

		[UnmanagedFunctionPointer(CallingConvention.StdCall, CharSet = CharSet.Ansi)]
		public delegate void FireNetError(short errorCode, string errorMessage);


		// Registration of callbacks
		[DllImport(DllName, CallingConvention = CallingConvention.StdCall)]
		public static extern void SetCallbackEvents(
			FireCOMError mFireCOMerror,
			FireDataReady mFireDataReady,
			FireMapProgress mFireMapProgress,
			FireMap mFireMap,
			FireFirmwareInfo mFireFirmwareInfo,
			FireRemoteError mFireRemoteError,
			FireProgramProgress mFireProgramProgress,
			FireQueryReply mFireQueryReply,
			FireProgramCompleted mFireProgramCompleted,
			FireNetError mFireNetError
		);



    }
}

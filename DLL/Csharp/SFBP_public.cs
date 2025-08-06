/*
  SFBP Protocol Library
  =====================

  Copyright (c) 2004 Claudio H. Ghiotto - Soft&Media
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

namespace SFBP
{
    public static class ProtocolConstants
    {
        // Address and Packet Types
        public const byte BROADCASTADDR = 0;
        public const byte STARTMARKER = 254;
        public const byte TYPE_DATAGRAM = 1;
        public const byte TYPE_CONNECTED = 0;
        public const byte TYPE_STREAM = 2;

        public const int PDU = 6;
        public const int PKDU = 11;

        // Retry and timing
        public const int RETRYSENDCOUNT = 5;
        public const int WAITBEFORERETRYSEND = 25; // ms
        public const int PACKETWIDTH = 56;         // ms
        public const int ACKREPLYTIMEOUT = 25;     // ms
        public const int TIMEWAITONBUSY = 300;     // ms

        // Opcodes
        public const byte OPCODE_ACK = 0x10;
        public const byte OPCODE_NEXT = 0x08;

        public const byte OPCODE_ECHO = 0;
        public const byte OPCODE_CTRL_PACKET = 1;
        public const byte OPCODE_DATA_PACKET = 2;
        public const byte OPCODE_TIME_SET = 3;
        public const byte OPCODE_TIME_GET = 4;
        public const byte OPCODE_SYSTEM = 6;

        // Packet Control Flags
        public const byte PCK_CTRL_LONLY = 0x20;
        public const byte PCK_CTRL_REQRPLY = 0x02;
        public const byte PCK_CTRL_ERR = 0x04;
        public const byte PCK_CTRL_PARITY = 0x01;
        public const byte PCK_calcparity = 0x40;

        // Packet Status Flags
        public const byte FFL_VOID = 0;
        public const byte FFL_srcAddrOK = 1;
        public const byte FFL_destAddrOK = 2;
        public const byte FFL_LObyteOK = 3;
        public const byte FFL_basepacketOK = 4;
        public const byte FFL_CRClow = 5;

        // Device States
        public const ushort DS_RECEIVING = 0x0002;
        public const ushort DS_WAITINGACK = 0x0004;
        public const ushort DS_SENDING = 0x0008;
        public const ushort DS_ACKOK = 0x0010;
        public const ushort DS_RCVBUFREADY = 0x0020;
        public const ushort DS_CHECKECHO = 0x0040;
        public const ushort DS_ECHOOK = 0x0100;
        public const ushort DS_WAIT_FIRMWAREINFO = 0x0200;
        public const ushort DS_WAIT_CTRLOK = 0x0400;
        public const ushort DS_WAIT_ERRINFO = 0x0800;
        public const ushort DS_WAIT_RESPONSE = 0x1000;
        public const ushort DS_WAIT_ECHO = 0x2000;
        public const ushort DS_WAITINGFOR_CTRLOK = 0x4000;

        public const byte RCV_MODE_on = 0x02;

        // Packet Indexes
        public const int PI_STARTMARKER = 0;
        public const int PI_DESTADDR = 1;
        public const int PI_SRCADDR = 2;
        public const int PI_OPCODE = 3;
        public const int PI_CHKCTRLPCK = 4;
        public const int PI_DATAOFFSET = 4;
        public const int PI_CHKSUM = 10;

        // Checksum Init
        public const byte INITCHK = 23;
        public const byte INITCHKROT = 46;

        // Control Types
        public const byte CTRLTYPE_USER_DATA = 0;
        public const byte CTRLTYPE_SETTARGET = 1;
        public const byte CTRLTYPE_SETOUT = 2;
        public const byte CTRLTYPE_DUMPERR = 5;
        public const byte CTRLTYPE_GETIN = 6;
        public const byte CTRLTYPE_GETOUT = 7;
        public const byte CTRLTYPE_RPC_0PARAM = 8;
        public const byte CTRLTYPE_RPC_MAXPARAM = 12;
        public const byte CTRLTYPE_SYSTEM = 0x80;

        public const byte CTRLTYPE_USER = 43;
        public const byte CTRLTYPE_USERD = 141;

        public const byte CTRLTYPE_SETSERIAL = 240;
        public const byte CTRLTYPE_GETSTORE = 241;
        public const byte CTRLTYPE_OK = 242;
        public const byte CTRLTYPE_STORE = 243;
        public const byte CTRLTYPE_PRGSTATE = 244;
        public const byte CTRLTYPE_RSTADDR = 245;
        public const byte CTRLTYPE_LNGCLICKSTATE = 246;
        public const byte CTRLTYPE_CLICKSTATE = 247;
        public const byte CTRLTYPE_INSTATE = 248;
        public const byte CTRLTYPE_OUTSTATE = 249;
        public const byte CTRLTYPE_GETSERIAL = 250;
        public const byte CTRLTYPE_SETADDR = 251;
        public const byte CTRLTYPE_CLEARERR = 252;
        public const byte CTRLTYPE_REPROGRAM = 253;
        public const byte CTRLTYPE_REBOOT = 254;
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    public struct BasePacket
    {
        public byte srcAddr;
        public byte destAddr;
        public byte pckinfo;
        public byte status;
        public byte chk;
        public byte calcChk;
        public byte datalen;
        public byte progrlen;
    }
}

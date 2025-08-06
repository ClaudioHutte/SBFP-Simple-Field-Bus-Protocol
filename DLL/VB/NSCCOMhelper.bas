Attribute VB_Name = "NSCCOMhelper"
Option Explicit

'
'  SFBP Protocol Support Library
'  =============================
'
'  Copyright (c) 2004 Claudio Ghiotto - Soft&Media
'
'  This software is provided 'as-is', without any express or implied warranty.
'  In no event will the authors be held liable for any damages arising from the use of this software.
'
'  Permission is granted to anyone to use this software for any purpose,
'  including commercial applications, and to alter it and redistribute it freely,
'  subject to the following restrictions:
'
'  1. The origin of this software must not be misrepresented;
'     you must not claim that you wrote the original software.
'     If you use this software in a product, an acknowledgment in the product
'     documentation or UI is appreciated but not required.
'
'  2. Altered source versions must be plainly marked as such,
'     and must not be misrepresented as being the original software.
'
'  3. This notice may not be removed or altered from any source distribution.
'
'  4. If a product uses the Software, it is recommended that the “SFBP” logo 
'     be displayed in a visible location. The logo is provided free of charge 
'     and available for use under the same license terms.
'


#If NSCCOMHLPR_USE_CLASS Then
Private m_NSCCOM As INsccom
#Else
Private m_NSCCOM As Form1	' replace with name of your main form
#End If

Public mApplicationPort As Integer
Public mDefaultPort As Integer

Public Enum enumPacketType
    PCK_TYPE_NONE = 0
    PCK_TYPE_DATA = 1
    PCK_TYPE_CTRL = 2
    PCK_TYPE_ECHO = 4
    PCK_TYPE_TIMEGET = 5
    PCK_TYPE_TIMESET = 6
    PCK_TYPE_DATAEVEN = 7
End Enum

Public Enum enumBitPerSeconds
    BPS9600 = 9600
    BPS14400 = 14400
    BPS19200 = 19200
    BPS38400 = 38400
    BPS57600 = 57600
End Enum

Public Enum enumAdapterID
    NSC_ADAPTER_SIMPLE = 0
    NSC_ADAPTER_FAST = 1
End Enum


Public Enum enumPacketMode
    MODE_CONNECTED = 0
    MODE_DATAGRAM = 1
    MODE_STREAM = 2
End Enum

Public Enum enumOpCodes
    OPCODE_ECHO = 0
    OPCODE_CTRL_PACKET = 1
    OPCODE_DATA_PACKET = 2
    OPCODE_TIME_SET = 3
    OPCODE_TIME_GET = 4
    OPCODE_SYSTEM = 6
End Enum

Public Enum enumSendResult
    SEND_FAILED = 0
    SEND_OK = 1
    SEND_BUSY = 2
    SEND_DEVICECLOSED = 16
    SEND_BADCALL = 99
End Enum

Public Enum enumCTRLTYPES
    CTRLTYPE_SETTARGET = 1     ' set target where to send ctrl packets (see sendtarget as well)
    CTRLTYPE_SETOUT = 2      ' set output with received first two bytes as data and following two bytes as mask
    CTRLTYPE_DUMPERR = 5     ' send back the error stored in eeprom if any
    CTRLTYPE_GETIN = 6       ' send back the last status of inputs
    CTRLTYPE_GETOUT = 7      ' send back the last status of outputs
    'CTRLTYPE_INSTATE  = 7    ' in response to getin a packet with this type is returned
    CTRLTYPE_USER = 43     ' base for user's defined message types
    CTRLTYPE_USER_DGRAM = 141    ' base for user's defined message types for datagrams
    CTRLTYPE_LNGCLICKSTATE = 246   ' as for CTRLTYPE_INSTATE
    CTRLTYPE_CLICKSTATE = 247    ' as for CTRLTYPE_INSTATE
    CTRLTYPE_INSTATE = 248     ' in response to getin (or for settarget) a packet with this type is returned
    CTRLTYPE_OUTSTATE = 249
End Enum

Public Enum enumRespMsgs
    DISABLE_RESPONSE = 0
    RESP_CTRLTYPE_OK = 242    ' sent in response to a sequenced operation such as the one required by CTRLTYPE_STORE
End Enum

Public Enum enumProto
    PROTO_SFBP_1 = 1
    PROTO_SFBP_2 = 2
End Enum

Public Enum enumProgramErrors
    PRGERR_NONE = 0
    PRGERR_BADCALL = 1
    PRGERR_COMCLOSED = 2
    PRGERR_NETWORKFAILURE = 3
    PRGERR_NORESPONSE = 4
    PRGERR_SERIALMISMATCH = 5
    PRGERR_INVALIDTARGET = 6
    PRGERR_NOTSUPPORTED = 7
    PRGERR_CHANNELBUSY = 8
End Enum

Public Declare Function GetInt Lib "SFBP232.dll" (ByVal pBuf As Long, ByVal Index As Integer) As Integer
Public Declare Function GetByte Lib "SFBP232.dll" (ByVal pBuf As Long, ByVal Index As Integer) As Integer
Public Declare Function GetType Lib "SFBP232.dll" (ByVal pBuf As Long) As Integer

Public Declare Function IsOpen Lib "SFBP232.dll" () As Long
Public Declare Function GetLastProgramError Lib "SFBP232.dll" () As Long
Public Declare Function GetEchoCheck Lib "SFBP232.dll" () As Long
Public Declare Function SendData Lib "SFBP232.dll" (ByVal destAddress As Integer, ByVal packetMode As Long, ByVal opcode As Long, ByVal lpData As Long, ByVal cbData As Integer) As Long
Public Declare Function MakeMap Lib "SFBP232.dll" () As Long
Public Declare Function Send Lib "SFBP232.dll" (ByVal destAddress As Integer, ByVal msgType As Long, ByVal packetMode As Long) As Long
Public Declare Function GetFirmwareInfo Lib "SFBP232.dll" (ByVal Address As Integer) As Long
Public Declare Function GetRemoteError Lib "SFBP232.dll" (ByVal Address As Integer) As Long
Public Declare Function ClearRemoteError Lib "SFBP232.dll" (ByVal Address As Integer) As Long
Public Declare Function Reboot Lib "SFBP232.dll" (ByVal Address As Integer) As Long
Public Declare Function StopDevs Lib "SFBP232.dll" Alias "Stop" (ByVal Address As Integer) As Long
Public Declare Function ResetComm Lib "SFBP232.dll" (ByVal Address As Integer) As Long
Public Declare Function Program Lib "SFBP232.dll" (ByVal Serial As String, ByVal Address As Integer, ByVal devID As Integer, ByVal versmin As Integer, ByVal versmaj As Integer, ByVal lpData As Long, ByVal cbData As Long) As Long
Public Declare Function Query Lib "SFBP232.dll" (ByVal Address As Integer, ByVal lpData As Long, ByVal silent As Integer, ByVal queryID As Integer) As Long

Public Declare Function Restart Lib "SFBP232.dll" () As Long
Public Declare Function ProgramDirect Lib "SFBP232.dll" (ByVal Serial As String, ByVal Address As Integer, ByVal devID As Integer, ByVal versmin As Integer, ByVal versmaj As Integer, ByVal lpData As Long, ByVal cbData As Long) As Long
Public Declare Function SetAddrID Lib "SFBP232.dll" (ByVal Serial As String, ByVal Address As Integer, ByVal progress As Integer) As Long
Private Declare Function mOpenCOM Lib "SFBP232.dll" Alias "OpenCOM" (ByVal hWnd As Long) As Long
Public Declare Function TestStream Lib "SFBP232.dll" (ByVal data As Integer, ByVal size As Integer) As Long
Public Declare Function sendRaw Lib "SFBP232.dll" (ByVal lpData As Long, ByVal datalen As Long, chk As Integer, ByVal FirstIsStartMarker As Integer) As Long


Public Declare Sub CloseCOM Lib "SFBP232.dll" ()
Public Declare Sub SetOut Lib "SFBP232.dll" (ByVal outIndex As Integer, ByVal outValue As Integer)
Public Declare Sub SetType Lib "SFBP232.dll" (ByVal packetType As Integer)
Public Declare Sub SetRXbuffer Lib "SFBP232.dll" (ByVal RXb As Integer)
Public Declare Sub SetTXbuffer Lib "SFBP232.dll" (ByVal TXb As Integer)
Public Declare Sub SetCOMPort Lib "SFBP232.dll" (ByVal port As Integer)
Public Declare Sub SetBps Lib "SFBP232.dll" (ByVal bps As Long)
Public Declare Sub SetFrameSize Lib "SFBP232.dll" (ByVal framesize As Integer)
Public Declare Sub SaveSFBPdriverSettings Lib "SFBP232.dll" Alias "SaveSettings" ()
Public Declare Sub SetInt Lib "SFBP232.dll" (ByVal value As Integer, ByVal Index As Integer)
Public Declare Sub SetByte Lib "SFBP232.dll" (ByVal value As Integer, ByVal Index As Integer)
Public Declare Sub ClearBuffer Lib "SFBP232.dll" ()
Public Declare Sub SetSpy Lib "SFBP232.dll" (ByVal spymode As Integer)
Public Declare Sub SetLocalAddress Lib "SFBP232.dll" (ByVal addr As Integer)
Public Declare Sub SetAdapterID Lib "SFBP232.dll" (ByVal adapterID As Long)
Public Declare Sub SetAutoEcho Lib "SFBP232.dll" (ByVal autoecho As Integer)
Public Declare Sub MapAbort Lib "SFBP232.dll" ()
Public Declare Sub SetNoAck Lib "SFBP232.dll" (ByVal noack As Integer)
Public Declare Sub SetPacketTimeout Lib "SFBP232.dll" (ByVal pckTimeout As Integer)
Public Declare Sub SetBusyTimeout Lib "SFBP232.dll" (ByVal busytimeout As Integer)
Public Declare Sub SetProtocol Lib "SFBP232.dll" (ByVal nNewValue As Long)
Public Declare Sub FreezeEvents Lib "SFBP232.dll" (ByVal bFreeze As Integer)
Public Declare Sub SetClientHWND Lib "SFBP232.dll" (ByVal nNewValue As Long)
Public Declare Sub SetResponseMsg Lib "SFBP232.dll" (ByVal respMsg As Long)
Public Declare Sub SetEchoCheck Lib "SFBP232.dll" (ByVal bNewValue As Integer)
Public Declare Sub SetNoErrMsgBox Lib "SFBP232.dll" (ByVal noErrMsgBox As Integer)


Public Declare Sub SetCallbackEvents Lib "SFBP232.dll" ( _
                    ByVal pFireCOMerror As Long, _
                    ByVal pFireDataReady As Long, _
                    ByVal pFireMapProgress As Long, _
                    ByVal pFireMap As Long, _
                    ByVal pFireFirmwareInfo As Long, _
                    ByVal pFireRemoteError As Long, _
                    ByVal pFireProgramProgress As Long, _
                    ByVal pFireQueryReply As Long, _
                    ByVal pFireProgramCompleted As Long, _
                    ByVal pFireNetError As Long)
                    
Declare Function copystring Lib "SFBP232.dll" (ByVal src As Long, ByVal dest As String, ByVal size As Long) As Long
                    
Public Declare Function getSpy Lib "SFBP232.dll" () As Long
Public Declare Function getLocalAddress Lib "SFBP232.dll" Alias "getLocalAddr" () As Integer
Public Declare Function getNoAck Lib "SFBP232.dll" () As Long
Public Declare Function getAutoEcho Lib "SFBP232.dll" () As Long
Public Declare Function getAdapterID Lib "SFBP232.dll" () As Long


Public Declare Function GetRXbuffer Lib "SFBP232.dll" () As Integer
Public Declare Function GetTXbuffer Lib "SFBP232.dll" () As Integer
Public Declare Function GetCOMPort Lib "SFBP232.dll" () As Integer
Public Declare Function GetBps Lib "SFBP232.dll" () As Long
Public Declare Function GetFrameSize Lib "SFBP232.dll" () As Integer
Public Declare Function getPacketTimeout Lib "SFBP232.dll" () As Integer
Public Declare Function getBusyTimeout Lib "SFBP232.dll" () As Integer

Public Declare Function GetSFBPDriverVersion Lib "SFBP232.dll" (ByVal vers As String, ByVal size As Long) As Long


Public Sub cleanNSCCOMLIB()
Set m_NSCCOM = Nothing
End Sub

#If NSCCOMHLPR_USE_CLASS Then
Public Sub setUpNSCCOMLIB(bindObj As INsccom)

Set m_NSCCOM = bindObj

Call SetCallbackEvents( _
                    AddressOf FireCOMerror, _
                    AddressOf FireDataReady, _
                    AddressOf FireMapProgress, _
                    AddressOf FireMap, _
                    AddressOf FireFirmwareInfo, _
                    AddressOf FireRemoteError, _
                    AddressOf FireProgramProgress, _
                    AddressOf FireQueryReply, _
                    AddressOf FireProgramCompleted, _
                    AddressOf FireNetError)

End Sub
#Else
Public Sub setUpNSCCOMLIB(hostForm As Form)

Set m_NSCCOM = hostForm

Call SetCallbackEvents( _
                    AddressOf FireCOMerror, _
                    AddressOf FireDataReady, _
                    AddressOf FireMapProgress, _
                    AddressOf FireMap, _
                    AddressOf FireFirmwareInfo, _
                    AddressOf FireRemoteError, _
                    AddressOf FireProgramProgress, _
                    AddressOf FireQueryReply, _
                    AddressOf FireProgramCompleted, _
                    AddressOf FireNetError)

End Sub
#End If

#If NSCCOMHLPR_USE_CLASS Then
Public Function OpenCOM(hWnd As Long, Optional ByVal port As Integer = 0) As Boolean

If m_NSCCOM Is Nothing Then
  Err.Raise 5, Description:="Can't open COM, NSCCOMLIB not initialized"
  Exit Function
End If

If IsOpen = 1 Then
  If GetCOMPort <> port And port > 0 Then
    CloseCOM
  Else
    OpenCOM = True
    Exit Function
  End If
End If

If port > 0 Then
  SetCOMPort port
ElseIf port = 0 And mApplicationPort > 0 Then
  SetCOMPort mApplicationPort
End If
If mOpenCOM(hWnd) Then
  OpenCOM = True
Else
  OpenCOM = False
End If

End Function
#Else
Public Function OpenCOM(Optional ByVal port As Integer = 0) As Boolean

If m_NSCCOM Is Nothing Then
  Err.Raise 5, Description:="Can't open COM, NSCCOMLIB not initialized"
  Exit Function
End If

If IsOpen = 1 Then
  If GetCOMPort <> port And port > 0 Then
    CloseCOM
  Else
    OpenCOM = True
    Exit Function
  End If
End If

If port > 0 Then
  SetCOMPort port
ElseIf port = 0 And mApplicationPort > 0 Then
  SetCOMPort mApplicationPort
End If
If mOpenCOM(m_NSCCOM.hWnd) Then
  OpenCOM = True
Else
  OpenCOM = False
End If

End Function
#End If

Public Sub SetApplicationPort(newPort As Integer)
If mDefaultPort = 0 Then mDefaultPort = GetCOMPort
mApplicationPort = newPort
End Sub

Public Function GetSFBPDrvVers() As String
Dim vers As String
Dim l As Long

vers = Space(100)
l = GetSFBPDriverVersion(vers, Len(vers))
GetSFBPDrvVers = Left(vers, l)
End Function

Private Function getstr(src As Long) As String
' passo come src un puntatore a stringa ricevuto come long
  Dim s As String
  Dim r As Long
  
  s = " "
  r = copystring(src, s, 0)
  If r = 0 Then Exit Function
  s = Space(r)
  r = copystring(src, s, r)
  getstr = Left(s, r)
End Function

Public Sub FireCOMerror()
m_NSCCOM.Nsccom1_COMerror
End Sub
Public Sub FireDataReady(ByVal srcAddress As Integer, ByVal destAddress As Integer, ByVal datalen As Integer, ByVal msgType As Integer, ByVal pBuf As Long, ByVal pckType As Long)
Dim b() As Byte
Dim i As Integer

ReDim b(datalen - 1) As Byte
For i = 0 To datalen - 1
  b(i) = GetByte(pBuf, i)
Next i
m_NSCCOM.Nsccom1_DataReady srcAddress, destAddress, datalen, msgType, pBuf, pckType, b
End Sub
Public Sub FireMapProgress(ByVal level As Integer)
m_NSCCOM.Nsccom1_MapProgress level
End Sub
Public Sub FireMap(ByVal Address As Integer, ByVal Serial As Long, ByVal devID As Integer, ByVal MinorVersion As Integer, ByVal MajorVersion As Integer)
m_NSCCOM.Nsccom1_Map Address, getstr(Serial), devID, MinorVersion, MajorVersion
End Sub
Public Sub FireFirmwareInfo(ByVal Address As Integer, ByVal Serial As Long, ByVal devID As Integer, ByVal Device As Long, ByVal MinorVersion As Integer, ByVal MajorVersion As Integer, ByVal Version As Long)
m_NSCCOM.Nsccom1_FirmwareInfo Address, getstr(Serial), devID, getstr(Device), MinorVersion, MajorVersion, getstr(Version)
End Sub
Public Sub FireRemoteError(ByVal Address As Integer, ByVal ErrorCode As Integer, ByVal ErrorString As Long)
m_NSCCOM.Nsccom1_RemoteError Address, ErrorCode, getstr(ErrorString)
End Sub
Public Sub FireProgramProgress(ByVal level As Integer, ByVal status As Long)
m_NSCCOM.Nsccom1_ProgramProgress level, getstr(status)
End Sub
Public Sub FireQueryReply(ByVal Address As Integer, ByVal lpData As Long, ByVal queryID As Integer)
m_NSCCOM.Nsccom1_QueryReply Address, lpData, queryID
End Sub
Public Sub FireProgramCompleted()
m_NSCCOM.Nsccom1_ProgramCompleted
End Sub
Public Sub FireNetError(ByVal ErrCode As Integer, ByVal ErrMsg As Long)
m_NSCCOM.Nsccom1_NetError ErrCode, getstr(ErrMsg)
End Sub


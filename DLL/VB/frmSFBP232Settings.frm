VERSION 5.00
Begin VB.Form frmSFBP232Settings 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "SFBP 232 driver settings"
   ClientHeight    =   4830
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   4005
   Icon            =   "frmSFBP232Settings.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4830
   ScaleWidth      =   4005
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame Frame1 
      Caption         =   "Advanced settings:"
      Height          =   1815
      Left            =   120
      TabIndex        =   10
      Top             =   2340
      Width           =   3765
      Begin VB.TextBox txtBTimeout 
         Height          =   315
         Left            =   1680
         TabIndex        =   17
         Top             =   1380
         Width           =   945
      End
      Begin VB.TextBox txtTimeout 
         Height          =   315
         Left            =   1680
         TabIndex        =   13
         Top             =   1020
         Width           =   945
      End
      Begin VB.ComboBox cmbFramesize 
         Height          =   315
         Left            =   1680
         Style           =   2  'Dropdown List
         TabIndex        =   12
         Top             =   660
         Width           =   1995
      End
      Begin VB.ComboBox cmbBaud 
         Height          =   315
         Left            =   1680
         Style           =   2  'Dropdown List
         TabIndex        =   11
         Top             =   300
         Width           =   1995
      End
      Begin VB.Label Label3 
         Alignment       =   1  'Right Justify
         Caption         =   "milliseconds"
         Height          =   255
         Index           =   9
         Left            =   2520
         TabIndex        =   20
         Top             =   1440
         Width           =   975
      End
      Begin VB.Label Label3 
         Alignment       =   1  'Right Justify
         Caption         =   "milliseconds"
         Height          =   255
         Index           =   8
         Left            =   2520
         TabIndex        =   19
         Top             =   1080
         Width           =   975
      End
      Begin VB.Label Label3 
         Caption         =   "busy timeout:"
         Height          =   255
         Index           =   7
         Left            =   120
         TabIndex        =   18
         Top             =   1380
         Width           =   1455
      End
      Begin VB.Label Label3 
         Caption         =   "packet+ack timeout:"
         Height          =   255
         Index           =   5
         Left            =   120
         TabIndex        =   16
         Top             =   1080
         Width           =   1455
      End
      Begin VB.Label Label3 
         Caption         =   "Frame size:"
         Height          =   255
         Index           =   4
         Left            =   120
         TabIndex        =   15
         Top             =   720
         Width           =   1455
      End
      Begin VB.Label Label3 
         Caption         =   "Baud rate:"
         Height          =   255
         Index           =   2
         Left            =   120
         TabIndex        =   14
         Top             =   360
         Width           =   855
      End
   End
   Begin VB.ComboBox cmbAppPort 
      Height          =   315
      Left            =   2580
      Style           =   2  'Dropdown List
      TabIndex        =   8
      Top             =   600
      Width           =   1305
   End
   Begin VB.ComboBox cmbAdapter 
      Height          =   315
      Left            =   1140
      Style           =   2  'Dropdown List
      TabIndex        =   3
      Top             =   1860
      Width           =   2745
   End
   Begin VB.ComboBox cmbPort 
      Height          =   315
      Left            =   2580
      Style           =   2  'Dropdown List
      TabIndex        =   2
      Top             =   1020
      Width           =   1305
   End
   Begin VB.CommandButton cmdSaveSettings 
      Caption         =   "Save as driver's default settings"
      Height          =   495
      Index           =   4
      Left            =   120
      TabIndex        =   1
      Top             =   4260
      Width           =   3765
   End
   Begin VB.TextBox txtLocalAddr 
      Height          =   315
      Left            =   2580
      TabIndex        =   0
      Top             =   1410
      Width           =   1305
   End
   Begin VB.Label Label3 
      Caption         =   "Application COM port:"
      Height          =   315
      Index           =   6
      Left            =   180
      TabIndex        =   9
      Top             =   660
      Width           =   1635
   End
   Begin VB.Label lblVers 
      BorderStyle     =   1  'Fixed Single
      Height          =   495
      Left            =   120
      TabIndex        =   7
      Top             =   60
      Width           =   3765
   End
   Begin VB.Label Label3 
      Caption         =   "Adapter:"
      Height          =   255
      Index           =   0
      Left            =   150
      TabIndex        =   6
      Top             =   1920
      Width           =   975
   End
   Begin VB.Label Label3 
      Caption         =   "Default port:"
      Height          =   255
      Index           =   1
      Left            =   180
      TabIndex        =   5
      Top             =   1050
      Width           =   1635
   End
   Begin VB.Label Label3 
      Caption         =   "Station Address:"
      Height          =   255
      Index           =   3
      Left            =   180
      TabIndex        =   4
      Top             =   1440
      Width           =   1455
   End
End
Attribute VB_Name = "frmSFBP232Settings"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


'
'  SFBP Protocol Library
'  =====================
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


Private Sub cmdSaveSettings_Click(Index As Integer)
Dim i As Integer
Dim wasopen As Boolean

  If NSCCOMhelper.IsOpen Then
    wasopen = True
    NSCCOMhelper.CloseCOM
  End If
  
  NSCCOMhelper.SetAdapterID cmbAdapter.ItemData(cmbAdapter.ListIndex)
  NSCCOMhelper.SetBps cmbBaud.ItemData(cmbBaud.ListIndex)
  NSCCOMhelper.SetFrameSize Val(cmbFramesize.List(cmbFramesize.ListIndex))
  NSCCOMhelper.SetLocalAddress Val(txtLocalAddr)
  NSCCOMhelper.SetCOMPort cmbPort.ListIndex + 1
  NSCCOMhelper.mDefaultPort = cmbPort.ListIndex + 1
  NSCCOMhelper.mApplicationPort = cmbAppPort.ListIndex
  
  NSCCOMhelper.SetPacketTimeout Val(txtTimeout)
  NSCCOMhelper.SetBusyTimeout Val(txtBTimeout)
  
  NSCCOMhelper.SaveSFBPdriverSettings
  
  If wasopen Then NSCCOMhelper.OpenCOM

  Unload Me

End Sub

Private Sub Form_Load()


Dim i As Integer
Dim z As Integer


lblVers = "SM SFBP 232 COM driver version: " & vbCrLf & NSCCOMhelper.GetSFBPDrvVers



With cmbAdapter
  .AddItem "SIMPLE"
  .ItemData(0) = NSC_ADAPTER_SIMPLE
  .AddItem "FAST"
  .ItemData(1) = NSC_ADAPTER_FAST
  
  For i = 0 To .ListCount - 1
    If NSCCOMhelper.getAdapterID = .ItemData(i) Then
      .ListIndex = i
      Exit For
    End If
  Next i
End With

If mDefaultPort > 0 Then
  z = NSCCOMhelper.mDefaultPort
Else
  z = NSCCOMhelper.GetCOMPort
End If
With cmbPort
  For i = 0 To 31
    .AddItem CStr(i + 1)
    If i + 1 = z Then .ListIndex = i
  Next i
End With

With cmbAppPort
  For i = 0 To 32
    If i = 0 Then
      .AddItem "*use default*"
    Else
      .AddItem CStr(i)
    End If
    If i = NSCCOMhelper.mApplicationPort Then .ListIndex = i
  Next i
End With

With cmbBaud
  .AddItem "9600"
  .ItemData(.NewIndex) = BPS9600
  .AddItem "14400"
  .ItemData(.NewIndex) = BPS14400
  .AddItem "19200"
  .ItemData(.NewIndex) = BPS19200
  .AddItem "38400"
  .ItemData(.NewIndex) = BPS38400
  .AddItem "57600"
  .ItemData(.NewIndex) = BPS57600
  
  For i = 0 To .ListCount - 1
    If .ItemData(i) = NSCCOMhelper.GetBps Then
      .ListIndex = i
      Exit For
    End If
  Next i
End With

txtLocalAddr.Text = NSCCOMhelper.getLocalAddress

With cmbFramesize
  .AddItem "7"
  .AddItem "8"
  
  For i = 0 To .ListCount - 1
    If Val(.List(i)) = NSCCOMhelper.GetFrameSize Then
      .ListIndex = i
      Exit For
    End If
  Next i
End With

txtTimeout = NSCCOMhelper.getPacketTimeout
txtBTimeout = NSCCOMhelper.getBusyTimeout


End Sub
Private Sub sfbp232_checkTxtRange(txt As TextBox, min As Long, max As Long)
' impone il limite
If Len(txt.Text) = 0 Then Exit Sub

Dim l As Long, j As Long

l = txt.SelStart

j = 1
While j <= Len(txt.Text)
  Select Case Mid(txt.Text, j, 1)
  Case "0" To "9"
    j = j + 1
  Case Else
    txt = Left(txt, j - 1) & Mid(txt, j + 1)
  End Select
Wend
If l > Len(txt) Then l = Len(txt)

txt.SelStart = l

If Val(txt) < min Then
  txt = Trim(Str(min))
ElseIf Val(txt) > max Then
  txt = Trim(Str(max))
End If

End Sub

Private Sub txtBTimeout_Change()
sfbp232_checkTxtRange txtBTimeout, 0, 32767
End Sub

Private Sub txtLocalAddr_Change()

sfbp232_checkTxtRange txtLocalAddr, 1, 127

End Sub

Private Sub txtTimeout_Change()
sfbp232_checkTxtRange txtTimeout, 0, 32767
End Sub

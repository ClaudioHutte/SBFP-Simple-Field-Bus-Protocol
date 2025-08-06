	Simple Field Bus Protocol Dynamic Library Support
		  for Windows (XP, Vista, 7, 10, 11)
		  ..................................
		        (c)2025 Claudio H.G.


MIT License with Attribution
----------------------------

Copyright (c) 2004-2025 Claudio H. G.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, subject to the following conditions:

- The above copyright notice and this permission notice shall be included
  in all copies or substantial portions of the Software.

- The origin of this Software must not be misrepresented. If used in a product,
  an acknowledgment is appreciated (e.g., “Uses the SFBP Protocol Library by Claudio H.G.”).

- If a product uses the Software, it is recommended that the “SFBP” logo be displayed 
  in a visible location. The logo is provided free of charge and available for use 
  under the same license terms.			  

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
DEALINGS IN THE SOFTWARE.


		    *****************************
			SFBP.DLL - C# Implementations
			*****************************
			

Two files are provided as complement to the implementation of your code to link SFBP.DLL:

	* NSCCOMhelper.cs 	Implementation class
	* SFBP_public.cs	SFBP structures constants

Add both to your project.



How SFBP.DLL Works
==================

When calling OpenCOM a hWnd argument is required. This is because the DLL begins to subclass the 
given Window handle.
In background SFBP.DLL start an apartment thread and then registers for private messages that 
Windows will send to the application, which in turn are intercepted by the DLL via subclassing.

Once the communication channel needs to be closed, calling CloseCOM automatically destroy the 
thread and released the allocated resources.
This also keep the DLL from calling back the host application (no more events are generated).
Now the application should call SetClientHWND(0) to unsubclass the window.

Therefore before calling OpenCOM you should be sure that the WinForm is actually loaded so the
handle is valid. In addition before calling OpenCOM you should also call SetCallbackEvents to
register your delegate functions (see InitializeCallbacks below ).


Example:
--------

		public partial class MainForm : Form
		{
			public MainForm()
			{
				InitializeComponent();
				// Force handle creation up front:
				var h = this.Handle;
			}

			protected override void OnLoad(EventArgs e)
			{
				base.OnLoad(e);
				// Register callbacks first
				NSCCOMhelper.InitializeCallbacks();

				// OpenCOM wants an HWND to subclass:
				int result = NSCCOMhelper.OpenCOM((int)this.Handle);
				if (result != 0)
					MessageBox.Show("Failed to open COM: " + result);
			}

			protected override void OnFormClosing(FormClosingEventArgs e)
			{
				// Cleanly close communication and unsubscribe subclass:
				NSCCOMhelper.CloseCOM();
				NSCCOMhelper.SetClientHWND(0);	// Stop thread, release buffers, etc.
				base.OnFormClosing(e);			// Unsubclass the window
			}
		}


** This is a better example that handles edge cases (like opening and closing multiple times the COM port) **

	SFBPHostManager Helper Class:
	.............................
	
		using System;
		using System.Runtime.InteropServices;
		using System.Windows.Forms;

		public static class SFBPHostManager
		{
			private static IntPtr _clientHwnd = IntPtr.Zero;

			public static bool IsOpen { get; private set; } = false;

			public static bool OpenCOM(Form ownerForm)
			{
				if (ownerForm == null)
					throw new ArgumentNullException(nameof(ownerForm));

				if (IsOpen)
					return true;

				// Force handle creation if not yet created
				_clientHwnd = ownerForm.Handle;

				// Register callbacks before opening
				NSCCOMhelper.InitializeCallbacks();

				// Set client HWND to prepare for subclassing
				NSCCOMhelper.SetClientHWND((long)_clientHwnd);

				// Attempt to open COM with the HWND
				int result = NSCCOMhelper.OpenCOM((int)_clientHwnd);
				IsOpen = (result == 0); // assume 0 is success
				return IsOpen;
			}

			public static void CloseCOM()
			{
				if (!IsOpen)
					return;

				// Tear down COM channel
				NSCCOMhelper.CloseCOM();

				// Unsubclass window handle
				NSCCOMhelper.SetClientHWND(0);

				_clientHwnd = IntPtr.Zero;
				IsOpen = false;
			}
		}


	🧪 Usage Example in WinForms:
	.............................

		public partial class MainForm : Form
		{
			public MainForm()
			{
				InitializeComponent();
			}

			private void MainForm_Load(object sender, EventArgs e)
			{
				if (!SFBPHostManager.OpenCOM(this))
				{
					MessageBox.Show("Failed to initialize COM channel.");
				}
			}

			private void MainForm_FormClosing(object sender, FormClosingEventArgs e)
			{
				SFBPHostManager.CloseCOM();
			}
		}




How to Implement The SFBP Library in Your C# Code
=================================================

The SFBP.DLL is a 32-bit dynamic library, you must make sure your application is 32-bit as well!


🧩 How to Make Sure Your C# App is 32-bit:
In Visual Studio:

    Right-click your project → Properties

    Go to Build tab

    Set Platform Target to:

        x86 → forces 32-bit

        Not AnyCPU unless "Prefer 32-bit" is also checked (in .NET Framework apps)

From the command line (.NET SDK):

	dotnet build -p:PlatformTarget=x86

🧪 How to Confirm It Works

You can run this in your C# app to confirm it's 32-bit:

	Console.WriteLine(Environment.Is64BitProcess ? "64-bit" : "32-bit");

If you're trying to load a 32-bit DLL into a 64-bit process, you’ll get this kind of error:

	BadImageFormatException: An attempt was made to load a program with an incorrect format.
	


Register Callbacks
==================

Call SetCallbackEvents passing your functions that follows the Delegate prototypes (see NSCCOMhelper.cs).

⚠️ Important: Keep the Delegates Alive!

When you register a delegate with unmanaged code, you must prevent it from being garbage-collected. 
This means you should store the delegate in a static variable (or another persistent object).

✅ Best Practice: Store Delegates in Static Fields
---------------------------------------------------

private static FireCOMError _onCOMError = OnCOMError;
private static FireDataReady _onDataReady = OnDataReady;
private static FireMapProgress _onMapProgress = OnMapProgress;
private static FireMap _onMap = OnMap;
private static FireFirmwareInfo _onFirmwareInfo = OnFirmwareInfo;
private static FireRemoteError _onRemoteError = OnRemoteError;
private static FireProgramProgress _onProgramProgress = OnProgramProgress;
private static FireQueryReply _onQueryReply = OnQueryReply;
private static FireProgramCompleted _onProgramCompleted = OnProgramCompleted;
private static FireNetError _onNetError = OnNetError;


🔧 Then Set Them
----------------

public static void InitializeCallbacks()
{
    NSCCOMhelper.SetCallbackEvents(
        _onCOMError,
        _onDataReady,
        _onMapProgress,
        _onMap,
        _onFirmwareInfo,
        _onRemoteError,
        _onProgramProgress,
        _onQueryReply,
        _onProgramCompleted,
        _onNetError
    );
}


🔍 Example Callback Implementations
-----------------------------------
These match the delegate types declared earlier:

private static void OnCOMError()
{
    Console.WriteLine("[Callback] COM error");
}

private static void OnDataReady(short src, short dest, short len, short msgType, IntPtr buf, int pckType)
{
    Console.WriteLine($"[Callback] Data ready: {src} → {dest}, len: {len}");
}

// You can continue with others like:
private static void OnMap(short address, string serial, short devID, short minor, short major) { /*...*/ }
private static void OnProgramCompleted() { Console.WriteLine("[Callback] Program completed"); }


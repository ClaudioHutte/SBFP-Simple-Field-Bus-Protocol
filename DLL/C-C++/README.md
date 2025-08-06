In this directory you fine headers for C/C++ for linking the DLL.

## How SFBP.DLL Works

When calling OpenCOM a hWnd argument is required. This is because the DLL begins to subclass the given Window handle.
In background SFBP.DLL start an apartment thread and then registers for private messages that Windows will send to the application, which in turn are intercepted by the DLL via subclassing.

Once the communication channel needs to be closed, calling CloseCOM automatically destroy the thread and released the allocated resources.
This also keep the DLL from calling back the host application (no more events are generated).
Now the application should call SetClientHWND(0) to unsubclass the window.

Therefore before calling OpenCOM you should be sure that the Window is actually loaded so the handle is valid.
In addition before calling OpenCOM you should also call SetCallbackEvents to register your functions callbacks.


## Administrative Privilege Required

Beware that when saving settings the library checks if the user has administrative privileges. On older Windows versions it just check if the user is member of the Administrators group,
on Windows 7, 10 and 11 it checks if it has actual admin privileges.
So when running with your app you should make sure the user has admin privileges before allowing they to save settings, otherwise the library will display a messagebox error and will refuse the operation.


## Header Files

* nscSFBP.h - Function prototypes and structures. It also includes some definitions specific of the NSC Operating System.
* SFBP_public.h - SFBP structures and definitions.

You must include both headers.

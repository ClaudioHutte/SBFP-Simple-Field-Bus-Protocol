# SBFP DLL

SFBP.DLL is a Windows dynamic library that handles the communication via RS232 or a USB adapter that expose a COM port (example the FTDI 232BL) and manages for you the SFBP protocol.
Typically it works with an RS232-RS485 (automatic) converter or a USB->RS232-RS485 adapter+converter or a USB-RS485 (automatic) adapter.

**Remark:** RS485 converters *must* be automatic, which means they automatically detects when a symbol is sent over the network and occupy the line just for the required time to transmit such a symbol.
This is for example supported by the FTDI FT232BL chip.

## In this directory:

* Changelog
* VB - Directory with examples for Visual Basic and modules
* C-C++ - Directory with C/C++ headers
* Csharp - Directory with C# class and examples

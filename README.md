# SBFP Simple Field Bus Protocol
The Simple Field Bus Protocol (SFBP) is a protocol developed to support peer-to-peer (multi-master) communication across RS-485 or radio networks. Conceived to be lightweight it best fits microcontrollers like the AVR series and it is especially suited for even-driven execution.

## Description

The Simple Field Bus Protocol was designed for communications among devices operating on an event-driven paradigm and shared computation over a single field bus or related field buses, in a multiple access configuration.  This protocol was also designed to be as simple as possible allowing compact implementations that fit well in embedded systems.
Key points are: 
- bi-directionality
- multi-master
- asynchronous access, which best suit event-driven systems
- application and physical layer agnostic
- small fixed packets, that best suit commands or small amount of data (such as updates of values). 
The protocol may also transport streams of data, even though it is not optimized for this purpose.

Here are summarized the driving factors that led to the development of the protocol and may provide a guideline to understand if this protocol may suit your needs:

- reach a reasonable amount of devices
- be able to address all devices at a time (broadcast operations)
- both **synchronous** (connected) and **asynchronous** unconnected communication (datagrams)
- optimized for small amount of data, however providing also a way for larger data transfer (carrying fragmented stream of data using synchronous packets)
- multiple communications (master to master configuration), multiple access over a single carrier
- fault tolerant in the case of collisions and an optional method to reduce collisions
- provide a marker for easy parse of sequences of packets stored into a buffer
- independent from the physical layer
- fits the range of 8 bit of data per frame (to be able to run over a RS232 for point to point links, for instance)

Furthermore, some assumptions were made: the protocol relies on a field bus line capable of detecting line faults, namely collisions.  Expansions can be done by adding repeaters, however this topic goes beyond the purposes of this document.

Although the protocol was designed having in mind the IEEE RS 485 standard as physical layer, the SFPB packets can be carried over others physical layers, including radio links.

All changes implemented into the versions two still meet the original purposes.

## Characteristics

- Up to 127 addressable device (including stations and gateways)
- 1 broadcast address
- Unconnected datagram and connected packets for either fast messages or safe data transfer
- Fragment bit field for streaming data bigger than a DU (DU, in this document stands for the Payload Data Unit)
- Compact packet headers made up of three bytes
- DU (data unit) 6 bytes in length
- Packets formed with up to 11 bytes
- Seven possible type of packets: Data, Control, Time, Echo and System (other codes are reserved)
- CSMA/CD like collision detection
- Simple packet acknowledgment system with a single datagram packet formed with only 4 bytes in version 1, and 5 bytes in version 2
- Optional: Specific for RS485, RS422 and RS232 physical layers, frames formed with up to 8 bit data, 1 stop bit, 1 parity bit, and even parity checking.
  **Remark:** *this is a specific typical application where SFBP is used over RS485, RS422 and RS232, but it is not a mandatory specification of SFBP.*
- Optional: Failure detection at frame level (i.e., parity check bit), mandatory at packet level.

## License

This protocol is open and it is released under the terms and condition of the License as detailed on the copyright notice below.

### Simple Field Bus Protocol
**Copyright (c) 2003-2004 Claudio Ghiotto – Paolo Marchetto**

Permission is hereby granted, free of charge, to any person obtaining a copy of this protocol specification and any associated software implementations (the “SOFTWARE”), to use, copy, modify, merge, publish, and distribute copies of this document and to implement the protocol in software for both personal and commercial purposes, subject to the following conditions:

- The above copyright notice and this permission notice shall be included in all copies or substantial portions thereof.
- The origin of this document must not be misrepresented.
- Attribution must be retained in any product, documentation, or derivative work implementing the specification. 
- If a product uses the associated software implementations, it is recommended that the “SFBP” logo be displayed in a visible location. The logo is provided free of charge and available for use under the same license terms. 

THE SOFTWARE AND PROTOCOL SPECIFICATION ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT, OR OTHERWISE, ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE, THE SPECIFICATION, OR THE USE OR OTHER DEALINGS IN THEM.

## Logo

*You are athorized and encouraged to use this logo if you implement the SFBP protocol in your own device or software.*

![SFBP logo - large format. You are athorized and encouraged to use this logo if you implement the SFBP protocol in your own device or software](SFBPlogoBIG.png)

## Implementations

- [NSC Networked Shared Control](https://upower.artdevices.com/)

*If you implemented the protocol contact me and I'll add your name here.*

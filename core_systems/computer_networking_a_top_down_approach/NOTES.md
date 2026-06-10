## Chapter 1: Computer Networks and the Internet

#### 1.1 What Is the Internet?

Two useful ways to define “the Internet”:

- a nuts-and-bolts view: the concrete components (hosts, links, routers/switches, protocols)
- a services view: an infrastructure that applications use to communicate

Course transcript note: I could not retrieve the YouTube transcript programmatically (the timed-text endpoints returned empty), so this section is based on the book + local slide deck only.

##### 1.1.1 A Nuts-and-Bolts Description

At a concrete level, the Internet is a giant interconnection of end systems (hosts) plus the network equipment that moves data between them.

The main pieces:

- Hosts (end systems): laptops, phones, servers, and lots of “things” (IoT devices).
- Communication links: physical media that carry bits (fiber, copper, radio, satellite). Each link has a transmission rate (bandwidth, in bits/second).
- Packets: when you send data, it is segmented into chunks and each chunk gets header bytes; these chunks are what the network forwards.
- Packet switches: devices that forward packets toward their destinations.
  - Routers: prominent in the network core.
  - Link-layer switches: prominent in access networks.
- Routes/paths: the sequence of links and switches that a packet traverses.

The “trucks on highways” analogy is useful:

- packets are trucks
- links are roads
- switches/routers are intersections
- hosts are buildings

End systems typically connect through ISPs. The Internet is a network of networks: many independently managed ISP networks interconnect to let any host reach any other.

Protocols and standards matter because everything has to interoperate. Many Internet standards come from the IETF as RFCs.

![](media/page-027-img-01.png)

Figure 1.1 Some pieces of the Internet

From course slides (Chapter_1_v9.0.pptx):

- Packet switches forward packets; routers and switches are the key examples.
- Links include fiber/copper/radio/satellite; bandwidth measures transmission rate.
- “Hosts = end systems” are the devices running network apps.
- The Internet is a “network of networks” made of interconnected ISPs.

##### 1.1.2 A Services Description

From a programmer’s viewpoint, the Internet is a platform that provides communication services to distributed applications (apps running on different hosts that exchange messages).

Key idea: applications run at the edge (on end systems), not inside the core switches/routers.

The interface between an application and the Internet is a socket interface: a set of rules the application follows to have the network deliver data to a specific destination process on another host.

The postal-service analogy:

- your message is the letter
- the socket interface is like the envelope/address/stamp/dropbox rules you must follow

From course slides (Chapter_1_v9.0.pptx):

- The Internet provides services for Web, streaming video, video conferencing, email, games, e-commerce, and more.
- Applications interact with the network via a programming interface.

##### 1.1.3 What Is a Protocol?

Protocols are rules for communication.

Human analogies help: greetings, turn-taking, what you do if you get no response, and so on.

In networks, the “entities” following protocols are hardware/software components (hosts, NICs, routers, etc.). Protocols exist at many places and layers (examples you’ll see throughout the book include HTTP, TCP, IP, WiFi, and Ethernet).

Core definition (book):

A protocol defines the format and the order of messages exchanged between two or more communicating entities, as well as the actions taken on the transmission and/or receipt of a message or other event.

![](media/page-031-img-01.png)

Figure 1.2 A human protocol and a computer network protocol

From course slides (Chapter_1_v9.0.pptx):

- Protocols define message format, message order, and the actions on send/receive.
- “All communication activity in the Internet is governed by protocols.”

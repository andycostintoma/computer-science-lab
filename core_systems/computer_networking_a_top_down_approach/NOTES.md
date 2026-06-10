## Chapter 1: Computer Networks and the Internet

#### 1.1 What Is the Internet?

You can answer “what is the Internet?” from two angles:

- the concrete pieces (what it’s made of)
- the services it provides to applications (what it does)

##### 1.1.1 A Nuts-and-Bolts Description

The Internet is a huge collection of *end systems* (also called *hosts*) connected by a network that moves data between them.

Hosts are no longer just PCs and servers. They include phones, tablets, and a growing set of Internet-connected “things” (cameras, appliances, sensors, vehicles, and so on). The important point is: hosts sit at the edge, run applications, and are the source and destination of the data that the network carries.

Between hosts, data moves through:

- Communication links: the physical media that carry bits (fiber, copper, radio, satellite). Each link has a transmission rate (bandwidth, in bits/second).
- Packets: data is broken into chunks; each chunk gets header bytes; the network forwards these chunks independently.
- Packet switches: devices that forward packets from an incoming link to an outgoing link.
  - Routers: typically used in the network core.
  - Link-layer switches: typically used in access networks.

The sequence of links and switches a packet traverses is its *path* (or *route*).

The “trucks on highways” analogy is worth keeping in your head:

- packets are trucks
- links are roads
- switches/routers are intersections
- hosts are buildings

In practice, hosts don’t usually plug directly into the global Internet. They connect through an Internet Service Provider (ISP). Each ISP is itself a network, and the Internet is formed by interconnecting many independently managed networks. That is what people mean by “a network of networks.”

To make all these independently built devices and networks work together, everyone needs to agree on protocols. Many Internet protocol standards are published by the IETF as RFCs.

![](media/page-027-img-01.png)

Figure 1.1 Some pieces of the Internet

##### 1.1.2 A Services Description

From the services viewpoint, the Internet is a platform that applications use to exchange data.

Applications are *distributed* when they run on multiple hosts and communicate across the network (Web browsing, email, streaming video, messaging, video calls, multiplayer games, and so on). Importantly, these applications run on end systems. The devices in the network core don’t “run the app”; they just move packets.

For a program to use the Internet, it uses an interface (eventually made concrete as an API) that lets it send data to, and receive data from, another program running elsewhere. In Internet terminology, this interface is provided as a *socket*.

The postal-service analogy captures the idea:

- you provide the letter (your data)
- the “rules of the interface” tell you how to address/package it so the infrastructure can deliver it

##### 1.1.3 What Is a Protocol?

Protocols are rules for communication.

Human analogies help because they have the same shape: there are expected messages, a typical ordering, and specific actions based on what you receive (or whether you receive anything at all).

In networks, the communicating “entities” are hardware/software components (hosts, network interface cards, routers, and so on). Protocols appear at many layers (HTTP, TCP, IP, WiFi, Ethernet), and a big part of networking is understanding how these protocols compose.

Definition:

A protocol defines the format and the order of messages exchanged between two or more communicating entities, as well as the actions taken on the transmission and/or receipt of a message or other event.

![](media/page-031-img-01.png)

Figure 1.2 A human protocol and a computer network protocol

The practical payoff: if two systems implement the same protocol, they can interoperate; if they don’t, communication fails or becomes meaningless.

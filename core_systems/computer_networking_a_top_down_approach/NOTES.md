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

#### 1.2 The Network Edge

The *network edge* is where end systems live: your laptop, phone, servers, and all the other devices that run applications.

End systems are often split into:

- clients: user devices (laptops, phones, tablets)
- servers: machines that store/serve content and services (Web, email, streaming, search, APIs)

Most of the servers you interact with now live in large data centers.

![](media/page-033-img-01.png)

Figure 1.3 End-system interaction

Case History Data Centers and Cloud Computing

Data centers are buildings packed with servers connected by their own internal networks.

They commonly serve three roles:

- hosting a company’s own services (for example, an e-commerce site)
- running large internal data-processing jobs (massively parallel computation)
- providing “cloud” infrastructure (other companies run their services on it)

Even if a company’s “app” feels like a single website, behind the scenes there can be thousands of machines cooperating inside one or more data centers.

##### 1.2.1 Access Networks

An *access network* is the part that physically connects an end system to the first router on its path into the Internet (the *edge router*).

Access networks show up in different settings:

- home access
- enterprise/campus access
- wide-area mobile (cellular) access

![](media/page-035-img-01.png)

Figure 1.4 Access networks

Home access

The three most common broadband options are DSL, cable, and FTTH.

DSL

DSL uses the telephone company’s existing twisted-pair phone lines.

The key moving parts are:

- a DSL modem in the home
- a splitter that separates voice vs data (different frequency bands)
- a DSLAM at the telephone company central office (CO), where many home lines terminate

![](media/page-036-img-01.png)

Figure 1.5 DSL Internet access

DSL is typically *asymmetric* (download faster than upload), and the achievable rate depends heavily on how far you live from the CO and on line quality.

Cable (HFC)

Cable Internet uses the cable-TV company’s infrastructure, often called *hybrid fiber-coax* (HFC): fiber to a neighborhood junction, then coaxial cable to homes.

Important characteristics:

- you use a cable modem at home
- the provider side has a CMTS (similar role to a DSLAM)
- downstream and upstream channels exist (also typically asymmetric)
- it’s a *shared broadcast medium*: in a neighborhood, many homes share capacity

Shared capacity is why performance can vary with how many neighbors are active at the same time.

![](media/page-037-img-01.png)

Figure 1.6 A hybrid fiber-coaxial access network

FTTH

Fiber to the home (FTTH) brings an optical fiber path very close to, or directly into, the home.

The details vary by architecture, but a useful mental model is:

- optical equipment in/near the central office
- some form of splitting/sharing closer to the neighborhood
- an optical network terminator (ONT) at the home

![](media/page-038-img-01.png)

Figure 1.7 FTTH Internet access

Fixed wireless and LEO satellites

Fixed wireless Internet can provide high-speed home access without running physical cables to the house.

Low-earth orbit (LEO) satellites are increasingly used for broadband access, especially in rural/remote areas, with much lower delay than geostationary satellites.

Enterprise/campus access: Ethernet and WiFi

On campuses and in enterprises, a LAN typically connects hosts to the edge router.

Ethernet:

- hosts connect over copper (twisted pair) to an Ethernet switch
- switches (or networks of switches) connect into the broader Internet

![](media/page-039-img-01.png)

Figure 1.8 Ethernet Internet access

WiFi (802.11):

- hosts connect wirelessly to an access point
- the access point is typically connected to wired Ethernet

Home networks often combine broadband access (DSL/cable/FTTH) plus WiFi and Ethernet behind a home router.

![](media/page-040-img-01.png)

Figure 1.9 A typical home network

Wide-area mobile access: 4G and 5G

With cellular access, phones and other devices send/receive packets through a provider-operated base station.

The key difference from WiFi is range: WiFi is tens of meters; cellular can cover tens of kilometers.

##### 1.2.2 Physical Media

To talk about “physical media,” imagine the life of a single bit going from sender to receiver.

It repeatedly moves through *transmitter/receiver pairs*:

```text
host -> link -> router -> link -> router -> ... -> link -> host
```

Each hop can use a different physical medium.

Physical media fall into two broad categories:

- guided media: signals are guided through a solid medium (twisted pair, coax, fiber)
- unguided media: signals propagate through the air/space (radio)

Cost note: the cable itself is often cheap compared to the labor of installing it. That’s why buildings often run multiple kinds of cabling even if only one is used at first.

Twisted-pair copper wire

- two insulated copper wires twisted together to reduce interference
- dominant medium for short-range wired networking (LANs) and also used for DSL
- achievable rate depends on distance and cable category (modern categories can reach multi-gigabit over short distances)

Coaxial cable

- concentric copper conductors with shielding
- common in cable TV and cable Internet
- can act as a shared medium (multiple end systems connected to the same coax)

Fiber optics

- bits are carried as pulses of light
- supports extremely high rates over long distances with low attenuation
- immune to electromagnetic interference and harder to tap
- widely used for long-haul links and Internet backbones (and increasingly for FTTH)

Terrestrial radio channels

- no wire to install
- supports mobility
- performance depends heavily on the environment (path loss, shadowing, multipath, interference)

Satellite radio channels

- satellites link ground stations and can provide connectivity where land-based access is hard
- geostationary satellites introduce large propagation delay (because they are far away)
- LEO constellations reduce delay but need many satellites for continuous coverage

variable "rules" {
  description = "Map of known security group rules (define as 'name' = ['from port', 'to port', 'protocol', 'description'])"
  type        = "map"

  # Protocols: All = -1, IPV4-ICMP = 1, TCP = 6, UDP = 16, IPV6-ICMP = 58
  default = {
    http     = [8080, 8088, 6, "HTTP"]
    mysql    = [81, 81, 6, "MySQL"]
    postgres = [82, 82, 6, "PostgreSQL"]

    carbon-line-up-tcp = [2003, 2003, 6, "Carbon"]
    carbon-line-up-udp = [2003, 2003, 16, "Carbon"]
    "2013-tcp"         = [2013, 2013, 6, "Carbon"]
    "2013-udp"         = [2013, 2013, 16, "Carbon"]

    all-all       = [0, 65535, -1, "All protocols"]
    all-icmp      = [0, 65535, 1, "All IPV4 ICMP"]
    all-ipv6-icmp = [0, 65535, 58, "All IPV6 ICMP"]
    all-tcp       = [0, 65535, 6, "All TCP"]
    all-udp       = [0, 65535, 16, "All"]

    # This is a fallback rule to pass to lookup() as default. It does not open anything, because it should never be used.
    _ = ["", "", ""]
  }
}

variable "auto_groups" {
  description = "Map of groups of security group rules to use to generate modules (see update_groups.sh)"
  type        = "map"

  # Valid keys - ingress_rules, egress_rules, ingress_with_self, egress_with_self
  default = {
    ssh = {
      ingress_rules = ["http", "ssh"]
      egress_rules  = ["all-all"]
    }

    http = {
      ingress_rules = ["http"]
      egress_rules  = ["all-all"]
    }
  }
}

/*
List of protocols (https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml):
Decimal,Keyword,Protocol,IPv6 Extension Header,Reference
0,HOPOPT,IPv6 Hop-by-Hop Option,Y,[RFC-ietf-6man-rfc2460bis-13]
1,ICMP,Internet Control Message,,[RFC792]
2,IGMP,Internet Group Management,,[RFC1112]
3,GGP,Gateway-to-Gateway,,[RFC823]
4,IPv4,IPv4 encapsulation,,[RFC2003]
5,ST,Stream,,[RFC1190][RFC1819]
6,TCP,Transmission Control,,[RFC793]
7,CBT,CBT,,[Tony_Ballardie]
8,EGP,Exterior Gateway Protocol,,[RFC888][David_Mills]
9,IGP,"any private interior gateway
(used by Cisco for their IGRP)",,[Internet_Assigned_Numbers_Authority]
10,BBN-RCC-MON,BBN RCC Monitoring,,[Steve_Chipman]
11,NVP-II,Network Voice Protocol,,[RFC741][Steve_Casner]
12,PUP,PUP,,"[Boggs, D., J. Shoch, E. Taft, and R. Metcalfe, ""PUP: An
Internetwork Architecture"", XEROX Palo Alto Research Center,
CSL-79-10, July 1979	 also in IEEE Transactions on
Communication, Volume COM-28, Number 4, April 1980.][[XEROX]]"
13,ARGUS (deprecated),ARGUS,,[Robert_W_Scheifler]
14,EMCON,EMCON,,[<mystery contact>]
15,XNET,Cross Net Debugger,,"[Haverty, J., ""XNET Formats for Internet Protocol Version 4"",
IEN 158, October 1980.][Jack_Haverty]"
16,CHAOS,Chaos,,[J_Noel_Chiappa]
17,UDP,User Datagram,,[RFC768][Jon_Postel]
18,MUX,Multiplexing,,"[Cohen, D. and J. Postel, ""Multiplexing Protocol"", IEN 90,
USC/Information Sciences Institute, May 1979.][Jon_Postel]"
19,DCN-MEAS,DCN Measurement Subsystems,,[David_Mills]
20,HMP,Host Monitoring,,[RFC869][Bob_Hinden]
21,PRM,Packet Radio Measurement,,[Zaw_Sing_Su]
22,XNS-IDP,XEROX NS IDP,,"[""The Ethernet, A Local Area Network: Data Link Layer and
Physical Layer Specification"", AA-K759B-TK, Digital
Equipment Corporation, Maynard, MA.  Also as: ""The
Ethernet - A Local Area Network"", Version 1.0, Digital
Equipment Corporation, Intel Corporation, Xerox
Corporation, September 1980.  And: ""The Ethernet, A Local
Area Network: Data Link Layer and Physical Layer
Specifications"", Digital, Intel and Xerox, November 1982.
And: XEROX, ""The Ethernet, A Local Area Network: Data Link
Layer and Physical Layer Specification"", X3T51/80-50,
Xerox Corporation, Stamford, CT., October 1980.][[XEROX]]"
23,TRUNK-1,Trunk-1,,[Barry_Boehm]
24,TRUNK-2,Trunk-2,,[Barry_Boehm]
25,LEAF-1,Leaf-1,,[Barry_Boehm]
26,LEAF-2,Leaf-2,,[Barry_Boehm]
27,RDP,Reliable Data Protocol,,[RFC908][Bob_Hinden]
28,IRTP,Internet Reliable Transaction,,[RFC938][Trudy_Miller]
29,ISO-TP4,ISO Transport Protocol Class 4,,[RFC905][<mystery contact>]
30,NETBLT,Bulk Data Transfer Protocol,,[RFC969][David_Clark]
31,MFE-NSP,MFE Network Services Protocol,,"[Shuttleworth, B., ""A Documentary of MFENet, a National
Computer Network"", UCRL-52317, Lawrence Livermore Labs,
Livermore, California, June 1977.][Barry_Howard]"
32,MERIT-INP,MERIT Internodal Protocol,,[Hans_Werner_Braun]
33,DCCP,Datagram Congestion Control Protocol,,[RFC4340]
34,3PC,Third Party Connect Protocol,,[Stuart_A_Friedberg]
35,IDPR,Inter-Domain Policy Routing Protocol,,[Martha_Steenstrup]
36,XTP,XTP,,[Greg_Chesson]
37,DDP,Datagram Delivery Protocol,,[Wesley_Craig]
38,IDPR-CMTP,IDPR Control Message Transport Proto,,[Martha_Steenstrup]
39,TP++,TP++ Transport Protocol,,[Dirk_Fromhein]
40,IL,IL Transport Protocol,,[Dave_Presotto]
41,IPv6,IPv6 encapsulation,,[RFC2473]
42,SDRP,Source Demand Routing Protocol,,[Deborah_Estrin]
43,IPv6-Route,Routing Header for IPv6,Y,[Steve_Deering]
44,IPv6-Frag,Fragment Header for IPv6,Y,[Steve_Deering]
45,IDRP,Inter-Domain Routing Protocol,,[Sue_Hares]
46,RSVP,Reservation Protocol,,[RFC2205][RFC3209][Bob_Braden]
47,GRE,Generic Routing Encapsulation,,[RFC2784][Tony_Li]
48,DSR,Dynamic Source Routing Protocol,,[RFC4728]
49,BNA,BNA,,[Gary Salamon]
50,ESP,Encap Security Payload,Y,[RFC4303]
51,AH,Authentication Header,Y,[RFC4302]
52,I-NLSP,Integrated Net Layer Security  TUBA,,[K_Robert_Glenn]
53,SWIPE (deprecated),IP with Encryption,,[John_Ioannidis]
54,NARP,NBMA Address Resolution Protocol,,[RFC1735]
55,MOBILE,IP Mobility,,[Charlie_Perkins]
56,TLSP,"Transport Layer Security Protocol
using Kryptonet key management",,[Christer_Oberg]
57,SKIP,SKIP,,[Tom_Markson]
58,IPv6-ICMP,ICMP for IPv6,,[RFC-ietf-6man-rfc2460bis-13]
59,IPv6-NoNxt,No Next Header for IPv6,,[RFC-ietf-6man-rfc2460bis-13]
60,IPv6-Opts,Destination Options for IPv6,Y,[RFC-ietf-6man-rfc2460bis-13]
61,,any host internal protocol,,[Internet_Assigned_Numbers_Authority]
62,CFTP,CFTP,,"[Forsdick, H., ""CFTP"", Network Message, Bolt Beranek and
Newman, January 1982.][Harry_Forsdick]"
63,,any local network,,[Internet_Assigned_Numbers_Authority]
64,SAT-EXPAK,SATNET and Backroom EXPAK,,[Steven_Blumenthal]
65,KRYPTOLAN,Kryptolan,,[Paul Liu]
66,RVD,MIT Remote Virtual Disk Protocol,,[Michael_Greenwald]
67,IPPC,Internet Pluribus Packet Core,,[Steven_Blumenthal]
68,,any distributed file system,,[Internet_Assigned_Numbers_Authority]
69,SAT-MON,SATNET Monitoring,,[Steven_Blumenthal]
70,VISA,VISA Protocol,,[Gene_Tsudik]
71,IPCV,Internet Packet Core Utility,,[Steven_Blumenthal]
72,CPNX,Computer Protocol Network Executive,,[David Mittnacht]
73,CPHB,Computer Protocol Heart Beat,,[David Mittnacht]
74,WSN,Wang Span Network,,[Victor Dafoulas]
75,PVP,Packet Video Protocol,,[Steve_Casner]
76,BR-SAT-MON,Backroom SATNET Monitoring,,[Steven_Blumenthal]
77,SUN-ND,SUN ND PROTOCOL-Temporary,,[William_Melohn]
78,WB-MON,WIDEBAND Monitoring,,[Steven_Blumenthal]
79,WB-EXPAK,WIDEBAND EXPAK,,[Steven_Blumenthal]
80,ISO-IP,ISO Internet Protocol,,[Marshall_T_Rose]
81,VMTP,VMTP,,[Dave_Cheriton]
82,SECURE-VMTP,SECURE-VMTP,,[Dave_Cheriton]
83,VINES,VINES,,[Brian Horn]
84,TTP,Transaction Transport Protocol,,[Jim_Stevens]
84,IPTM,Internet Protocol Traffic Manager,,[Jim_Stevens]
85,NSFNET-IGP,NSFNET-IGP,,[Hans_Werner_Braun]
86,DGP,Dissimilar Gateway Protocol,,"[M/A-COM Government Systems, ""Dissimilar Gateway Protocol
Specification, Draft Version"", Contract no. CS901145,
November 16, 1987.][Mike_Little]"
87,TCF,TCF,,[Guillermo_A_Loyola]
88,EIGRP,EIGRP,,[RFC7868]
89,OSPFIGP,OSPFIGP,,[RFC1583][RFC2328][RFC5340][John_Moy]
90,Sprite-RPC,Sprite RPC Protocol,,"[Welch, B., ""The Sprite Remote Procedure Call System"",
Technical Report, UCB/Computer Science Dept., 86/302,
University of California at Berkeley, June 1986.][Bruce Willins]"
91,LARP,Locus Address Resolution Protocol,,[Brian Horn]
92,MTP,Multicast Transport Protocol,,[Susie_Armstrong]
93,AX.25,AX.25 Frames,,[Brian_Kantor]
94,IPIP,IP-within-IP Encapsulation Protocol,,[John_Ioannidis]
95,MICP (deprecated),Mobile Internetworking Control Pro.,,[John_Ioannidis]
96,SCC-SP,Semaphore Communications Sec. Pro.,,[Howard_Hart]
97,ETHERIP,Ethernet-within-IP Encapsulation,,[RFC3378]
98,ENCAP,Encapsulation Header,,[RFC1241][Robert_Woodburn]
99,,any private encryption scheme,,[Internet_Assigned_Numbers_Authority]
100,GMTP,GMTP,,[[RXB5]]
101,IFMP,Ipsilon Flow Management Protocol,,"[Bob_Hinden][November 1995, 1997.]"
102,PNNI,PNNI over IP,,[Ross_Callon]
103,PIM,Protocol Independent Multicast,,[RFC7761][Dino_Farinacci]
104,ARIS,ARIS,,[Nancy_Feldman]
105,SCPS,SCPS,,[Robert_Durst]
106,QNX,QNX,,[Michael_Hunter]
107,A/N,Active Networks,,[Bob_Braden]
108,IPComp,IP Payload Compression Protocol,,[RFC2393]
109,SNP,Sitara Networks Protocol,,[Manickam_R_Sridhar]
110,Compaq-Peer,Compaq Peer Protocol,,[Victor_Volpe]
111,IPX-in-IP,IPX in IP,,[CJ_Lee]
112,VRRP,Virtual Router Redundancy Protocol,,[RFC5798]
113,PGM,PGM Reliable Transport Protocol,,[Tony_Speakman]
114,,any 0-hop protocol,,[Internet_Assigned_Numbers_Authority]
115,L2TP,Layer Two Tunneling Protocol,,[RFC3931][Bernard_Aboba]
116,DDX,D-II Data Exchange (DDX),,[John_Worley]
117,IATP,Interactive Agent Transfer Protocol,,[John_Murphy]
118,STP,Schedule Transfer Protocol,,[Jean_Michel_Pittet]
119,SRP,SpectraLink Radio Protocol,,[Mark_Hamilton]
120,UTI,UTI,,[Peter_Lothberg]
121,SMP,Simple Message Protocol,,[Leif_Ekblad]
122,SM (deprecated),Simple Multicast Protocol,,[Jon_Crowcroft][draft-perlman-simple-multicast]
123,PTP,Performance Transparency Protocol,,[Michael_Welzl]
124,ISIS over IPv4,,,[Tony_Przygienda]
125,FIRE,,,[Criag_Partridge]
126,CRTP,Combat Radio Transport Protocol,,[Robert_Sautter]
127,CRUDP,Combat Radio User Datagram,,[Robert_Sautter]
128,SSCOPMCE,,,[Kurt_Waber]
129,IPLT,,,[[Hollbach]]
130,SPS,Secure Packet Shield,,[Bill_McIntosh]
131,PIPE,Private IP Encapsulation within IP,,[Bernhard_Petri]
132,SCTP,Stream Control Transmission Protocol,,[Randall_R_Stewart]
133,FC,Fibre Channel,,[Murali_Rajagopal][RFC6172]
134,RSVP-E2E-IGNORE,,,[RFC3175]
135,Mobility Header,,Y,[RFC6275]
136,UDPLite,,,[RFC3828]
137,MPLS-in-IP,,,[RFC4023]
138,manet,MANET Protocols,,[RFC5498]
139,HIP,Host Identity Protocol,Y,[RFC7401]
140,Shim6,Shim6 Protocol,Y,[RFC5533]
141,WESP,Wrapped Encapsulating Security Payload,,[RFC5840]
142,ROHC,Robust Header Compression,,[RFC5858]
143-252,,Unassigned,,[Internet_Assigned_Numbers_Authority]
253,,Use for experimentation and testing,Y,[RFC3692]
254,,Use for experimentation and testing,Y,[RFC3692]
255,Reserved,,,[Internet_Assigned_Numbers_Authority]
*/


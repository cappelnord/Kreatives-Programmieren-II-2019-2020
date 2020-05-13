# 13.05.2020; Kreatives Programmieren 4

Netzwerkmusik (Vorstellung der Projekte)

## Patricks Beispiel (RTT-Studie)

* Interpretiert die **R**ound-**T**rip-**T**ime verbundener Computer als Zeiten für Feedback-Delays.
* Verbundene Computer können in verschiedenen Gruppen sein. Die Gruppen wechseln sich ab, erklingen dann immer gleichzeitig.
* Tonhöhe, Panorama, etc. wird aus einer zufällig erzeugten ID der verbundenen Computer erzeugt. Im Moment wird dies auch relativ zufällig auf einen möglichen Vorrat an Tonhöhen verteilt.
* Zum Mitmachen: Code & Anweisungen in [rtt-studie/responders.scd](rtt-studie/responders.scd)
+ Zum Zuhören wird ein Link zu einem Webcast verteilt.

## Audio Streaming (Auswahl)

### [JackTrip](https://ccrma.stanford.edu/software/jacktrip/)
* Low Latency / Unkomprimiert
* Stellt hohe Anforderungen an Internetverbindung
* [https://docs.google.com/document/d/18pbu2xQRv521NKvHuYHjIVXRcLFqcDsqYnfKixyuyGg](https://docs.google.com/document/d/18pbu2xQRv521NKvHuYHjIVXRcLFqcDsqYnfKixyuyGg)

### [Icecast](https://www.icecast.org/)
* High Latency / Komprimiert
* Internetradio (kann auch auf Webseite ausgespielt werden)
* Kann für Projekte benutzt werden. Taugt wahrscheinlich am Ende aber nicht wirklich zum Gemeinsamen Spielen sondern nur zur 'Austrahlung' für ein Publikum.
* [Source Clients und mehr Info](https://www.icecast.org/apps/)

### [Ninjam](https://www.cockos.com/ninjam/)
* Komprimiert
* Kompensiert Latenz über Takte, d.h. Musiker spielen 
* Dieser Ansatz wird auch von anderen verfolgt, z.B. [Jammr](https://jammr.net/howitworks.html).

### [trx](http://www.pogo.org.uk/~mark/trx/)
* Relativ geringe Latenz / Komprimiert
* Linux Only

### Kommerzielle Lösungen (teilweise mit Free-Accounts)
* [Cleanfeed](https://cleanfeed.net/)
* [Session Link Pro](https://www.sessionlinkpro.com/)

### WebRTC
* Relativ geringe Latenz / Komprimiert
* Jegliches Video-Konferenz Tool im Browser nutzt diese Technik
* Sehr simples Beispiel: [appr.tc](https://appr.tc)

### Weiteres

* [Audio over Ethernet](https://en.wikipedia.org/wiki/Audio_over_Ethernet) (Wikipedia)
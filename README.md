Hooray
======

Find devices around you. Fast and without hyphens.

    gem install hooray


And use the executable `hoo`:


```
hoo list
```
```
NAME                        | IP            | MAC
----------------------------|---------------|------------------
Motorola Mobility           | 192.168.1.70  | 34:bb:XX:XX:XX:XX
Giga-byte Technology Co.    | 192.168.1.71  | 94:de:XX:XX:XX:XX
Veih's Android              | 192.168.1.72  | 04:46:XX:XX:XX:XX
Nery's LG                   | 192.168.1.73  | cc:fa:XX:XX:XX:XX
nofxx's iPhone              | 192.168.1.77  | 64:a3:XX:XX:XX:XX
LG Electronics              | 192.168.1.79  | cc:fa:XX:XX:XX:XX
TP-Link                     | 192.168.1.253 | f8:d1:XX:XX:XX:XX
Siemens Subscriber Networks | 192.168.1.254 | 00:0b:XX:XX:XX:XX
---
8 devices @ 2014-12-11 13:32:04 -0200 2.85s
```

Find running services:

```
hoo list web
```
```
NAME              | IP           | MAC
------------------|--------------|------------------
nofxx desktop     | 192.168.1.77 | 64:a3:XX:XX:XX:XX
```

Or simply by ports:


```
hoo list 80
hoo list 6777 udp
```

Monitor:

```
hoo watch
```
```
New nodes @ 2014-12-11 13:53:06 -0200
NAME         | IP           | MAC
-------------|--------------|------------------
iPhone nofxx | 192.168.1.76 | 64:a3:XX:XX:XX:XX
```

Use as a lib:
```
require 'hooray'
Hooray::Seek.lan(port, protocol).devices
Hooray::Seek.new(network, port, protocol).devices
```

## Why?

Bind macs or fix IP's is also boring and a per device work.
As more we use wifi/ethernet devices in our company, nmap gets boring.
Not to mention slow, there's no easy way to assign names to devices I know,
which makes OS scan/port scan a needed option most times (thus making it slower).
Also (please open a issue if you know how) even in fast mode nmap won't run in under 2s.
And, on recent updates, you need sudo for all of that.

## How?

```
hoo init
```

A ~/.horray folder is prepopulated:
devices.yml regex list you mac addresses with names you recognize.
services.yml regex list ports to names you recognize.


## Credits

* Ruby net-ping gem.
* Nmap`s mac precompiled prefixes.


Hooray should work on UNIX based systems.
Tested in Linux and OS X.

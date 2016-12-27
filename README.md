# Lying DNS
Make a lyning dns to filter ad servers.

## Main goal
Instead of being tracked and flooded by ads or tracking services while surfing on the Internet, your lying DNS will redirect these requests to your own local blackhole websi

### Benefits
- Stop being tracked by analytics (or stats) services while surfing a a simple webpage.
- Stop being distrubed by ads.
- Install a DNS server and configure your DHCP to be able to use this filter from any devices on the network at once (No need to configure each device). That way, even smartphone will use it.
- No need to use browser plugin.
- As the blackhole website is on LAN, page display is faster.

### Drawbacks
- Lying DNS alters Net Neutrality because you finally filter contents.
- You need a H24 hardware to host your DNS and your blackhole website
- DNS databases should be updated frequently
- Only work on LAN (but you can do it on a personal VPN)
- Need actually a secondary DNS server for unkown website (to not get  "Website not found")

## How it works
You will make a DNS service and a http/https service (on the same server or not). This http/https services named blackhole will be a simple empty html page.
Each DNS requests will be sent to your own DNS server. If your DNS server knows this site as a junk one, it will filter by redirecting it to your own blackhole website.

## Prerequisite
- A linux distro
- wget CLI
- nslookup CLI

## Step 1: Network configuration
### Give a fixed IP to your DNS Server
Here again there is multiple solution:
- Configure your device (ifcfg, iface)
- Configure your DHCP using mac adress to book an IP (solution I chose)

## Step 2: Make your blackhole website
There is multiple option to do that:
- Using [apache] (https://www.apache.org/)
- Using [nginx] (http://nginx.org/en/docs/beginners_guide.html)
- Using [nodejs] (https://nodejs.org/en/). To use an easy and ready solution please see https://github.com/djiworks/blackhole_server

## Step 3: Install bind
```bash 
sudo apt-get update
sudo apt-get install bind9
sudo apt-get clean
```

## Step 4: Configure bind
### Configure a local zone
Go in bind configuration directory `cd /etc/bind/`

First, backup your default file `sudo cp named.conf.local named.conf.local.bak`

Edit then, the named.conf.local file adding:
```
zone "blackhole.org" {
type master;
file "/etc/bind/db.blackhole";
allow-update { none; };
};

zone "0.168.192.in-addr.arpa" {
type master;
file "/etc/bind/db.inverse.blackhole";
allow-update { none; };
};
```
### Configure the zone file
(db.blackhole)

### Add the list a blacklisted sites
(blackhole.conf)

### Configure the blackhole zone
(named.conf)

## Step 5 (optional): Update bind conf
## Step 6: Final network configuration

## Sources
- [Geekfault - DNS Menteur] (http://geekfault.org/2010/04/24/dns-menteur/6/)
- [PGL yoyo] (https://pgl.yoyo.org/adservers/)

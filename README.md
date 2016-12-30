# Lying DNS
Make a lyning dns to filter ad servers.

## Main goal
Instead of being tracked and flooded by ads or tracking services while surfing on the Internet, your lying DNS will redirect these requests to your own local blackhole website

### Benefits
- Stop being tracked by analytics (or stats) services while surfing on a simple webpage.
- Stop being distrubed by ads.
- Install a DNS server and configure your DHCP to be able to use this filter from any devices on the network at once (No need to configure each device). That way, even smartphones will use it.
- No need to use browser plugin.
- As the blackhole website is on LAN, page display is faster.

### Drawbacks
- Lying DNS alters Net Neutrality because you finally filter contents.
- You need a h24 hardware to host your DNS and your blackhole website
- DNS databases should be updated frequently
- Only work on LAN (but you can do it on a personal VPN)
- Need actually a secondary DNS server for unkown website (to not get "Website not found")

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

To be more efficient, your blackhole should be on http and https.

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
/!\ 0.168.192.in-addr.arpa should be replaced by the reverse IP of your network.

### Configure the zone file

Create a db.blackhole file into /etc/bind:
```
$TTL	86400
@	IN	SOA	localhost. root.localhost. (
			      1		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			  86400 )	; Negative Cache TTL
;
@	IN	NS	blackhole.
@	IN	A	192.168.0.2
*	IN	A	192.168.0.2
```
To get more information about meaning of each line please refer to [DNS Record Types](https://help.ubuntu.com/community/BIND9ServerHowto).

### Add the list a blacklisted sites
Now to redirect all known junk websites on your blackhole, create a blackhole.conf file.
Add a line like: `zone "junk-website.com" { type master; notify no; file "/etc/bind/db.blackhole"; };` for each website you want to filter.

To catch them all, simply run `wget -O blackhole.conf "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=bindconfig&showintro=0&mimetype=plaintext&zonefilename=/etc/bind/db.blackhole"`

Please take a look on the content of [this list](https://pgl.yoyo.org/adservers/serverlist.php?hostformat=bindconfig&showintro=0&mimetype=plaintext&zonefilename=/etc/bind/db.blackhole) before. And see if you trust or not this list.

### Configure the blackhole zone
Once you have your list, add it to your DNS configuration using the named.conf file appending `include "/etc/bind/blackhole.conf";`

## Step 5: Final network configuration
### Check bind configuration
Run `named-checkzone blackhole.org db.blackhole`. It should return OK.

### Configure DNS on the server itself
Sometimes you will need to reconfigure the DNS settings of the server itself to erase its own DNS adress.
To do that, edit /etc/resolv.conf by overwriting all the file and putting:
```
search blackhole.org
domain blackhole.org
nameserver 192.168.0.2
# comment all other nameserver
```
Finally, restart your network services using `sudo /etc/init.d/networking restart`

At this step you should now be able to visit your blackhole using your browser typing http://blackhole.org.
`ping blackhole.org` should return the IP of your DNS server.

## Step 6 (optional): Update bind conf
As the provided list (pgl.yoyo.org) is updated frequently,  

## Sources
- [Geekfault - DNS Menteur] (http://geekfault.org/2010/04/24/dns-menteur/6/)
- [PGL yoyo] (https://pgl.yoyo.org/adservers/)

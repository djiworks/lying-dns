# Lying DNS
Make a lyning dns to filter ad servers.

## Main goal
Instead of being tracked and flooded by ads or tracking services while surfing on the Internet, your lying DNS will redirect these requests to your own local blackhole website.

### Benefits
- Stop being tracked by analytics (or stats) services while surfing a a simple webpage.
- Stop being distrubed by ads.
- Install a DNS server and configure your DHCP to be able to use this filter from any devices on the network at once (No need to configure each device). That way, even smartphone will use it.
- No need to use browser plugin.
- As the blackhole website is on LAN, page display is faster.

### Drawbacks
- Lying DNS alters Net Neutrality because you finally filter contents.
- You need a H24 hardware to host your DNS
- only work on LAN (but you can do it on a personal VPN)

## How it works
Each DNS request will be sent to your own DNS server to filter some known ad servers and be redirected to your own blackhole website.
## Sources
- [Geekfault - DNS Menteur] (http://geekfault.org/2010/04/24/dns-menteur/6/)

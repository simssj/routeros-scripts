# From: https://forum.mikrotik.com/viewtopic.php?f=23&t=157048#

# Let's suppose that we have two uplinks: GW1, GW2. It can be addresses of ADSL modems (like 192.168.1.1 and 192.168.2.1), 
#  or addresses of PPP interfaces (like pppoe-out1 and pptp-out1). 
# Then, we have some policy routing rules, so all outgoing traffic is marked with ISP1 (which goes to GW1) and ISP2 (which goes to GW2) marks. 
# And we want to monitor Host1 via GW1, and Host2 via GW2 - those may be some popular Internet websites, like Google, Yahoo, etc.

# First, create routes to those hosts via corresponding gateways:
/ip route
add dst-address=1.1.1.1 gateway=ether1 scope=11
add dst-address=8.8.8.8 gateway=lte1 scope=11

# Now we create rules for ISP1 routing mark (one for main gateway, and another one for failover):
/ip route
add distance=1 gateway=1.1.1.1 target-scope=11 routing-mark=ISP1 check-gateway=ping
add distance=2 gateway=8.8.8.8 target-scope=11 routing-mark=ISP1 check-gateway=ping
#Those routes will be resolved recursively (see Manual:IP/Route#Nexthop_lookup), and will be active only if HostN is pingable.

# Then the same rules for ISP2 mark:
/ip route
add distance=1 gateway=8.8.8.8 target-scope=11 routing-mark=ISP2 check-gateway=ping
add distance=2 gateway=1.1.1.1 target-scope=11 routing-mark=ISP2 check-gateway=ping



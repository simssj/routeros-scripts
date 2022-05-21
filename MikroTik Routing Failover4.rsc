# From: https://help.mikrotik.com/docs/pages/viewpage.action?pageId=26476608

# Before detailed example overview, in a setup where we have private IP addresses behind the public IP, we should configure source NAT:
/ip/firewall/nat
add chain=srcnat action=masquerade out-interface=ether1
add chain=srcnat action=masquerade out-interface=lte1

# Let`s start with marking traffic with configuring routing tables and firewall mangle rules, so we will have everything preconfigured when we go to the routing section:
/routing/table
add fib name=to_ISP1
add fib name=to_ISP2
 
/ip/firewall/mangle
add chain=output connection-state=new connection-mark=no-mark action=mark-connection new-connection-mark=ISP1_conn out-interface=ether1
add chain=output connection-mark=ISP1_conn action=mark-routing new-routing-mark=to_ISP1 out-interface=ether1
add chain=output connection-state=new connection-mark=no-mark action=mark-connection new-connection-mark=ISP2_conn out-interface=lte1
add chain=output connection-mark=ISP2_conn action=mark-routing new-routing-mark=to_ISP2 out-interface=lte1

# We will split the routing configuration into three parts. First, we will configure Host1 and Host2 as destination addresses in the routing section:
/ip/route/
add dst-address=8.8.8.8 scope=10 gateway=192.168.8.1
add dst-address=8.8.4.4 scope=10 gateway=192.168.1.1

# Now configure routes that will be resolved recursively, so they will only be active when they are reachable with ping:
/ip/route/
add distance=1 gateway=8.8.8.8 routing-table=to_ISP1 check-gateway=ping
add distance=2 gateway=8.8.4.4 routing-table=to_ISP1 check-gateway=ping

# Configure similar recursive routes for the second gateway:
/ip/route/
add distance=1 gateway=8.8.4.4 routing-table=to_ISP2 check-gateway=ping
add distance=2 gateway=8.8.8.8 routing-table=to_ISP2 check-gateway=ping

# Adding Multiple Hosts
# In the case where Host1 and Host2 fail, the corresponding link is considered failed too. In this section, we will use two additional hosts for redundancy. In our example, we will use OpenDNS servers Host1B (208.67.222.222) and Host2B (208.67.220.220):

/ip/route
add dst-address=8.8.8.8 gateway=192.168.8.1 scope=10
add dst-address=208.67.222.222 gateway=192.168.8.1 scope=10
add dst-address=8.8.4.4 gateway=192.168.1.1 scope=10
add dst-address=208.67.220.220 gateway=192.168.1.1 scope=10

# Then, let's create destinations to "virtual" hops to use in further routes. We will use 10.10.10.1 and 10.20.20.2 as an example, but you can use different ones, be sure they do not override other configured IP addresses in your setup:
/ip/route
add dst-address=10.10.10.1 gateway=8.8.8.8 scope=10 target-scope=10 check-gateway=ping
add dst-address=10.10.10.1 gateway=208.67.222.222 scope=10 target-scope=10 check-gateway=ping
add dst-address=10.20.20.2 gateway=8.8.4.4 scope=10 target-scope=10 check-gateway=ping
add dst-address=10.20.20.2 gateway=208.67.220.220 scope=10 target-scope=10 check-gateway=ping

# Do not forget to add routes with routing marks:
/ip/route
add distance=1 gateway=10.10.10.1 routing-table=to_ISP1
add distance=2 gateway=10.20.20.2 routing-table=to_ISP1
add distance=1 gateway=10.20.20.2 routing-table=to_ISP2
add distance=2 gateway=10.10.10.1 routing-table=to_ISP2

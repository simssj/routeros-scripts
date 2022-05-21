# Thus a very basic Recursive Dual WAN failover would look like thus.....
/ip route
add check-gateway=ping distance=3 dst-address=0.0.0.0/0 gateway=1.0.0.1 scope=10 target-scope=12
add distance=3 dst-address=1.0.0.1/32 gateway=10.254.254.1 scope=10 target-scope=11
add comment=SecondaryISP distance=10 dst-address=0.0.0.0/0 gateway=10.254.253.1 scope=10 target-scope=30

# Thus a Recursive Dual WAN failover using TWO external DNS sites to check connectivity in a simple FLAT approach would look like this....
/ip route
add check-gateway=ping distance=3 dst-address=0.0.0.0/0 gateway=1.0.0.1 scope=10 target-scope=12
add check-gateway=ping distance=4 dst-address=0.0.0.0/0 gateway=9.9.9.9 scope=10 target-scope=12
add distance=3 dst-address=1.0.0.1/32 gateway=10.254.254.1 scope=10 target-scope=11
add distance=4 dst-address=9.9.9.9/32 gateway=10.254.254.1 scope=10 target-scope=11
add comment=SecondaryISP distance=10 dst-address=0.0.0.0/0 gateway=10.254.253.1 scope=10 target-scope=30

# Thus a Recursive Dual WAN failover using TWO external DNS sites to check connectivity using the LAYERED or NESTED approach would look like this....
/ip route
add dst-address=0.0.0.0/0 gateway=10.10.10.10 scope=12 target-scope=14
# +++++++++++++++++
add check-gateway=ping dst-address=10.10.10.10/32 gateway=1.0.0.1 scope=14 target-scope=13
add dst-address=1.0.0.1/32 gateway=10.254.254.1 scope=13 target-scope=12
# +++++++++++++++++
add check-gateway=ping dst-address=10.10.10.10/32 gateway=9.9.9.9 scope=14 target-scope=13
add dst-address=9.9.9.9/32 gateway=10.254.254.1 scope=13 target-scope=12
# +++++++++++++++++
add comment=SecondaryISP distance=10 dst-address=0.0.0.0/0 gateway=10.254.253.1 scope=10 target-scope=30

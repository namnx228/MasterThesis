list_netns=$(sudo ip netns list | grep default -v | awk '{print $1}' )
for i in ${list_netns}
do
 sudo ip  netns  exec $i  iptables -D INPUT 1
 sudo ip  netns  exec $i  iptables -D INPUT 1
 sudo ip  netns  exec $i  iptables -D OUTPUT 1
 sudo ip  netns  exec $i  iptables -D OUTPUT 1
 sudo ip  netns  exec $i  iptables -A INPUT -s 10.0.0.0/28 -d 10.0.0.0/28 -j ACCEPT
 sudo ip  netns  exec $i  iptables -A OUTPUT -s 10.0.0.0/28 -d 10.0.0.0/28 -j ACCEPT
 sudo ip  netns  exec $i  iptables -A INPUT  -s 10.0.0.0/16 -d 10.0.0.0/16 -j DROP
 sudo ip  netns  exec $i  iptables -A OUTPUT  -s 10.0.0.0/16 -d 10.0.0.0/16 -j DROP
done


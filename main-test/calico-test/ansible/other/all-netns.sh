list_netns=$(sudo ip netns list | grep default -v )
for i in ${list_netns}
do
  ip  netns $i exec iptables -D INPUT 1
  ip  netns $i exec iptables -D INPUT 1
  ip  netns $i exec iptables -D OUTPUT 1
  ip  netns $i exec iptables -D OUTPUT 1
  ip  netns $i exec iptables -A INPUT -s 10.0.0.0/28 -d 10.0.0.0/28 -j ACCEPT
  ip  netns $i exec iptables -A OUTPUT -s 10.0.0.0/28 -d 10.0.0.0/28 -j ACCEPT
  ip  netns $i exec iptables -A INPUT  -s 10.0.0.0/16 -d 10.0.0.0/16 -j DROP
  ip  netns $i exec iptables -A OUTPUT  -s 10.0.0.0/16 -d 10.0.0.0/16 -j DROP
done


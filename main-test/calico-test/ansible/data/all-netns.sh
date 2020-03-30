if [ ! -L  /var/run/netns ]
then
 sudo ln -s /var/run/docker/netns  /var/run/netns 
fi

list_netns=$(sudo ip netns list | grep default -v |  awk '{print $1}'  )
for i in ${list_netns}
do
  sudo ip  netns  exec $i iptables -D INPUT 1
  sudo ip  netns  exec $i iptables -D INPUT 1
  sudo ip  netns  exec $i iptables -D OUTPUT 1
  sudo ip  netns  exec $i iptables -D OUTPUT 1
  sudo ip  netns  exec $i iptables -A INPUT -s 172.16.0.0/28 -d 172.16.0.0/28 -j ACCEPT
  sudo ip  netns  exec $i iptables -A OUTPUT -s 172.16.0.0/28 -d 172.16.0.0/28 -j ACCEPT
  sudo ip  netns  exec $i iptables -A INPUT  -s 172.16.0.0/16 -d 172.16.0.0/16 -j DROP
  sudo ip  netns  exec $i iptables -A OUTPUT  -s 172.16.0.0/16 -d 172.16.0.0/16 -j DROP
done


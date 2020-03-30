set -ex
kubectl apply -f ../namespace.yml
pushd .
cd user
./user_creation_flags.sh -u test1 -g O -d 500
./user_creation_flags.sh -u test2 -g O -d 500
popd
# Assign IP ranges
calicoctl apply -f ../pools.yml
kubectl annotate ns test1 "cni.projectcalico.org/ipv4pools"='["pool1"]'  --overwrite
kubectl annotate ns test2 "cni.projectcalico.org/ipv4pools"='["pool2"]'  --overwrite

cd ..
kubectl apply -f role_ns1.yml
kubectl apply -f role_ns2.yml
kubectl apply -f role-binding-ns1.yml
kubectl apply -f role-binding-ns2.yml

# calicoctl apply -f isolation-vlan1.yml


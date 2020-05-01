#!/usr/bin/env bash
set -ex
NUMOFTENANT=$(($(ls ../namespace/ | wc -l) - 1))

for i in $(seq 1 $NUMOFTENANT)
do
  calicoctl delete -f ../pool/pools-${i}.yml | true
  sleep 3 # Wait for termination
  calicoctl apply -f ../pool/pools-${i}.yml | true
done
kubectl delete -f ../namespace/ | true
sleep 10
kubectl apply -f ../namespace/

pushd .
cd user/
for i in $(seq 1 ${NUMOFTENANT} )
do
  ./user_creation_flags.sh -u "test$i" -g O -d 500
  kubectl annotate ns "test$i" "cni.projectcalico.org/ipv4pools"='["pool${i}"]'  --overwrite  | true
done
popd
# Assign IP ranges
# calicoctl delete ippool default-ipv4-ippool # Delete the default ippool, so it is possible to create and allocate IPs manually


kubectl delete -f ../role/ | true
sleep 10
kubectl apply -f ../role/

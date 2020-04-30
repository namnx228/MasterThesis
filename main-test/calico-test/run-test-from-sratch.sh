set -ex
NUMOFTENANT=$(($(ls namespace/ | wc -l) - 1))
for i in $(seq 1 $NUMOFTENANT)
do
  calicoctl apply -f pool/pools-${i}.yml | true
done
kubectl apply -f namespace/
pushd .
cd user
for i in $(seq 1 ${NUMOFTENANT} )
do
  ./user_creation_flags.sh -u "test$i" -g O -d 500
  kubectl annotate ns "test$i" "cni.projectcalico.org/ipv4pools"='["pool${i}"]'  --overwrite
done
popd

kubectl apply -f role/



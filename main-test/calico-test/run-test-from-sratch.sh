set -ex
calicoctl apply -f pool/
kubectl apply -f namespace/
NUMOFTENANT=$(($(ls namespace/ | wc -l) - 1))
# echo $NUMOFTENANT
pushd .
cd user
for i in $(seq 1 ${NUMOFTENANT} )
do
  ./user_creation_flags.sh -u "test$i" -g O -d 500
  kubectl annotate ns "test$i" "cni.projectcalico.org/ipv4pools"='["pool${i}"]'  --overwrite
done
popd

kubectl apply -f role/



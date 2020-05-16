#!/usr/bin/env bash
set -ex
NUMOFTENANT=$(($(ls ../namespace/ | wc -l) - 1))
MAXNUMOFTENANTS=1024

EXISTNS=$(kubectl get ns | grep "test" -c) || true
echo
if (( $EXISTNS > 0 ))
then
  # for i in  $(seq 1 $EXISTNS)
  # do
  #   kubectl delete ns test${i} || true
  #   # kubectl delete -f ../role/role-binding-${i}.yml | true
  # done
  set +e
  for i in $(kubectl get ns | grep test | awk '{ print $1 }')
  do
    kubectl delete ns $i
  done
  while true
  do
    if (( $(kubectl get ns | grep test -c) > 0  ))
    then
      break
    fi
  done
  set -e
fi

EXISTPOOL=$( python -c "print $(calicoctl get ippool | grep pool -c) - 1" )  || true
if (( $EXISTPOOL > 0 ))
then
  for i in  $(seq 1 $EXISTPOOL)
  do
    calicoctl delete  ippool pool${i} || true
  done
fi

# EXISTROLE=$(kubectl get role --all-namespaces | grep "test" -c) || true
# if (( $EXISTROLE > 0 ))
# then
#   for i in  $(seq 1 $EXISTROLE)
#   do
#     kubectl delete role test${i} -n test${i} || true
#   done
# fi

sleep 10

kubectl apply -f ../namespace/

for i in $(seq 1 ${NUMOFTENANT})
do
  calicoctl apply -f ../pool/pools-${i}.yml
done

pushd .
cd user/
for i in $(seq 1 ${NUMOFTENANT} )
do
  ./user_creation_flags.sh -u "test$i" -g O -d 500
  kubectl annotate ns "test$i" "cni.projectcalico.org/ipv4pools"="[\"pool${i}\"]"  --overwrite  || true
done
popd
# Assign IP ranges
# calicoctl delete ippool default-ipv4-ippool # Delete the default ippool, so it is possible to create and allocate IPs manually


kubectl apply -f ../role/
kubectl apply -f ../role-binding/

# Deploy sidecar injector
./deploy-sidecar-injector.sh

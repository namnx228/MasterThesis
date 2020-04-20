# docker images namnx228/perf-sidecar-injector-amd64 -q | xargs -r docker rmi -f
# make release
kubectl delete -f deployment/deployment.yaml
sleep 6
kubectl apply -f deployment/deployment.yaml
# cd ~/MasterThesis/main-test/calico-test/sidecar/k8s-sidecar-injector/examples/kubernetes
cd ../

NAMESPACE=default
if (( $# != 0 ))
then
  NAMESPACE=$1
fi

kubectl delete -f nginx-deployment/ -n $NAMESPACE
sleep 10
kubectl apply -f nginx-deployment/ -n $NAMESPACE


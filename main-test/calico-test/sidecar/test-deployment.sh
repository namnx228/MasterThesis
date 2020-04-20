# docker images namnx228/perf-sidecar-injector-amd64 -q | xargs -r docker rmi -f
# make release
kubectl delete -f deployment/deployment.yaml
sleep 6
kubectl apply -f deployment/deployment.yaml
# cd ~/MasterThesis/main-test/calico-test/sidecar/k8s-sidecar-injector/examples/kubernetes
cd ../
kubectl delete -f nginx-deployment/
sleep 10
kubectl apply -f nginx-deployment/


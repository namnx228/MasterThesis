./deployment/webhook-create-signed-cert.sh \
    --service perf-sidecar-injector-webhook-svc \
    --secret perf-sidecar-injector-webhook-certs \
    --namespace default

cat deployment/mutatingwebhook.yaml | \
    deployment/webhook-patch-ca-bundle.sh > \
    deployment/mutatingwebhook-ca-bundle.yaml

kubectl create -f deployment/configmap.yaml
kubectl create -f deployment/deployment.yaml
kubectl create -f deployment/service.yaml
kubectl create -f deployment/mutatingwebhook-ca-bundle.yaml

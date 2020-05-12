#!/usr/bin/env bash
set -ex
REPLICAS=${1:-2} # default number of pods is 2
kubectl delete deployment test1 || true
cat <<SHELL
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test1
  labels:
    app: nginx
spec:
  replicas: ${REPLICAS}
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
SHELL | kubectl apply -f -


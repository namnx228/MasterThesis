#!/usr/bin/env bash
set -ex
shopt -s expand_aliases
alias kubectl="kubectl -n ${USER}"
DEPLOYMENT_NAME="experienment1"
REPLICAS=${1:-2} # default number of pods is 2
kubectl delete deployment ${DEPLOYMENT_NAME} || true
cat <<SHELL | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${DEPLOYMENT_NAME}
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
SHELL

checkDeploymentAvailable (){
  kubectl get deployments.apps ${DEPLOYMENT_NAME} -o jsonpath="{.status.replicas}"
}

loopUntilFoundTime(){
  while true
  do
    isAvailable=$(checkDeploymentAvailable)
    if [[ ${isAvailable} == $REPLICAS ]]
    then
      break
    fi
  done
}

time loopUntilFoundTime

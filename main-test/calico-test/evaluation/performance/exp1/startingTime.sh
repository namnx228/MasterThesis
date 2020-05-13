#!/usr/bin/env bash
set -ex
shopt -s expand_aliases
alias kubectl="kubectl -n ${USER}"
DEPLOYMENT_NAME="experienment1"
REPLICAS_PARAS=${1:-2} # default number of pods is 2

#----------Functions---------------------
checkDeploymentAvailable (){
  kubectl get deployments.apps ${DEPLOYMENT_NAME} -o jsonpath="{.status.replicas}"
}

loopUntilFoundTime(){
  while true do
    isAvailable=$(checkDeploymentAvailable)
    if [[ ${isAvailable} == $REPLICAS ]]
    then
      break
    fi
  done
}

#---------------------------------------
# FUnction: input: number of pods
runTestOneTime() {
  REPLICAS=${1:-2} # default number of pods is 2
  kubectl delete deployment ${DEPLOYMENT_NAME}  > /dev/null || true
  cat <<SHELL | kubectl apply -f - > /dev/null
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
  # set +x
  time loopUntilFoundTime   
  # set -x
}

run30Time(){
  let sum=0 || true
  let thisTime=0 || true
  for i in $(seq 1 30)
  do
  # use bash only
    # runTestOneTime ${REPLICAS_PARAS}
    thisTime=$(TIMEFORMAT=%R runTestOneTime ${REPLICAS_PARAS})
    sum=$(python -c "print ${sum} + ${thisTime}")
  done
  result=$(python -c "print ${sum} / 30.0")
  echo ${result}
}

run30Time

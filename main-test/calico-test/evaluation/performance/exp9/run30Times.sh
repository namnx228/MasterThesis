#!/usr/bin/env bash
set -ex
shopt -s expand_aliases
alias kubectl="kubectl -n ${USER}"
SERVER_POD="api-rtt-server"
CLIENT_DEPLOYMENT="api-rtt-client"
SERVICE="api-rtt-service"
CLIENT_IMAGES="namnx228/k8s-multitenancy-api-rtt-amd64"
SERVER_IMAGES="nginx:1.14.2"
SERVER_PORT=8000
TESTING_TIME=2
REPLICAS_PARAS=${1:-1} # Now: 1


#---------------------------------------
getCol(){
  echo ${@: -2}
}
checkClientDeploymentAvailable (){
  kubectl get pod  ${CLIENT_DEPLOYMENT} | grep Running -c
}

checkServerPodAvailable (){
  kubectl get pod ${SERVER_POD} | grep Running -c
}

loopUntilAvailabe()
{
  while true 
  do
    isServerAvailable=$(checkServerPodAvailable)
    if (( ${isServerAvailable} !=  0 ))
    then
      break
    fi
  done

  deployClient > /dev/null
  while true 
  do 
    isClientAvailable=$(checkClientDeploymentAvailable)

    if [[ ${isClientAvailable}  > 0 ]] 
    then
      sleep $(python -c "print $TESTING_TIME + 1") 
      client_log=$(kubectl logs ${CLIENT_DEPLOYMENT} ${CLIENT_DEPLOYMENT} | grep time_total | awk '{print $2}' )
      if [[ ${client_log} != ""  ]]
      then
        echo ${client_log}
        break
      # else
        # deployClient > /dev/null
      fi
    fi
  done
}

checkClientTerminated (){
  kubectl get pod ${CLIENT_DEPLOYMENT}  2> /dev/null
}

loopUntilCLientTerminated(){
  while true
  do
    if [[ $(checkClientTerminated) == "" ]]
    then
      break
    fi
  done
}

deployClient(){
  kubectl delete  pod ${CLIENT_DEPLOYMENT}  > /dev/null || true
  loopUntilCLientTerminated > /dev/null
  cat <<SHELL | kubectl apply -f - > /dev/null  # Deploy client 
    apiVersion: v1
    kind: Pod
    metadata:
      name: ${CLIENT_DEPLOYMENT}
      labels:
        app: ${CLIENT_DEPLOYMENT}
    spec:
        containers:
        - name: ${CLIENT_DEPLOYMENT}
          image: ${CLIENT_IMAGES}
          command:
            - bash
          args:
            - "-c"
            - "curl -w '@curl-format' ${SERVICE}:${SERVER_PORT} && sleep 7200"
          imagePullPolicy: IfNotPresent
SHELL
}
#----------------------------------------
# FUnction: input: number of pods
runTestOneTime() {
  # Delete old thing
  # Deploy new thing: Only one client
  # sleep 3 to wait for connection done
  # Collect result: How ?

  REPLICAS=${1:-1} # Now: 1
  kubectl delete pod --force --grace-period=0 ${SERVER_POD}  > /dev/null || true
  kubectl delete svc ${SERVICE}  > /dev/null || true
  cat <<SHELL | kubectl apply -f - > /dev/null # Deploy server pod
    apiVersion: v1
    kind: Pod
    metadata:
      name: ${SERVER_POD}
      labels:
        app: ${SERVER_POD}
    spec:
      containers:
      - name: ${SERVER_POD}
        image: ${SERVER_IMAGES}
        ports:
          - containerPort: 80
        imagePullPolicy: IfNotPresent
      restartPolicy: Always
SHELL

  cat <<SHELL | kubectl apply -f - > /dev/null # Deploy server service
    apiVersion: v1
    kind: Service
    metadata:
      name: ${SERVICE}
    spec:
      selector:
        app: ${SERVER_POD}
      ports:
        - protocol: TCP
          port: ${SERVER_PORT}
          targetPort: 80
SHELL

  # deployClient # Deploy in the loopUntilAvailable
  sleep 3 # Wait until server deployment is done
  echo $(loopUntilAvailabe)
}

run30Time(){
  let sum=0 || true
  let thisTime=0 || true
  for i in $(seq 1 31)
  do
    if (( $i == 1 ))
    then
      continue
    fi
    thisTime=$(runTestOneTime ${REPLICAS_PARAS})
    sum=$(python -c "print ${sum} + ${thisTime}")
  done
  kubectl delete pod ${DEPLOYMENT_NAME}  > /dev/null || true
  result=$(python -c "print ${sum} / 30.0")
  echo ${result} "ms"
}

run30Time
